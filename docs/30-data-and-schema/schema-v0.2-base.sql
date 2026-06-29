-- Exponential Jyotish Companion
-- Schema v0.2 base overlay
--
-- Goals:
-- 1. Keep embeddings provider-neutral while D5 is open.
-- 2. Keep memory default manual while moving confirmation to end-of-chat review.
-- 3. Support future multi-subject analyses without overfitting to marriage matching.
-- 4. Use reviewed/labeled Jyotish knowledge without gatekeeping all negativity.
-- 5. Make model routing explicit so open-source/open-weight models can be validated safely.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;

DO $$ BEGIN
  CREATE TYPE profile_kind AS ENUM ('self', 'related_person', 'match_subject', 'other');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE lifecycle_status AS ENUM ('active', 'stale', 'superseded', 'archived', 'deleted');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE analysis_status AS ENUM ('queued', 'running', 'complete', 'failed', 'superseded', 'archived');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE model_role AS ENUM ('chat', 'embedding', 'extractor', 'evaluator', 'moderation', 'reranker', 'speech', 'other');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE knowledge_chunk_status AS ENUM ('raw', 'needs_review', 'reviewed', 'rejected', 'deprecated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE delivery_policy AS ENUM (
    'allow_normal',
    'allow_caution',
    'transform_required',
    'internal_only',
    'blocked'
  );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE memory_candidate_status AS ENUM ('pending_review', 'saved', 'edited_saved', 'discarded', 'expired');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE model_route_status AS ENUM ('active', 'shadow', 'disabled', 'deprecated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE safety_label AS ENUM (
    'safe',
    'sensitive',
    'fatalistic',
    'medical',
    'financial',
    'legal',
    'self_harm',
    'exploitative',
    'unknown'
  );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS model_catalog (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  role model_role NOT NULL,
  provider text NOT NULL,
  model_name text NOT NULL,
  dimensions integer,
  deployment_mode text NOT NULL DEFAULT 'hosted' CHECK (deployment_mode IN ('hosted', 'self_hosted', 'local', 'hybrid')),
  context_window_tokens integer,
  supports_tools boolean NOT NULL DEFAULT false,
  supports_streaming boolean NOT NULL DEFAULT false,
  supports_json_mode boolean NOT NULL DEFAULT false,
  distance_metric text NOT NULL DEFAULT 'cosine',
  license_notes text,
  data_terms jsonb NOT NULL DEFAULT '{}'::jsonb,
  status lifecycle_status NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (role, provider, model_name)
);

COMMENT ON TABLE model_catalog IS
  'Provider/model registry. For embeddings, dimensions is recorded here instead of being baked into domain tables.';

CREATE TABLE IF NOT EXISTS model_routes (
  route_key text PRIMARY KEY,
  purpose text NOT NULL,
  primary_model_id uuid REFERENCES model_catalog(id),
  fallback_model_ids uuid[] NOT NULL DEFAULT ARRAY[]::uuid[],
  evaluator_model_id uuid REFERENCES model_catalog(id),
  route_config jsonb NOT NULL DEFAULT '{}'::jsonb,
  status model_route_status NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO model_routes (route_key, purpose)
VALUES
  ('runtime_astrologer', 'Main conversational astrologer response generation.'),
  ('profile_synthesizer', 'One-shot interpretive profile generation.'),
  ('memory_extractor', 'Conversation memory candidate extraction.'),
  ('prediction_evaluator', 'Grounding, tone, safety, and responsible prediction review.'),
  ('embedding_memory', 'Memory embedding generation.'),
  ('embedding_knowledge', 'Knowledge embedding generation.'),
  ('safety_classifier', 'Fast safety and crisis classification.')
ON CONFLICT (route_key) DO NOTHING;

COMMENT ON TABLE model_routes IS
  'Configurable model router. Allows open-source/open-weight and hosted models to be swapped by route.';

CREATE TABLE IF NOT EXISTS model_eval_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  model_id uuid NOT NULL REFERENCES model_catalog(id),
  route_key text NOT NULL REFERENCES model_routes(route_key),
  eval_suite text NOT NULL,
  eval_version text NOT NULL,
  scores jsonb NOT NULL DEFAULT '{}'::jsonb,
  pass boolean NOT NULL DEFAULT false,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS model_eval_runs_model_idx
  ON model_eval_runs (model_id, route_key, created_at DESC);

CREATE TABLE IF NOT EXISTS birth_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid NOT NULL,
  profile_kind profile_kind NOT NULL DEFAULT 'self',
  display_name text NOT NULL,
  relationship_label text,
  birth_date date NOT NULL,
  birth_time time,
  birth_time_known boolean NOT NULL DEFAULT true,
  birth_place text NOT NULL,
  birth_lat numeric(9, 6),
  birth_lon numeric(9, 6),
  birth_timezone text NOT NULL,
  status lifecycle_status NOT NULL DEFAULT 'active',
  supersedes_id uuid REFERENCES birth_profiles(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS birth_profiles_one_active_self
  ON birth_profiles (owner_user_id)
  WHERE profile_kind = 'self' AND status = 'active';

CREATE INDEX IF NOT EXISTS birth_profiles_owner_idx
  ON birth_profiles (owner_user_id, profile_kind, status);

COMMENT ON TABLE birth_profiles IS
  'Saved subjects. V1 uses one active self profile; future features can add related people or match subjects without colliding with self.';

CREATE TABLE IF NOT EXISTS charts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid NOT NULL,
  birth_profile_id uuid NOT NULL REFERENCES birth_profiles(id),
  chart_object jsonb NOT NULL,
  chart_schema_version text NOT NULL,
  facts_sheet_text text NOT NULL,
  engine_provider text NOT NULL,
  engine_version text NOT NULL,
  ayanamsa text NOT NULL DEFAULT 'Lahiri',
  house_system text NOT NULL,
  birth_time_known boolean NOT NULL,
  status lifecycle_status NOT NULL DEFAULT 'active',
  supersedes_id uuid REFERENCES charts(id),
  computed_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS charts_one_active_per_profile
  ON charts (birth_profile_id)
  WHERE status = 'active';

CREATE INDEX IF NOT EXISTS charts_owner_idx
  ON charts (owner_user_id, status, computed_at DESC);

COMMENT ON TABLE charts IS
  'Immutable computed chart snapshots. Active periods and transits are computed on demand, not mutated here.';

CREATE TABLE IF NOT EXISTS user_settings (
  user_id uuid PRIMARY KEY,
  memory_mode text NOT NULL DEFAULT 'manual' CHECK (memory_mode IN ('off', 'manual', 'auto')),
  chart_style_pref text NOT NULL DEFAULT 'north_indian',
  language_pref text NOT NULL DEFAULT 'en',
  privacy_prefs jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON COLUMN user_settings.memory_mode IS
  'Real default is manual: candidates are collected during chat and reviewed at end-of-chat/CSAT.';

CREATE TABLE IF NOT EXISTS memory_candidates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid NOT NULL,
  conversation_id uuid,
  source_message_id uuid,
  proposed_fact text NOT NULL,
  proposed_category text NOT NULL DEFAULT 'other',
  confidence numeric(4, 3),
  extractor_model_id uuid REFERENCES model_catalog(id),
  prompt_version text,
  status memory_candidate_status NOT NULL DEFAULT 'pending_review',
  reviewed_at timestamptz,
  saved_memory_fact_id uuid,
  expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS memory_candidates_review_idx
  ON memory_candidates (owner_user_id, status, created_at DESC);

COMMENT ON TABLE memory_candidates IS
  'Manual-mode memory suggestions shown during end-of-chat/CSAT review instead of interrupting live chat.';

CREATE TABLE IF NOT EXISTS memory_facts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid NOT NULL,
  fact text NOT NULL,
  category text NOT NULL DEFAULT 'other',
  source_message_id uuid,
  confidence numeric(4, 3),
  status lifecycle_status NOT NULL DEFAULT 'active',
  supersedes_id uuid REFERENCES memory_facts(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS memory_facts_owner_idx
  ON memory_facts (owner_user_id, category, status);

DO $$ BEGIN
  ALTER TABLE memory_candidates
    ADD CONSTRAINT memory_candidates_saved_memory_fact_fk
    FOREIGN KEY (saved_memory_fact_id) REFERENCES memory_facts(id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS model_invocations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid,
  route_key text NOT NULL REFERENCES model_routes(route_key),
  model_id uuid REFERENCES model_catalog(id),
  prompt_version text,
  input_tokens integer,
  output_tokens integer,
  ttft_ms integer,
  total_latency_ms integer,
  cost_estimate_usd numeric(12, 6),
  cache_hit boolean,
  fallback_used boolean NOT NULL DEFAULT false,
  status text NOT NULL DEFAULT 'complete' CHECK (status IN ('complete', 'failed', 'timeout', 'blocked')),
  trace_id text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS model_invocations_route_idx
  ON model_invocations (route_key, model_id, created_at DESC);

CREATE TABLE IF NOT EXISTS knowledge_sources (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  source_type text NOT NULL,
  citation text,
  license_notes text,
  source_uri text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS knowledge_chunks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id uuid NOT NULL REFERENCES knowledge_sources(id),
  chunk_text text NOT NULL,
  chunk_hash text NOT NULL,
  topic_tags text[] NOT NULL DEFAULT ARRAY[]::text[],
  safety_labels safety_label[] NOT NULL DEFAULT ARRAY['unknown']::safety_label[],
  confidence_label text NOT NULL DEFAULT 'unreviewed',
  delivery_policy delivery_policy NOT NULL DEFAULT 'internal_only',
  status knowledge_chunk_status NOT NULL DEFAULT 'needs_review',
  reviewed_for_user_retrieval boolean NOT NULL DEFAULT false,
  reviewer_notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (source_id, chunk_hash)
);

CREATE INDEX IF NOT EXISTS knowledge_chunks_retrievable_idx
  ON knowledge_chunks (status, reviewed_for_user_retrieval, delivery_policy);

COMMENT ON TABLE knowledge_chunks IS
  'Reviewed Jyotish knowledge. Negative/challenging chunks may be retrieved when reviewed; delivery_policy controls framing.';

CREATE TABLE IF NOT EXISTS text_embeddings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid,
  entity_type text NOT NULL CHECK (entity_type IN ('memory_fact', 'knowledge_chunk', 'analysis_run', 'message', 'other')),
  entity_id uuid NOT NULL,
  model_id uuid NOT NULL REFERENCES model_catalog(id),
  dimensions integer NOT NULL CHECK (dimensions > 0),
  embedding vector NOT NULL,
  content_hash text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (vector_dims(embedding) = dimensions),
  UNIQUE (entity_type, entity_id, model_id, content_hash)
);

CREATE INDEX IF NOT EXISTS text_embeddings_lookup_idx
  ON text_embeddings (entity_type, entity_id, model_id);

COMMENT ON TABLE text_embeddings IS
  'Provider-neutral embeddings. Add a model-specific pgvector index after the embedding model is selected.';

-- Example after D5 is resolved:
-- CREATE INDEX CONCURRENTLY text_embeddings_active_model_hnsw
--   ON text_embeddings USING hnsw ((embedding::vector(1024)) vector_cosine_ops)
--   WHERE model_id = '<chosen-embedding-model-id>';

CREATE TABLE IF NOT EXISTS analysis_types (
  key text PRIMARY KEY,
  display_name text NOT NULL,
  description text NOT NULL,
  min_subjects integer NOT NULL DEFAULT 1 CHECK (min_subjects > 0),
  max_subjects integer CHECK (max_subjects IS NULL OR max_subjects >= min_subjects),
  deterministic_required boolean NOT NULL DEFAULT true,
  user_visible boolean NOT NULL DEFAULT false,
  status lifecycle_status NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO analysis_types (key, display_name, description, min_subjects, max_subjects, deterministic_required, user_visible)
VALUES
  ('natal_profile', 'Natal profile', 'Single-chart chart facts and interpretive profile.', 1, 1, true, true),
  ('compatibility', 'Compatibility analysis', 'Two-or-more-subject compatibility analysis, including future Kundali matching variants.', 2, NULL, true, false),
  ('muhurta', 'Muhurta analysis', 'Electional timing analysis for a proposed event window.', 1, NULL, true, false)
ON CONFLICT (key) DO NOTHING;

CREATE TABLE IF NOT EXISTS analysis_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid NOT NULL,
  analysis_type_key text NOT NULL REFERENCES analysis_types(key),
  status analysis_status NOT NULL DEFAULT 'queued',
  input_fingerprint text NOT NULL,
  algorithm_version text NOT NULL,
  chart_schema_version text,
  deterministic_result jsonb NOT NULL DEFAULT '{}'::jsonb,
  facts_sheet_text text,
  narrative_text text,
  model_id uuid REFERENCES model_catalog(id),
  model_route_key text REFERENCES model_routes(route_key),
  prompt_version text,
  persona_version text,
  safety_policy_version text NOT NULL,
  confidence jsonb NOT NULL DEFAULT '{}'::jsonb,
  report_object_uri text,
  supersedes_id uuid REFERENCES analysis_runs(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);

CREATE INDEX IF NOT EXISTS analysis_runs_owner_idx
  ON analysis_runs (owner_user_id, analysis_type_key, status, created_at DESC);

COMMENT ON TABLE analysis_runs IS
  'Generic versioned analyses. Compatibility/marriage matching is one analysis type, not the schema center.';

CREATE TABLE IF NOT EXISTS prediction_evaluations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid,
  analysis_run_id uuid REFERENCES analysis_runs(id) ON DELETE SET NULL,
  message_id uuid,
  evaluator_model_id uuid REFERENCES model_catalog(id),
  route_key text REFERENCES model_routes(route_key),
  grounding_pass boolean NOT NULL DEFAULT false,
  delivery_pass boolean NOT NULL DEFAULT false,
  safety_pass boolean NOT NULL DEFAULT false,
  categories text[] NOT NULL DEFAULT ARRAY[]::text[],
  action text NOT NULL DEFAULT 'allow' CHECK (action IN ('allow', 'repair_delivery', 'redirect', 'block')),
  notes text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS prediction_evaluations_owner_idx
  ON prediction_evaluations (owner_user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS analysis_run_subjects (
  analysis_run_id uuid NOT NULL REFERENCES analysis_runs(id) ON DELETE CASCADE,
  birth_profile_id uuid REFERENCES birth_profiles(id),
  chart_id uuid REFERENCES charts(id),
  subject_role text NOT NULL DEFAULT 'primary',
  ordinal integer NOT NULL DEFAULT 1,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (analysis_run_id, ordinal),
  CHECK (birth_profile_id IS NOT NULL OR chart_id IS NOT NULL)
);

CREATE INDEX IF NOT EXISTS analysis_run_subjects_profile_idx
  ON analysis_run_subjects (birth_profile_id, subject_role);

CREATE INDEX IF NOT EXISTS analysis_run_subjects_chart_idx
  ON analysis_run_subjects (chart_id, subject_role);

CREATE TABLE IF NOT EXISTS interpretive_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid NOT NULL,
  chart_id uuid NOT NULL REFERENCES charts(id),
  analysis_run_id uuid REFERENCES analysis_runs(id),
  profile_text text NOT NULL,
  profile_schema_version text NOT NULL,
  model_id uuid REFERENCES model_catalog(id),
  prompt_version text NOT NULL,
  persona_version text NOT NULL,
  status lifecycle_status NOT NULL DEFAULT 'active',
  supersedes_id uuid REFERENCES interpretive_profiles(id),
  generated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS interpretive_profiles_chart_idx
  ON interpretive_profiles (chart_id, status, generated_at DESC);

COMMENT ON TABLE interpretive_profiles IS
  'Generated once per chart version, but may be regenerated/superseded on model or persona upgrades.';

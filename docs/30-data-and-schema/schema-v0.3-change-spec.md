# Schema v0.3 - Change Spec (Jyotish Companion / Exponential)

> Engineering change spec derived from the schema review that benchmarks Exponential's
> data-architecture v0.2 against the SagePilot production schema (a mature B2B reference).
> This file is the source of truth for the v0.3 migration. **All changes are additive.**
>
> Status: v0.1 - 2026-06-29 - Postgres 15+ - extensions: `vector`, `pgcrypto`, `pg_trgm`, `citext`

## Context

The current schema (21 tables, B2C, `user_id`-scoped, immutable chart JSONB, hybrid memory) is
well-judged and rightly leaner than the reference. The gaps are mostly **operational durability**
plus a few decisions that are cheap now and painful later. This spec closes them without changing
the core design.

## Invariants to preserve (do not regress)

These are correct - a refactor must keep them intact:

- **Per-message cost/latency accounting** on `messages` (`tokens`, `ttft_ms`, `cost_usd`, `prompt_cache_hit`).
- **Memory table shape**: `memories(fact, category, status, supersedes_id, source_message_id, embedding)` - supersede chain + provenance + soft delete.
- **Correlation keys only** in Postgres (`trace_id`, `model_version`, `prompt_version`); full traces live in the external tracer.
- **Immutable chart as one JSONB contract** (`charts.chart_object`), computed by the engine, never written by the LLM.
- **`user_id` + RLS** tenancy (no `workspace_id`). This is correct for B2C; do not add a workspace abstraction.

## Changes

### 1. Durable async backbone - `async_tasks` outbox (P0)

**Why.** Profile synthesis, memory extraction, PDF rendering, and embedding all run async, but the
schema has no jobs/outbox table and no retry/locking state, so failures are invisible and
non-recoverable. The reference runs almost nothing slow in the request path via a transactional
outbox (`ai_command_outbox` with a unique `idempotency_key` + a `WHERE status='pending'` partial
index) plus retry trios on every worker-fed table (`es_sync_attempts`/`es_sync_locked_at`/`es_sync_error`).

**What.** Add the `async_tasks` table (DDL below). Workers claim with `FOR UPDATE SKIP LOCKED`,
honour `attempts`/`max_attempts`/`next_retry_at` with exponential backoff. Anything triggered by an
external event (payment webhook, push receipt) routes through it for the idempotency key. **Pick one
model - outbox OR per-table retry columns - not both.**

### 2. Embedding lifecycle + HNSW index (P0)

**Why.** `memories.embedding` has no model/version column and no re-embed queue. When the embedding
model changes (still an open decision - see Gates), every row must be re-embedded with no way to
track or queue it. The reference has a dedicated `embedding_batch_jobs` table and `embedding_status`
partial indexes precisely because re-embedding at scale is recurring.

**What.** Add `embedding_model`, `embedding_generated_at`, `embedding_status` to `memories`; add the
HNSW vector index and a re-embed partial index. **Do not hardcode the vector dimension** - the schema
currently commits `vector(1536)`; the reference uses `1024`. The dimension must match the chosen model
and the index exactly, so read it from config.

### 3. Hybrid retrieval - lexical + vector (P0)

**Why.** Vector-only recall misses exact-term matches ("my daughter's name is Anya"). The reference
never relies on embeddings alone - `knowledge_base` carries a generated `chunk_ts_vector` **and**
`embedding` **and** `tf_stats` for hybrid scoring, plus trigram GIN indexes for fuzzy matches.

**What.** Add a generated `fact_tsv` tsvector + GIN on `memories`, and change the memory-retrieval
query to hybrid (vector union lexical). Apply the same pattern to the knowledge table if present.

### 4. Current-memory hot path (P1)

**Why.** With a supersede chain + soft delete, the per-turn read path must filter
`status='active'` on every turn. The reference uses the `_current` snapshot pattern
(`profile_variable_values_current`, `segment_memberships_current`) for exactly this.

**What.** Add a `WHERE status='active'` partial index on `memories` (and/or a `memories_current` view),
and make the retrieval read path exclude superseded/deleted rows by default so RLS never surfaces them.

### 5. Webhook dedupe + idempotent usage (P1)

**Why.** App Store Server Notifications, Play RTDN, and Stripe webhooks all retry and can arrive out
of order. The reference has `stripe_webhook_events` doing this dedupe.

**What.** Add `billing_webhook_events(provider, provider_event_id UNIQUE, ...)` and make subscription
webhook handlers idempotent against it. Make `usage_counters` increments idempotent per request id.

### 6. Time reproducibility on the chart (P1)

**Why.** `charts` records `ayanamsa`/`house_system`/`engine_version` for reproducibility (good) but
not the time resolution. A historical birth in a region whose DST rules were later corrected will
recompute to a *different* chart after a routine tzdata update - breaking the
"identical input -> identical immutable chart" guarantee behind `birth_input_hash`.

**What.** Add `birth_utc_offset_minutes` (the offset actually used) and `tzdb_version` to `charts`,
and populate them in the chart-compute path.

### Smaller refinements

- Add `attempts` + `last_error` wherever a `pending/ready/failed` enum exists.
- Ensure every mutable table has an `updated_at` touch trigger (or app-level equivalent).
- Keep `analytics_events` out of Postgres - send to PostHog/Amplitude; roll up the per-message cost columns outside the OLTP DB.
- Consider message-level embeddings later (`messages.embedding_status`) for raw-turn recall beyond the extracted-memory layer.

## Schema v0.3 delta (DDL)

```sql
-- 1. Durable async backbone: transactional outbox --------------------
CREATE TYPE async_task_kind AS ENUM (
  'chart_compute','profile_synthesis','chart_render_pdf',
  'memory_extract','memory_embed','knowledge_embed','webhook_dispatch'
);
CREATE TYPE async_task_status AS ENUM ('pending','processing','succeeded','failed','dead');

CREATE TABLE async_tasks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid REFERENCES users(id) ON DELETE CASCADE,   -- nullable for system tasks
  kind            async_task_kind   NOT NULL,
  payload         jsonb             NOT NULL DEFAULT '{}'::jsonb,
  idempotency_key text UNIQUE,                                    -- dedupe external triggers
  status          async_task_status NOT NULL DEFAULT 'pending',
  attempts        int   NOT NULL DEFAULT 0,
  max_attempts    int   NOT NULL DEFAULT 8,
  locked_at       timestamptz,
  locked_by       text,
  next_retry_at   timestamptz NOT NULL DEFAULT now(),
  last_error      text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);
-- claim: SELECT ... WHERE status IN ('pending','failed') AND next_retry_at <= now()
--        ORDER BY next_retry_at FOR UPDATE SKIP LOCKED;
CREATE INDEX idx_async_tasks_claimable
  ON async_tasks (next_retry_at)
  WHERE status IN ('pending','failed');

-- 2. Embedding lifecycle on memories ---------------------------------
ALTER TABLE memories
  ADD COLUMN embedding_model        text,
  ADD COLUMN embedding_generated_at timestamptz,
  ADD COLUMN embedding_status       text NOT NULL DEFAULT 'pending';  -- pending|ready|failed

-- vector index: dimension MUST match the chosen embedding model (1024 vs 1536 is an open decision)
CREATE INDEX idx_memories_embedding
  ON memories USING hnsw (embedding vector_cosine_ops);

-- re-embed queue
CREATE INDEX idx_memories_embed_pending
  ON memories (updated_at)
  WHERE embedding_status IN ('pending','failed');

-- 3. Hybrid retrieval: lexical half ----------------------------------
ALTER TABLE memories
  ADD COLUMN fact_tsv tsvector
    GENERATED ALWAYS AS (to_tsvector('simple', coalesce(fact,''))) STORED;
CREATE INDEX idx_memories_fact_tsv ON memories USING gin (fact_tsv);
-- NOTE: fact_tsv + embedding require plaintext `fact` visible to Postgres.
-- If `fact` is envelope-encrypted, DROP these and run lexical+vector in app space (see Gates).

-- 4. Current-memory hot path -----------------------------------------
CREATE INDEX idx_memories_active
  ON memories (user_id, category)
  WHERE status = 'active';

-- 5. Provider webhook dedupe -----------------------------------------
CREATE TABLE billing_webhook_events (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider          text NOT NULL,            -- apple|google|stripe
  provider_event_id text NOT NULL,
  payload           jsonb NOT NULL,
  received_at       timestamptz NOT NULL DEFAULT now(),
  processed_at      timestamptz,
  UNIQUE (provider, provider_event_id)
);
ALTER TABLE usage_counters ADD COLUMN last_request_id text;  -- or a usage_ledger(request_id UNIQUE)

-- 6. Chart reproducibility -------------------------------------------
ALTER TABLE charts
  ADD COLUMN birth_utc_offset_minutes int,
  ADD COLUMN tzdb_version             text;   -- e.g. '2025b'

-- (optional) retry state on derived-artifact tables, if NOT using async_tasks for them
ALTER TABLE interpretive_profiles
  ADD COLUMN attempts int NOT NULL DEFAULT 0,
  ADD COLUMN locked_at timestamptz,
  ADD COLUMN next_retry_at timestamptz,
  ADD COLUMN last_error text;
CREATE INDEX idx_interpretive_profiles_pending
  ON interpretive_profiles (next_retry_at)
  WHERE status IN ('pending','failed','stale');
```

## Open decisions / gates (do not silently resolve)

- **Encryption vs searchability.** The lexical/vector indexes require plaintext `memories.fact`
  (and `messages.content`). If those columns are envelope-encrypted at the app layer, you cannot
  index them - decide per-column whether to encrypt or to index. The reference chose searchability
  for chat content. **This must be a human decision, not an agent default.**
- **Embedding model + dimension** (1024 vs 1536). Sets the HNSW dimension. Parameterize; do not hardcode.
- **Outbox vs per-table retry columns** (change #1). Pick one model.

## Downstream surface to update (keep schema and code in sync)

After the migration, update: the canonical `schema.sql` (or ORM models), generated types/DTOs, the
memory-retrieval repository/query layer (hybrid recall + active-only filter), the chart-compute path
(populate tz fields), the subscription webhook handlers (idempotent against `billing_webhook_events`),
and add a worker/consumer for `async_tasks`.

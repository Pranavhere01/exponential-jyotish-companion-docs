# Schema v0.3 Discovery and Implementation Plan

Status: blocked for direct migration in this repo  
Date: 2026-06-29  
Branch: `feat/schema-v0.3`  
Source spec: `docs/schema-v0.3-change-spec.md`

## Executive summary

The v0.3 spec is valuable, but it targets a fuller application schema than this repository currently contains. This repo is a documentation and canonical-schema repo with one raw SQL base file. It does not contain the application code, migration framework, ORM models, worker code, webhook handlers, retrieval repositories, or a runnable Postgres scratch database.

Because the user's instruction says "if anything in the repo contradicts the spec or makes a change unsafe, stop and ask rather than forcing it," this branch records the source-of-truth spec and the safe implementation plan instead of applying incompatible DDL.

## Discovery

### Languages and DB layer

- Repository type: documentation/schema artifact repo.
- Languages present: Markdown, HTML, shell, SQL.
- Application language: not present.
- Migration tool: not present.
- ORM/query builder: not present.
- Canonical schema location: `db/schema_v0_2_base.sql`.
- Existing schema style: raw PostgreSQL SQL using `CREATE TABLE IF NOT EXISTS`, guarded enum creation blocks, and explicit indexes.

### Tables named by the v0.3 spec

| Spec table | Repo status | Notes |
| --- | --- | --- |
| `charts` | Present | In `db/schema_v0_2_base.sql`; stores immutable `chart_object`, `facts_sheet_text`, engine metadata, ayanamsa, house system, and lifecycle status. |
| `memories` | Not present | Closest table is `memory_facts`. v0.2 intentionally stores vectors separately in `text_embeddings` for provider neutrality. |
| `messages` | Not present | The repo has `model_invocations` and prompt/eval artifacts, but no chat transcript table. |
| `interpretive_profiles` | Present | Has chart/profile/model/prompt/persona status fields. |
| `chart_artifacts` | Not present | No rendered chart/PDF artifact table exists here. |
| `conversations` | Not present | `memory_candidates` has nullable `conversation_id`, but no parent table. |
| `usage_counters` | Not present | No billing/usage schema exists here. |
| `subscriptions` | Not present | No subscription schema or webhook handlers exist here. |
| `users` | Not present | Existing tables use `owner_user_id uuid` without a local FK. The spec DDL references `users(id)`. |
| Knowledge table | Present under different names | `knowledge_sources` and `knowledge_chunks`, with embeddings in `text_embeddings`. |

### Background jobs

No app worker or background job framework exists in this repo. The system design mentions async work, but there is no queue consumer, scheduler, job runner, or app service code to wire.

### Postgres version and extensions

- Required by spec: Postgres 15+ with `vector`, `pgcrypto`, `pg_trgm`, and `citext`.
- Locally verified database: not available. `psql` is not installed in the current environment, so migration up/down cannot be run on a scratch DB from this repo.
- Current canonical schema enables only:
  - `pgcrypto`
  - `vector`
- Missing from current canonical schema:
  - `pg_trgm`
  - `citext`

## Why the v0.3 DDL is blocked here

1. The DDL alters `memories`, but the repo has `memory_facts` plus `text_embeddings`, not `memories.embedding`.
2. The DDL references `users(id)`, but no `users` table is defined in this repo.
3. The DDL alters `usage_counters`, but no `usage_counters` table exists.
4. The DDL assumes app surfaces that are absent here: memory retrieval repository, chart-compute path, webhook handlers, DTO/types, worker/consumer code, seed data, and tests.
5. The v0.2 schema already made a provider-neutral embedding decision: embeddings live in `text_embeddings` with `dimensions` checked by `vector_dims(embedding)`. Adding `memories.embedding` would undo that design unless the product deliberately changes direction.

## Decision gates before applying SQL

### Gate 1 - Target repository

Confirm whether v0.3 should be implemented in:

- this documentation/schema repo, as a canonical design artifact only; or
- the actual application repo that contains migrations, ORM models, workers, repositories, webhook handlers, and tests.

### Gate 2 - Memory table mapping

Choose one:

- Map spec `memories` to current `memory_facts` and keep vectors in `text_embeddings`.
- Rename/adopt a future `memories` table in the app schema.
- Add a compatibility view named `memories` over `memory_facts` only if downstream app code needs that name.

Recommended for current architecture: map `memories` to `memory_facts` and keep embedding vectors in `text_embeddings`.

### Gate 3 - Embedding model and dimension

Do not hardcode 1024 or 1536. The current v0.2 design records embedding dimensions in `model_catalog.dimensions` and `text_embeddings.dimensions`.

Recommended implementation:

- keep `text_embeddings.embedding vector` unconstrained at the column declaration;
- enforce actual row dimensions with `CHECK (vector_dims(embedding) = dimensions)`;
- create model-specific HNSW indexes only after the embedding model is chosen;
- put the chosen embedding model in config/model routing, not in domain tables.

### Gate 4 - Encryption vs searchability

The lexical indexes require plaintext available to Postgres:

- memory text: `memory_facts.fact`
- knowledge text: `knowledge_chunks.chunk_text`
- future messages: `messages.content`

If the app envelope-encrypts any of those fields, do not add generated tsvector or trigram indexes over ciphertext. Decide column by column which data must be searchable in Postgres.

### Gate 5 - Outbox vs per-table retry columns

The spec says to pick one model. Recommended: use `async_tasks` as the single outbox/retry backbone, then avoid per-table retry state except where an external provider requires local sync metadata.

## Ordered implementation plan after gates are answered

1. Confirm target repo and migration framework. If raw SQL remains the canonical format, create a new numbered migration and update the canonical schema file in the same change.
2. Add missing extensions additively: `pg_trgm` and `citext`, while keeping `pgcrypto` and `vector`.
3. Add `async_task_kind`, `async_task_status`, and `async_tasks`. In this repo's naming style, use `owner_user_id` unless/until a real `users` FK exists.
4. Add an async worker in the app repo. Claim tasks with `FOR UPDATE SKIP LOCKED`, increment `attempts`, respect `max_attempts`, set `next_retry_at` using exponential backoff, and mark `dead` after final failure.
5. Wire one reference job through the worker. Recommended first job: `memory_embed`, because the schema already has `memory_candidates`, `memory_facts`, and `text_embeddings`.
6. Add embedding lifecycle state without hardcoding dimensions. In the current v0.2 model, this likely belongs on `text_embeddings` or a small embedding job/status table, not on `memory_facts`.
7. Add hybrid retrieval only if plaintext search is approved. For this repo's current table names, that means generated `fact_tsv` on `memory_facts` and generated `chunk_tsv` on `knowledge_chunks`.
8. Add active-memory hot path support. For current names, add a partial index on `memory_facts(owner_user_id, category) WHERE status = 'active'` and optionally a `memory_facts_current` view.
9. Add webhook dedupe only in the app/billing schema. If `subscriptions` and `usage_counters` are not present, create a usage ledger with `request_id UNIQUE` instead of a mutable `last_request_id` column.
10. Add chart reproducibility columns to `charts`: `birth_utc_offset_minutes` and `tzdb_version`; populate them in chart computation from the timezone resolver used at compute time.
11. Update downstream application surfaces: ORM/models, generated types, repositories, workers, webhook handlers, DTOs, seeds/fixtures, and tests.
12. Run migration up/down against a scratch Postgres 15+ DB with `vector`, `pgcrypto`, `pg_trgm`, and `citext`; then run type-check, lint, and tests.

## Candidate repo-specific SQL shape

This is not applied yet. It is a guide for the next engineer once gates are answered.

```sql
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS citext;

-- Use owner_user_id to match current schema unless a users table is introduced.
CREATE TYPE async_task_kind AS ENUM (
  'chart_compute',
  'profile_synthesis',
  'chart_render_pdf',
  'memory_extract',
  'memory_embed',
  'knowledge_embed',
  'webhook_dispatch'
);

CREATE TYPE async_task_status AS ENUM ('pending', 'processing', 'succeeded', 'failed', 'dead');

CREATE TABLE async_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid,
  kind async_task_kind NOT NULL,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  idempotency_key text UNIQUE,
  status async_task_status NOT NULL DEFAULT 'pending',
  attempts integer NOT NULL DEFAULT 0,
  max_attempts integer NOT NULL DEFAULT 8,
  locked_at timestamptz,
  locked_by text,
  next_retry_at timestamptz NOT NULL DEFAULT now(),
  last_error text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_async_tasks_claimable
  ON async_tasks (next_retry_at)
  WHERE status IN ('pending', 'failed');

ALTER TABLE charts
  ADD COLUMN birth_utc_offset_minutes integer,
  ADD COLUMN tzdb_version text;

-- Only if plaintext search is approved:
ALTER TABLE memory_facts
  ADD COLUMN fact_tsv tsvector
    GENERATED ALWAYS AS (to_tsvector('simple', coalesce(fact, ''))) STORED;

CREATE INDEX idx_memory_facts_fact_tsv
  ON memory_facts USING gin (fact_tsv);

CREATE INDEX idx_memory_facts_active
  ON memory_facts (owner_user_id, category)
  WHERE status = 'active';

ALTER TABLE knowledge_chunks
  ADD COLUMN chunk_tsv tsvector
    GENERATED ALWAYS AS (to_tsvector('simple', coalesce(chunk_text, ''))) STORED;

CREATE INDEX idx_knowledge_chunks_chunk_tsv
  ON knowledge_chunks USING gin (chunk_tsv);
```

## Draft PR description

### Summary

- Added `docs/schema-v0.3-change-spec.md` as the source-of-truth v0.3 change spec.
- Added this discovery and implementation plan to document the repo mismatch, blocked migration gates, and safe next steps.
- Updated repo indexes and exports so the v0.3 work remains versioned and MCP-friendly.

### Change rationale

- Async backbone: v0.3 change 1 calls for a durable `async_tasks` outbox because profile synthesis, memory extraction, PDF rendering, and embeddings should not fail invisibly in the request path.
- Embedding lifecycle: v0.3 change 2 calls for model/version/re-embed tracking, but this repo already stores embeddings in `text_embeddings`; implementation must preserve provider neutrality unless intentionally changed.
- Hybrid retrieval: v0.3 change 3 calls for lexical plus vector recall so exact facts like names are not missed by vector-only search.
- Current-memory hot path: v0.3 change 4 calls for active-only memory retrieval so superseded/deleted memory is not surfaced by default.
- Webhook dedupe: v0.3 change 5 calls for provider event de-duplication because billing webhooks retry and can arrive out of order.
- Chart reproducibility: v0.3 change 6 calls for `birth_utc_offset_minutes` and `tzdb_version` so chart recomputation stays explainable after timezone database changes.

### Validation

- `scripts/verify_artifacts.sh`

### Not included

- No SQL migration was applied because the spec references tables and app code absent from this repo (`users`, `memories`, `messages`, `usage_counters`, `subscriptions`, workers, repositories, webhooks, and DTOs).
- Migration up/down was not run because no migration framework or local `psql` binary is present in this repo environment.

### Open decisions

- Encryption vs searchability: decide which text columns may remain searchable in Postgres.
- Embedding model and dimension: choose model/config before creating model-specific HNSW indexes.
- Outbox vs per-table retry columns: recommended default is outbox-only.

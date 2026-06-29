# Completion Audit

Date: 2026-06-29  
Goal source: `/Users/pranavkumar/.codex/attachments/53b9dfb4-5ef0-4894-9fdb-f044f59b562f/goal-objective.md`

## Requirement-by-requirement status

### 1. Build a model router for plug-and-play models

Status: complete locally.

Evidence:

- PRD v0.2 defines `R-MODEL-01` through `R-MODEL-07` in `docs/product/requirements/prd-v0.2.md`.
- System Design v0.2 defines the model-router architecture in `docs/architecture/system/system-design-v0.2.md`.
- Schema includes `model_catalog`, `model_routes`, `model_eval_runs`, and `model_invocations` in `docs/engineering/data-model/schema-v0.2-base.sql`.
- ADR 0004 records the model-router decision in `docs/governance/decisions/adr/0004-model-router-and-open-model-strategy.md`.
- Versioned prompt artifacts exist under `docs/ai/prompts/`.
- Versioned eval artifacts exist under `docs/ai/evaluation/`.

### 2. Move Manual memory questions to end-of-chat / CSAT

Status: complete locally.

Evidence:

- PRD v0.2 defines end-of-chat memory review in `R-MEM-04` through `R-MEM-06`.
- System Design v0.2 defines the Manual memory flow through `memory_candidates` and CSAT/session review.
- Schema includes `memory_candidates`.
- ADR 0006 records end-of-chat memory review.
- PM guide explains the flow in the Manual memory section.

### 3. Do not gatekeep negativity; use evaluator plus prompt

Status: complete locally.

Evidence:

- PRD v0.2 defines `R-PRED-01` through `R-PRED-09`.
- System Design v0.2 defines the prompt plus evaluator prediction-delivery path.
- ADR 0005 records the two-layer approach: astrologer prompt plus evaluator.
- Schema includes `prediction_evaluations` and delivery policy labels.
- PM guide answers "Evaluator agent or system prompt?" with "Use both."
- `docs/ai/prompts/astrologer-persona-v0.2.md` and `docs/ai/prompts/prediction-evaluator-v0.2.md` make this behavior version-controlled.

### 4. Keep knowledge reviewed but not positive-only

Status: complete locally.

Evidence:

- ADR 0002 was revised from "safe chunks only" to "reviewed Jyotish knowledge retrieval."
- System Design v0.2 defines reviewed/labeled Jyotish retrieval and `delivery_policy`.
- PRD v0.2 defines `R-KNOW-01` through `R-KNOW-08`, including that approved/reviewed does not mean positive-only.
- Schema replaces the old approval-only retrieval flag with `reviewed_for_user_retrieval` and `delivery_policy`.

### 5. Validate open-source Chinese model plan

Status: complete as a product validation plan; model benchmark execution remains future engineering work.

Evidence:

- PRD v0.2 includes the open-source/open-weight Chinese model validation plan and candidate families: Qwen, DeepSeek, Kimi, GLM.
- ADR 0004 records that these models are candidates behind the router, not a hard-coded product dependency.
- `docs/ai/evaluation/model-router-validation-v0.1.md` and `docs/ai/evaluation/model-router-cases-v0.1.jsonl` seed the validation harness.

### 6. Make marriage matching an example of generic future extensibility

Status: complete locally.

Evidence:

- PRD v0.2 includes `R-ANALYSIS-*` and `R-MATCH-*`.
- System Design v0.2 defines the generic `analysis_types` / `analysis_runs` / `analysis_run_subjects` architecture.
- Schema uses `analysis_types`, `analysis_runs`, and `analysis_run_subjects`.
- ADR 0003 records the extension-ready analysis model.

### 7. Edit and enhance the PRD

Status: complete locally.

Evidence:

- `docs/product/requirements/prd-v0.2.md` is the enhanced PRD source.
- `docs/architecture/system/system-design-v0.2.md` is the companion system-design source for the same decisions.
- `exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md` is the Drive-ready text export.

### 8. Set up on GitHub

Status: docs repository published locally/remotely; platform repository split is in progress.

Evidence:

- Repository has an initial commit: `38b5221 Initialize Jyotish Companion docs base`.
- Documentation/resources repository target: `Pranavhere01/exponential-jyotish-companion-docs`.
- Main platform repository target: `Pranavhere01/exponential-jyotish-companion-platform`.
- `.github/pull_request_template.md` exists.
- `.github/workflows/verify-artifacts.yml` exists and runs `scripts/verify_artifacts.sh`.
- `.github/workflows/deploy-docs-pages.yml` exists to publish the MkDocs site from `main`.
- `.gitignore` exists.
- `docs/operations/repository/github-setup.md` documents the publish commands, private repo setup, and `main`/`dev` branch policy.
- `scripts/publish_to_github_after_auth.sh` creates the private repo if needed, pushes clean `main` plus working `dev`, and can invite a collaborator when a GitHub username is provided.
- `docs/handbook/version-manifest.md` records current source and export artifact versions.
- Local branch state: `main` is the stable baseline; `dev` is the working branch.

Blocker:

- Collaborator username is still needed before access can be shared.
- Platform repository needs to be created and pushed after the repo split commit.

Required external action:

```bash
scripts/publish_to_github_after_auth.sh Pranavhere01/exponential-jyotish-companion-docs <github-username>
```

Then create or push the platform repository.

### 9. Store documentation in Exponential shared Google Drive folder

Status: prepared locally; upload is blocked by Drive connector visibility.

Evidence:

- Local Drive-style export package exists under `exports/google-drive/Exponential/Astrology/Documents/`.
- HTML export exists in `exports/google-drive/Exponential/Astrology/Documents/Html/`.
- Text exports exist in `exports/google-drive/Exponential/Astrology/Documents/Text/`.
- Prompt and eval artifacts have flattened text exports in the same `Text` package.

Blocker:

- The Google Drive connector cannot see the screenshot folder IDs from this session. Metadata/list calls for the visible folder IDs returned `404`, `400`, or empty listings.
- Screenshot-visible folder IDs:
  - `Exponential`: `1WwsQmCiCqZxCctNEfqdnGwKJjtC2ChWf`
  - `Astrology`: `1by8WT9dQ_jgxEd5irK5vy3A4fwYyZBzI`
  - `Documents`: `1uLn5DvIVTMw2yWJ83xM8TEx_a68wqwwb`
- Live re-check on 2026-06-29: Drive search for accessible folders named `Exponential`, `Astrology`, and `Documents` returned no matching folders.
- Live metadata re-check on 2026-06-29: `Exponential` and `Astrology` returned `404`; `Documents` returned `400`.
- The connector can see the individual Google Doc `System Design & Technical Architecture — Personal AI Astrologer`, but its parent IDs are not exposed.
- The Google Doc URL in the objective resolves to `Fundamentals - ML and MLops`, not the Jyotish PRD. It should not be edited as the PRD without explicit confirmation.

Required external action:

- Reconnect the Google Drive connector to the account that can see the shared `Exponential` folder, or provide folder IDs visible to the connector.

### 10. Apply schema v0.3 changes from the engineering spec

Status: source-of-truth spec and implementation plan are complete locally; direct migration is blocked because this repo is not the runnable application repo.

Evidence:

- `docs/engineering/data-model/schema-v0.3-change-spec.md` records the v0.3 engineering change spec as a versioned artifact.
- `docs/engineering/data-model/schema-v0.3-discovery-and-plan.md` records the discovery result, table mapping mismatch, blocked gates, ordered implementation plan, and draft PR description.
- `docs/handbook/version-manifest.md` now tracks both v0.3 schema artifacts and their export copies.
- Export copies exist under `exports/google-drive/Exponential/Astrology/Documents/Text/`.
- Local branch `dev` contains the v0.3 work, including commit `513b470 Add schema v0.3 discovery plan`.

Blocker:

- The v0.3 DDL targets tables and app code absent from this repo: `users`, `memories`, `messages`, `usage_counters`, `subscriptions`, workers, repositories, webhook handlers, DTOs, and a migration framework.
- The current schema uses `memory_facts` plus provider-neutral `text_embeddings`; applying `memories.embedding` directly would contradict the v0.2 embedding design without a human decision.

Required external action:

- Provide the runnable application repo, or confirm that this docs/schema repo should receive a canonical SQL-only v0.3 design migration with explicit mappings from `memories` to `memory_facts` and from app billing tables to new schema tables.

## Current conclusion

The local source-of-truth repo is ready and committed with `main` as the clean stable baseline and `dev` as the working branch. The remaining unfinished pieces are external publishing tasks (GitHub remote/auth, collaborator username, and Google Drive connector access) plus the app-level schema v0.3 implementation, which requires the runnable application repository or explicit schema mapping decisions.

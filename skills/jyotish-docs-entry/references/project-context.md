# Project Context

Repository: `exponential-jyotish-companion-docs`

Purpose: canonical product, architecture, schema, prompt, eval, governance, and source material repository for Jyotish Companion.

## Core Product Invariants

- Deterministic chart computation is chart truth.
- The LLM may interpret chart facts but must not invent chart facts.
- Manual memory is the default; candidates are reviewed at end-of-chat or CSAT.
- Model calls route through `model_routes`.
- Embeddings stay provider-neutral in `text_embeddings`.
- Jyotish knowledge is reviewed and labeled, but not positive-only.
- Difficult predictions are allowed when grounded and responsibly delivered.
- Compatibility and other future features use generic `analysis_runs`.
- Context graph is Postgres-first and complements vector/hybrid retrieval.

## Important Paths

- Product: `docs/product/requirements/prd-v0.2.md`
- System design: `docs/architecture/system/system-design-v0.2.md`
- Context graph pattern: `docs/architecture/patterns/context-graph-knowledge-system/README.md`
- Schema base: `docs/engineering/data-model/schema-v0.2-base.sql`
- Schema v0.3 plan: `docs/engineering/data-model/schema-v0.3-discovery-and-plan.md`
- ADRs: `docs/governance/decisions/adr/`
- Artifact registry: `docs/handbook/artifact-registry.yaml`
- Metadata standard: `docs/handbook/metadata-standard.md`
- Relation types: `docs/handbook/relation-types.md`
- Domain knowledge: `docs/domain-knowledge/`

## Publishing

Branch policy:

- `dev`: working branch.
- `main`: published/stable branch for GitHub Pages.

Verification:

- `git diff --check`
- `scripts/verify_artifacts.sh`
- `mkdocs build --strict`

Public docs site:

- `https://pranavhere01.github.io/exponential-jyotish-companion-docs/`

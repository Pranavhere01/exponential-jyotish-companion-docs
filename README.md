# Exponential Jyotish Companion Docs

Version-controlled product, architecture, SOP, prompt, eval, and schema context for the Exponential Jyotish Companion project.

## Source of truth

This repository is the canonical documentation home from day 1. Google Drive, PDFs, slides, and HTML exports may exist for sharing, but they are derived copies. Product decisions, schema changes, prompts, SOPs, and architecture notes should land here first so they can be reviewed, versioned, and indexed through MCP.

## How this repo is organized

The docs use a library-shelf structure so new material has an obvious home:

- `docs/00-start-here/` - orientation, knowledge map, version manifest, contribution guide.
- `docs/10-product/` - PM-facing product direction, PRD, first-principles guide.
- `docs/20-architecture/` - system design and technical architecture.
- `docs/30-data-and-schema/` - schema, data model, and migration/change specs.
- `docs/40-ai-quality/` - prompts, evaluator behavior, rubrics, fixtures.
- `docs/50-operations/` - SOPs, repo setup, publishing, audits, runbooks.
- `docs/60-decisions/` - ADRs and durable decision history.
- `docs/90-archive/` - raw source inputs preserved for provenance.

## Repository split

- Documentation/resources repo: `exponential-jyotish-companion-docs`.
- Main platform repo: `exponential-jyotish-companion-platform`.

Both repositories use `main` as the stable branch and `dev` as the working branch.

## Docs site

This repo is MkDocs-ready. Add Markdown files under the right `docs/` shelf, link durable entry points from `docs/index.md` or the relevant section index, and merge to `main` to publish the hosted docs site.

## Current baseline

- Memory default: `manual`.
- Model strategy: route all model calls through a model router; validate open-source/open-weight Chinese models as the first candidate path.
- LLM and embedding provider: independently configurable by route; no single hard-commit yet.
- Embedding storage: provider-neutral; no hard-coded `vector(1536)` in domain tables.
- Future features: modeled as versioned `analysis_runs`, not one-off tables for each idea.
- Persona regeneration: allowed on model/persona upgrades through versioned profiles.
- Costing: business-owned, but every model call still records provider/model/tokens/cache/cost so finance has the truth.
- Prediction UX: negative/cautionary readings are allowed when grounded and responsibly delivered; unsafe doom, medical/legal/financial overreach, and fear-selling are not.

## Key files

- [Knowledge map](docs/00-start-here/knowledge-map.md)
- [Version manifest](docs/00-start-here/version-manifest.md)
- [Docs site guide](docs/00-start-here/docs-site-guide.md)
- [Way forward](docs/10-product/way-forward.md)
- [PRD v0.2](docs/10-product/prd-v0.2.md)
- [PM first-principles guide](docs/10-product/pm-first-principles-guide.md)
- [System Design v0.2](docs/20-architecture/system-design-v0.2.md)
- [Schema v0.2 base](docs/30-data-and-schema/schema-v0.2-base.sql)
- [Schema v0.3 change spec](docs/30-data-and-schema/schema-v0.3-change-spec.md)
- [Schema v0.3 discovery and plan](docs/30-data-and-schema/schema-v0.3-discovery-and-plan.md)
- [Prompt artifacts](docs/40-ai-quality/prompts/index.md)
- [Evaluation artifacts](docs/40-ai-quality/evals/index.md)
- [Context/versioning SOP](docs/50-operations/context-versioning-sop.md)
- [Completion audit](docs/50-operations/completion-audit.md)
- [External publish runbook](docs/50-operations/external-publish-runbook.md)
- [ADR index](docs/60-decisions/adr/index.md)
- [Source materials archive](docs/90-archive/source-materials/index.md)
- [Google Drive export package](exports/google-drive/README.md)

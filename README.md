# Exponential Jyotish Companion

Version-controlled product, architecture, SOP, and schema base for the Exponential Jyotish Companion project.

## Source of truth

This repository is the canonical documentation home from day 1. Google Drive, PDFs, slides, and HTML exports may exist for sharing, but they are derived copies. Product decisions, schema changes, prompts, SOPs, and architecture notes should land here first so they can be reviewed, versioned, and indexed through MCP.

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

- [Way forward](docs/01-way-forward.md)
- [PRD v0.2](docs/prd_jyotish_companion_v0_2.md)
- [PM first-principles guide](docs/pm_first_principles_guide.html)
- [Completion audit](docs/completion-audit.md)
- [External publish runbook](docs/external-publish-runbook.md)
- [Google Drive export package](exports/google-drive/README.md)
- [Context/versioning SOP](docs/sop/context-versioning-sop.md)
- [Schema v0.2 base](db/schema_v0_2_base.sql)
- [ADR 0001: Provider-neutral embeddings](docs/adr/0001-provider-neutral-embeddings.md)
- [ADR 0002: Safe Jyotish knowledge retrieval](docs/adr/0002-safe-knowledge-rag.md)
- [ADR 0003: Extension-ready analysis model](docs/adr/0003-extension-ready-analysis-model.md)
- [ADR 0004: Model router and open-model strategy](docs/adr/0004-model-router-and-open-model-strategy.md)
- [ADR 0005: Responsible prediction UX](docs/adr/0005-responsible-prediction-ux.md)
- [ADR 0006: End-of-chat memory review](docs/adr/0006-end-of-chat-memory-review.md)

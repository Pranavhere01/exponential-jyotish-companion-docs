# Exponential Jyotish Companion

This is the internal documentation and resource hub for Jyotish Companion.

Git is the source of truth. Google Drive, exported HTML, and hosted pages are reading layers that derive from this repository.

## Start Here

- [Way Forward](01-way-forward.md)
- [PRD v0.2](prd_jyotish_companion_v0_2.md)
- [System Design v0.2](system_design_jyotish_companion_v0_2.md)
- [Schema v0.2 Base](https://github.com/Pranavhere01/exponential-jyotish-companion-docs/blob/main/db/schema_v0_2_base.sql)
- [Schema v0.3 Change Spec](schema-v0.3-change-spec.md)
- [Schema v0.3 Discovery and Plan](schema-v0.3-discovery-and-plan.md)
- [Context and Version Control SOP](sop/context-versioning-sop.md)
- [How To Add Docs](docs-site-guide.md)
- [Repository Split Execution Plan](repo-split-execution-plan.md)

## Durable Decisions

- [ADR 0001: Provider-neutral embeddings](adr/0001-provider-neutral-embeddings.md)
- [ADR 0002: Reviewed Jyotish knowledge retrieval](adr/0002-safe-knowledge-rag.md)
- [ADR 0003: Extension-ready analysis model](adr/0003-extension-ready-analysis-model.md)
- [ADR 0004: Model router and open-model validation](adr/0004-model-router-and-open-model-strategy.md)
- [ADR 0005: Responsible prediction delivery](adr/0005-responsible-prediction-ux.md)
- [ADR 0006: End-of-chat Manual memory review](adr/0006-end-of-chat-memory-review.md)

## Repository Split

- Documentation and resources repo: `exponential-jyotish-companion-docs`
- Main platform repo: `exponential-jyotish-companion-platform`

The platform repo should link back here for product, architecture, schema, prompt, and eval context.

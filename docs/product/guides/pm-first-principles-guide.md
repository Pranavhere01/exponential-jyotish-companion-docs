# PM First-Principles Guide

Status: HTML artifact v0.2  
Date: 2026-06-29  
Audience: PM / non-technical

The PM-facing first-principles guide is preserved as an HTML artifact at:

- [`pm-first-principles-guide.html`](pm-first-principles-guide.html)

It explains the major technical decisions in non-engineering language:

- why embeddings have dimensions and why the database must not silently assume one provider;
- why Manual memory is the real default and should happen at end-of-chat review;
- why the model router exists;
- why reviewed Jyotish RAG can include difficult material without becoming fatalistic;
- how costing should be owned by the business while engineering tracks usage;
- why marriage matching is an example of a broader future analysis layer;
- why GitHub is the source of truth while Drive/HTML/PDF are exports.

The Markdown source-of-truth companions are:

- [Way Forward](../strategy/way-forward.md)
- [PRD v0.2](../requirements/prd-v0.2.md)
- [System Design v0.2](../../architecture/system/system-design-v0.2.md)
- [Context and Version Control SOP](../../governance/standards/context-versioning-sop.md)
- [Schema v0.2 Base](../../engineering/data-model/schema-v0.2-base.sql)

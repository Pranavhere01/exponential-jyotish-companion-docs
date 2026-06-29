# Knowledge Map

Status: Draft v0.1  
Date: 2026-06-29  
Audience: PM, engineering, AI quality, operations

This map explains where knowledge belongs so the documentation stays useful as the project grows.

## First read path

If you are new to the project, read in this order:

1. [Way Forward](../10-product/way-forward.md) - plain-English decisions and why they matter.
2. [PRD v0.2](../10-product/prd-v0.2.md) - product scope, requirements, and open decisions.
3. [System Design v0.2](../20-architecture/system-design-v0.2.md) - how the product should work technically.
4. [Version Manifest](version-manifest.md) - current canonical artifacts and their versions.
5. [ADR Index](../60-decisions/adr/index.md) - durable decisions and rationale.

## Where to put a new document

| If the doc is about... | Put it in... | Examples |
| --- | --- | --- |
| Product scope, user flows, PM decisions | `docs/10-product/` | PRD, roadmap notes, PM guides |
| System design, services, runtime flow | `docs/20-architecture/` | architecture plan, folder structure plan |
| Database, schema, migrations, data model | `docs/30-data-and-schema/` | schema SQL, migration specs |
| Prompts, models, evals, AI behavior | `docs/40-ai-quality/` | prompt versions, rubrics, fixtures |
| SOPs, repo setup, publishing, audits | `docs/50-operations/` | runbooks, GitHub setup, completion audits |
| A durable product/architecture decision | `docs/60-decisions/adr/` | ADRs |
| Original pasted text, HTML exports, raw inputs | `docs/90-archive/` | source materials and provenance |

## Canonical vs derived

Canonical files live under `docs/`. Derived sharing copies live under `exports/`.

Use derived exports for stakeholder sharing, but update the canonical Markdown, SQL, prompt, or JSONL file first.

## What must never be lost

- Original source inputs stay under [Source Materials](../90-archive/source-materials/index.md).
- Durable artifacts stay listed in [Version Manifest](version-manifest.md).
- Durable decisions become ADRs.
- Generated or stakeholder-friendly exports are copies, not the record of truth.

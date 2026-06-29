# Metadata Standard

Status: Draft v0.1
Date: 2026-06-30
Owner: Product + Engineering

This standard makes the documentation repository graph-friendly without changing the human-facing folder structure.

## Rule

Durable documentation artifacts should have a stable ID, a clear type, a scope, a lifecycle status, an owner, and explicit relationships.

The metadata may live in two places:

- the artifact itself, when the file format supports readable frontmatter;
- [Artifact Registry](artifact-registry.md), which is the canonical machine-readable index.

## Required Fields

| Field | Meaning |
| --- | --- |
| `id` | Stable graph ID, such as `prd:v0.2` or `adr:0007` |
| `type` | Artifact type, such as `prd`, `adr`, `schema`, `prompt`, `eval`, `pattern`, `standard`, `runbook`, or `domain_knowledge` |
| `scope` | Graph scope: `project_knowledge`, `domain_knowledge`, or `runtime_user_context` |
| `status` | Draft, proposed, accepted, superseded, archived |
| `owner` | Accountable domain or role |
| `version` | Artifact version when applicable |
| `path` | Canonical repository path |
| `relations` | Typed links to other artifacts |

## Example

```yaml
id: prd:v0.2
type: prd
scope: project_knowledge
status: draft
owner: product
version: v0.2
path: docs/product/requirements/prd-v0.2.md
relations:
  constrained_by:
    - adr:0007
  implemented_by:
    - schema:v0.2-base
  tested_by:
    - eval:model-router-validation:v0.1
```

## Relationship Rules

Use only relation names defined in [Relation Types](relation-types.md).

Do not invent new relation names casually. If a new relation is needed, add it to the relation taxonomy first.

## Scope Rules

- `project_knowledge`: product, architecture, engineering, AI, governance, and operations docs.
- `domain_knowledge`: reviewed Jyotish doctrine and source maps.
- `runtime_user_context`: user-specific memories, chart facts, analysis outputs, and traces. This scope belongs in the platform database, not this docs repository.

## Review Checklist

Before merging a durable doc change, confirm:

- The artifact has a stable ID.
- The artifact appears in `artifact-registry.yaml` if it should be graph-ingested.
- Its relations use approved relation types.
- The version manifest is updated if the artifact is a source of truth.
- MkDocs navigation is updated if humans need to browse it.

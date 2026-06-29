# Relation Types

Status: Draft v0.1
Date: 2026-06-30
Owner: Product + Engineering

Use these relation names in [Artifact Registry](artifact-registry.md) and future context graph ingestion.

## Core Relations

| Relation | Meaning |
| --- | --- |
| `defines` | Artifact defines a standard, type, policy, or structure |
| `governs` | Artifact sets rules for another artifact or workflow |
| `constrained_by` | Artifact must obey another decision, policy, or pattern |
| `implemented_by` | Product or architecture intent is implemented by a schema, prompt, workflow, or code artifact |
| `implements` | Artifact implements a requirement, standard, or decision |
| `implements_policy` | Prompt or workflow operationalizes a policy/ADR |
| `supports` | Artifact provides support for a requirement or decision |
| `extends` | Artifact adds to an earlier artifact without replacing it |
| `supersedes` | Artifact replaces an older artifact while preserving history |
| `decided_by` | Artifact exists because of a durable ADR |
| `tested_by` | Artifact has validation coverage from an eval or test |
| `tests` | Eval or test validates another artifact |
| `informs` | Artifact provides reference guidance, but does not mandate behavior |
| `constrains_future` | Artifact should shape a future implementation |
| `governed_by` | Domain material follows a policy or ADR |

## Naming Rules

- Use lowercase snake_case in YAML.
- Use uppercase snake case only when documenting future runtime graph edge labels.
- Do not create synonyms such as `validates` and `tests`; pick one relation and reuse it.
- Add a relation here before using it in `artifact-registry.yaml`.

## Runtime Edge Label Examples

Future platform graph edges may use uppercase labels such as:

- `SUPPORTS`
- `CONSTRAINED_BY`
- `DERIVED_FROM`
- `SUPERSEDES`
- `MENTIONS`
- `USES_MODEL`
- `HAS_SUBJECT`
- `HAS_EVIDENCE`

These labels should map back to the relation taxonomy when possible.

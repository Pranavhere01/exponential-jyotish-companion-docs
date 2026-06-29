# Knowledge Architecture

Status: Accepted v0.1  
Date: 2026-06-29  
Owner: Product + Engineering

This repository is organized as an enterprise documentation system, not a loose folder dump.

## Information Architecture

| Domain | Owns | Does not own |
| --- | --- | --- |
| `handbook/` | How this docs system works | Product requirements or architecture decisions |
| `product/` | Strategy, PRDs, roadmap direction, PM guides | Low-level implementation detail |
| `architecture/` | System design, boundaries, diagrams, platform direction | Raw migrations or prompt text |
| `engineering/` | Data model, schema, implementation specs, migration plans | Business rationale unless needed for context |
| `ai/` | Prompts, evals, model behavior, AI quality gates | General product requirements |
| `governance/` | ADRs, standards, decision policy, source-of-truth rules | Day-to-day runbooks |
| `operations/` | Publishing, GitHub, audits, repo workflow, runbooks | Durable architecture rationale |
| `domain-knowledge/` | Reviewed subject-matter doctrine and retrieval taxonomy | Product requirements, prompts, or user-specific runtime data |
| `archive/` | Immutable source material and provenance | Current canonical docs |

## Enterprise Rules

1. One canonical owner per artifact.
2. One canonical path per artifact.
3. Durable decisions require ADRs.
4. Source inputs are preserved but not edited.
5. Exports are reproducible copies.
6. Navigation reflects audience and lifecycle, not creation order.
7. Schema, prompts, evals, and PRDs are versioned product artifacts.
8. Durable artifacts should be graph-ingestable through stable IDs, approved relation types, and the artifact registry.

## Naming Standard

- Use lowercase kebab-case filenames: `system-design-v0.2.md`.
- Put version in the filename for durable artifacts: `prd-v0.2.md`.
- Use `index.md` for section landing pages.
- Avoid date-based folders unless the artifact is a log or audit.
- Use stable graph IDs in `docs/handbook/artifact-registry.yaml` for durable artifacts.

## Review Standard

Every meaningful change should answer:

- What canonical artifact changed?
- Is this draft, proposed, accepted, superseded, or archived?
- Does the version manifest need an update?
- Does the artifact registry need an update?
- Does an export copy need to be refreshed?
- Does this create or change a durable decision that needs an ADR?

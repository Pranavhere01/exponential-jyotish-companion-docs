# Documentation Handbook

The handbook explains how to navigate, maintain, and govern the documentation system.

## Start Here

- [Knowledge Architecture](knowledge-architecture.md)
- [Knowledge Map](knowledge-map.md)
- [Metadata Standard](metadata-standard.md)
- [Artifact Registry](artifact-registry.md)
- [Relation Types](relation-types.md)
- [Contribution Guide](contribution-guide.md)
- [Version Manifest](version-manifest.md)

## Operating Principles

- Git is the source of truth.
- Canonical artifacts live under `docs/`.
- Export folders are generated copies for sharing, not decision records.
- Raw historical inputs live under `docs/archive/` and are not edited in place.
- Durable decisions are recorded as ADRs under `docs/governance/decisions/adr/`.
- Durable artifacts are indexed in `docs/handbook/artifact-registry.yaml` for context graph ingestion.

## Document Lifecycle

| State | Meaning |
| --- | --- |
| Draft | Useful, but still changing. |
| Proposed | Ready for review; not yet accepted. |
| Accepted | Current source of truth for a decision or artifact. |
| Superseded | Retained for history; a newer artifact replaces it. |
| Archived | Historical input or completed operational record. |

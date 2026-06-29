# Data Model And Schema

This area owns durable storage design: schema SQL, migration specs, and database-facing implementation notes.

## Canonical Artifacts

- [Schema v0.2 Base](schema-v0.2-base.md)
- [Schema v0.3 Change Spec](schema-v0.3-change-spec.md)
- [Schema v0.3 Discovery and Plan](schema-v0.3-discovery-and-plan.md)

## Rules

- Schema changes must preserve product invariants from the PRD.
- Provider decisions must not be silently hard-coded into domain tables.
- Migration specs must identify decision gates and downstream code surfaces.
- Raw SQL and implementation notes stay together here so engineers do not hunt across folders.

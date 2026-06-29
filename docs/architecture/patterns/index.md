# Architecture Patterns

Architecture patterns are reusable technical blueprints that can be applied across product features or future repos.

They are not full product requirements and they are not implementation migrations. A pattern belongs here when it explains the reusable shape of a system: request flow, orchestration, component boundaries, workers, infrastructure, and production graduation path.

## Patterns

- [Multi-Turn Chat Harness v0](chat-harness/README.md)

## Ownership

Primary owner: Engineering
Required reviewers when changed: Product for product fit, AI Quality for model behavior, Governance for durable decisions.

## Review Standard

Each pattern should make clear:

- What problem it solves.
- Which parts are reusable as-is.
- Which parts are example-only or inherited from another system.
- How it maps to Jyotish Companion.
- What needs to change before production implementation.

# Knowledge Map

Status: Accepted v0.1  
Date: 2026-06-29  
Audience: PM, engineering, AI quality, operations

This map explains where to read first and where new knowledge belongs.

## First Read Path

1. [Product Way Forward](../product/strategy/way-forward.md)
2. [PRD v0.2](../product/requirements/prd-v0.2.md)
3. [System Design v0.2](../architecture/system/system-design-v0.2.md)
4. [Knowledge Architecture](knowledge-architecture.md)
5. [Artifact Registry](artifact-registry.md)
6. [Version Manifest](version-manifest.md)
7. [ADR Index](../governance/decisions/adr/index.md)

## Placement Guide

| If the doc is about... | Put it in... |
| --- | --- |
| Product scope, PM decisions, user flows | `docs/product/` |
| System boundaries, services, runtime flows | `docs/architecture/` |
| Reusable platform patterns or reference architectures | `docs/architecture/patterns/` |
| Governed context, graph memory, and evidence packet design | `docs/architecture/patterns/` plus `docs/governance/decisions/adr/` |
| Schema, tables, migrations, data contracts | `docs/engineering/data-model/` |
| Prompts, model behavior, evaluation, safety rubrics | `docs/ai/` |
| Durable decisions or standards | `docs/governance/` |
| Reviewed Jyotish doctrine, source maps, and retrieval taxonomy | `docs/domain-knowledge/` |
| Publishing, repo setup, audits, runbooks | `docs/operations/` |
| Raw originals, pasted source text, historical inputs | `docs/archive/` |

## Current Source Of Truth

- Product: [PRD v0.2](../product/requirements/prd-v0.2.md)
- Architecture: [System Design v0.2](../architecture/system/system-design-v0.2.md)
- Context graph: [Context Graph And Knowledge System](../architecture/patterns/context-graph-knowledge-system/README.md)
- Architecture patterns: [Multi-Turn Chat Harness v0](../architecture/patterns/chat-harness/README.md)
- Schema: [Schema v0.2 Base](../engineering/data-model/schema-v0.2-base.md)
- AI behavior: [AI Quality](../ai/index.md)
- Domain knowledge: [Jyotish Domain Knowledge](../domain-knowledge/jyotish/index.md)
- Decisions: [ADR Index](../governance/decisions/adr/index.md)
- Operations: [Operations](../operations/index.md)

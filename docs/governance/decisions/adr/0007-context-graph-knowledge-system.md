# ADR 0007: Context Graph And Knowledge System

Status: Accepted for day-one architecture
Date: 2026-06-30

## Context

Jyotish Companion already has several durable context decisions:

- deterministic chart computation is the source of chart truth;
- model calls route through `model_routes`;
- embeddings are provider-neutral and stored in `text_embeddings`;
- user memory defaults to Manual and saves only after review;
- Jyotish knowledge retrieval is reviewed and labeled, but not positive-only;
- future features use generic `analysis_runs`;
- traceability and evals are required for quality and safety.

Vector retrieval and raw transcript recall are useful, but they do not naturally represent typed relationships, provenance, policy constraints, or fact supersession. The product needs answers that can explain not just "what context was retrieved" but "why this context was allowed, how it relates to the user's question, and which evidence path supports it."

## Decision

Adopt a governed context graph as a day-one architecture pattern.

The graph is Postgres-first. It is implemented as adjacency tables in the future platform repo, not as Neo4j on day one.

The graph has three scopes:

- `project_knowledge`: PRDs, ADRs, schema specs, prompts, evals, and repo decisions.
- `domain_knowledge`: reviewed Jyotish sources, chunks, doctrine, safety labels, and delivery policy.
- `runtime_user_context`: user-approved memories, deterministic chart references, analysis-run context, and trace evidence.

The graph complements lexical and vector retrieval. It does not replace `text_embeddings`, hybrid search, deterministic tools, or the model router.

The platform implementation should add:

- `context_graph_nodes`
- `context_graph_edges`
- `context_graph_aliases`
- `context_graph_evidence`
- `context_assembly_runs`
- `context_packet_items`

Every user-facing graph retrieval must pass policy filtering and produce a context packet with evidence, provenance, policy constraints, freshness, and supersession notes.

## Guardrails

- User runtime context must be user-scoped and protected by RLS.
- Public/project docs and user PII must not share a retrieval namespace.
- Sensitive user memory must not receive plaintext lexical/vector indexes until encryption-versus-searchability is explicitly accepted.
- Chart facts may enter the graph only from deterministic chart output, never from LLM generation.
- Only saved or edited Manual memory candidates become graph facts.
- Reviewed negative Jyotish doctrine may be retrieved when relevant; the graph must not become a positivity filter.
- Single-valued predicates must supersede old active edges instead of leaving stale facts active.
- Neo4j or another graph database requires a future ADR with measured need.

## Consequences

The architecture gets more explicit and auditable. Future model calls can receive bounded explanation packets rather than unstructured transcript dumps.

The platform has extra work: entity resolution, graph ingestion, stale-fact handling, policy filtering, and retrieval evals.

The first implementation remains conservative. Postgres handles the graph until usage proves the need for a dedicated graph database.

The design fits current product decisions: Manual memory, provider-neutral embeddings, reviewed Jyotish knowledge, generic analysis runs, and responsible prediction evaluation all remain intact.

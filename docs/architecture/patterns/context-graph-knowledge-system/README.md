# Context Graph And Knowledge System

Status: Draft pattern v0.1
Date: 2026-06-30
Owner: Engineering + AI Quality
Related decision: [ADR 0007](../../../governance/decisions/adr/0007-context-graph-knowledge-system.md)

## Where This Sits

This belongs in `docs/architecture/patterns/context-graph-knowledge-system/` because it is a reusable architecture pattern for governed context, memory, evidence, and retrieval.

It is not a database migration yet. It is the day-one design contract for how the future platform repo should represent context so that LLM calls can be grounded, auditable, policy-aware, and expandable.

## Source Anchors

- [Context Graphs: A Practical Guide to Governed Context for LLMs, Agents, and Knowledge Systems](https://medium.com/@adnanmasood/context-graphs-a-practical-guide-to-governed-context-for-llms-agents-and-knowledge-systems-c49610c8ff27) frames context graphs as governed memory connecting entities, events, decisions, policies, and evidence.
- [Vector RAG Isn't Enough - I Built a Context Graph Layer for Multi-Agent Memory](https://towardsdatascience.com/vector-rag-isnt-enough-i-built-a-context-graph-layer-for-multi-agent-memory/) shows why vector retrieval alone can miss relationship and join questions, and highlights production risks such as entity matching, stale facts, extraction, pruning, and persistence.

The Medium article is member-only in the accessible environment, so this plan relies on its public summary plus the fully accessible Towards Data Science article and the existing Jyotish Companion docs.

## First-Principles Explanation

Vector search finds text that looks similar to the user's question. That is useful, but it does not naturally understand relationships.

A context graph stores facts as entities and typed relationships:

```text
memory_fact:job_switch_goal
  RELATED_TO -> chart_factor:saturn_mercury_period
  SOURCE_OF  -> conversation:session_123
  CONSTRAINED_BY -> policy:responsible_prediction
```

This matters when an answer requires combining facts. For example, "Which saved concern relates to the timing period we discussed?" is not just a text lookup. It is a path through memory, chart timing, and evidence.

The product should therefore use:

- deterministic tools for chart truth;
- reviewed Jyotish knowledge for doctrine;
- vector and lexical retrieval for recall;
- a context graph for relationships, evidence paths, policy constraints, and supersession;
- evaluator checks before user delivery.

The graph complements RAG. It does not replace embeddings, lexical search, deterministic tools, or the model router.

## Day-One Decision

Use a Postgres-first context graph, not Neo4j on day one.

Reason:

- The current architecture already centers on Postgres, pgvector, model routes, provider-neutral embeddings, reviewed knowledge chunks, analysis runs, and manual memory.
- Most V1 graph needs are shallow relationship traversals and evidence packet assembly, not deep graph analytics.
- A dedicated graph database can be added later through a new ADR if Postgres becomes a measured bottleneck.

## Graph Scopes

The graph has three separate scopes. These must not be mixed casually.

| Scope | Purpose | Contains | Privacy rule |
| --- | --- | --- | --- |
| `project_knowledge` | Internal project context | PRDs, ADRs, schema specs, prompts, evals, repo decisions | Searchable by project contributors |
| `domain_knowledge` | Reviewed Jyotish doctrine | Sources, reviewed chunks, safety labels, delivery policy | Searchable only after review gates |
| `runtime_user_context` | User-specific runtime context | Approved memories, chart references, analysis context, trace evidence | Strictly user-scoped with RLS |

Public/project documents and user PII must not share the same retrieval namespace.

## Platform Data Model Contract

When the future platform repo implements this, add the graph tables additively.

| Table | Purpose |
| --- | --- |
| `context_graph_nodes` | Canonical entities: requirement, ADR, policy, prompt, model, chart, chart factor, memory fact, knowledge chunk, analysis run |
| `context_graph_edges` | Typed relationships: `SUPPORTS`, `CONSTRAINED_BY`, `DERIVED_FROM`, `SUPERSEDES`, `MENTIONS`, `USES_MODEL`, `HAS_SUBJECT`, `HAS_EVIDENCE` |
| `context_graph_aliases` | Entity names, synonyms, normalized labels, and resolution hints |
| `context_graph_evidence` | Provenance pointers to docs, messages, chart facts, knowledge chunks, model invocations, and analysis runs |
| `context_assembly_runs` | One log record per model context assembly |
| `context_packet_items` | The exact evidence items handed to the model |

Required fields on graph nodes and edges:

| Field | Purpose |
| --- | --- |
| `scope` | Separates project, domain, and user context |
| `owner_user_id` | Nullable for project/domain, required for user runtime context |
| `entity_type` | Type of entity or linked source |
| `entity_id` | ID of the source entity when one exists |
| `status` | Active, superseded, archived, deleted, blocked, or similar lifecycle |
| `confidence` | Confidence in extraction or relationship |
| `source_ref` | Human-readable provenance pointer |
| `valid_from` / `valid_to` | Time model for current vs stale facts |
| `supersedes_id` | Explicit supersession chain |
| `policy_labels` | Safety, privacy, delivery, and retention labels |

Indexes should cover `scope`, `owner_user_id`, `entity_type`, `entity_id`, `predicate`, and `status`.

## Privacy And Searchability Rules

Project and reviewed domain knowledge may be searchable.

User context graph data must be protected by row-level security and must never be exposed across users.

Do not add plaintext lexical or vector indexes over sensitive user memories until the encryption-versus-searchability decision is explicitly accepted. This preserves the v0.3 gate that searchability and envelope encryption cannot be silently assumed together.

## Ingestion Flow

### Project Knowledge

Parse Markdown, SQL, JSONL, and configuration files into graph nodes for:

- PRD requirements;
- ADR decisions;
- schema tables and fields;
- prompt artifacts;
- eval cases;
- operational policies.

Create edges such as:

- `REQUIREMENT_CONSTRAINS_SCHEMA`
- `ADR_DECIDES`
- `PROMPT_IMPLEMENTS_POLICY`
- `EVAL_TESTS_REQUIREMENT`
- `SCHEMA_SUPPORTS_REQUIREMENT`

This should make the docs repo more MCP-friendly over time. Adding a new `.md` file should not require manual graph surgery; ingestion should be repeatable.

### Domain Knowledge

Raw Jyotish sources go to `knowledge_sources`.

Reviewed chunks go to `knowledge_chunks`.

Only reviewed chunks create user-facing graph nodes. The delivery policy remains mandatory:

- `allow_normal`
- `allow_caution`
- `transform_required`
- `internal_only`
- `blocked`

Reviewed negative or cautionary material may be retrieved when relevant. The graph must not become a positivity filter.

### Runtime User Context

Manual memory remains the default.

The flow is:

1. Memory extractor creates `memory_candidates`.
2. User reviews candidates at end-of-chat or CSAT.
3. Only saved or edited memories become `memory_facts`.
4. Saved facts create user-scoped graph nodes and edges.
5. Chart facts create graph nodes only from deterministic `charts` output.
6. Analysis runs create graph nodes from versioned deterministic results and narratives.

The LLM can explain and synthesize. It must not create chart facts.

## Stale Fact Rule

For single-valued predicates, only one active edge may exist per:

```text
(scope, owner_user_id, subject_node_id, predicate)
```

When a new accepted fact restates the same predicate, the old edge must be superseded, not left active.

This prevents the graph from returning stale facts with false confidence.

## Retrieval Flow

For each chat turn:

1. The orchestrator classifies the request as chart, memory, Jyotish doctrine, product/docs, or mixed.
2. The entity resolver maps query terms to graph nodes using aliases and optional model-assisted linking.
3. The retriever combines graph traversal, lexical search, vector search through `text_embeddings`, and recency/status filtering.
4. The policy filter removes blocked/internal-only material and unauthorized user data.
5. The context assembler emits an explanation packet.
6. The model router calls the selected model.
7. The prediction evaluator checks grounding, safety, and delivery.
8. The trace logs the packet, model invocation, retrieved evidence, and evaluator result.

## Explanation Packet

An explanation packet is the bounded context object handed to the model.

It should contain:

- answer context;
- evidence paths;
- provenance;
- policy constraints;
- freshness and supersession notes;
- token budget metadata;
- retrieved item IDs.

The packet should be logged through `context_assembly_runs` and `context_packet_items` so future reviewers can answer: "Why did the model say this?"

## PM Glossary

| Term | Plain-English meaning |
| --- | --- |
| Node | A thing the system knows about, such as a requirement, chart factor, memory, source chunk, model, or analysis |
| Edge | A relationship between two things, such as "this prompt implements this policy" |
| Evidence path | The chain of nodes and edges that explains why a piece of context was selected |
| Context packet | The curated package of facts, evidence, policies, and constraints given to the model |
| Supersession | Marking an older fact as replaced instead of deleting history silently |
| Entity resolution | Matching user language like "my job change concern" to the correct stored entity |
| Scope | A boundary that separates project docs, domain knowledge, and one user's private context |

## Phased Execution

### Phase 0: Docs And Decision Record

- Add this architecture pattern.
- Add ADR 0007.
- Add glossary terms for non-technical readers.
- Update the version manifest and docs navigation.

### Phase 1: Platform Base Schema

- Add Postgres graph tables and context packet logs.
- Keep embeddings in `text_embeddings`.
- Add indexes on graph lookup fields.
- Do not add Neo4j yet.

### Phase 2: Project Knowledge Graph

- Ingest PRD, ADRs, schema, prompts, evals, and docs metadata.
- Use the graph for internal MCP/search context first.
- Validate that adding `.md` files can update graph context through repeatable ingestion.

### Phase 3: Product Runtime Graph

- Wire saved manual memories, chart facts, analysis runs, and reviewed knowledge chunks into the graph.
- Add context packet assembly to the chat orchestrator.
- Keep raw transcript retrieval separate from graph memory unless message-level indexing is explicitly approved.

### Phase 4: Evaluation And Governance

- Add eval fixtures for direct, distant, and join queries.
- Compare raw history, vector/hybrid retrieval, and context graph retrieval.
- Track accuracy, token count, stale-fact failure rate, unauthorized retrieval attempts, and evidence coverage.

### Phase 5: Scale Decision

- Stay on Postgres unless measurable need appears.
- Open a new ADR for Neo4j only if Postgres graph traversal becomes a real bottleneck or if the product needs variable-depth graph analytics beyond 1-2 hop context packets.

## Test Plan

Core tests:

- A saved memory creates a graph node and edge.
- A discarded memory candidate creates no graph node.
- A superseding memory hides the old edge from current retrieval.
- A reviewed Jyotish chunk is retrievable.
- Raw, rejected, blocked, and internal-only chunks are not user-retrievable.
- A chart fact edge is derived only from deterministic chart output.
- A join query retrieves an evidence path, not just a similar text chunk.
- A user cannot retrieve another user's graph nodes or edges.
- A context packet logs every evidence item used by the model.

Eval scenarios:

- Direct lookup: "What role did I say I have?"
- Distant lookup: same fact after many unrelated turns.
- Join lookup: "Which concern relates to the career period we discussed?"
- Stale fact: old location, job, or relationship status must not win over updated saved memory.
- Safety: difficult Jyotish doctrine can be retrieved only with delivery policy and evaluator checks.

Acceptance criteria:

- Context graph retrieval beats vector-only retrieval on join queries.
- Context packet stays within configured token budget.
- Every user-facing answer using graph context has provenance.
- No blocked/internal-only knowledge reaches runtime astrologer context.
- No cross-user retrieval is possible under tests.

## Non-Goals

- Do not replace deterministic chart computation.
- Do not replace provider-neutral embeddings.
- Do not make Neo4j a day-one dependency.
- Do not auto-save user memories without review while Manual mode is the default.
- Do not use the graph to bypass responsible prediction checks.
- Do not index sensitive plaintext before the encryption-versus-searchability decision is made.

## Open Follow-Ups

- Define the exact graph enum values in the platform schema migration.
- Decide the first ingestion script shape for project docs.
- Add context-graph eval fixtures after the platform repo exists.
- Decide whether Langfuse, OpenTelemetry, or another tracer owns the context packet trace link.

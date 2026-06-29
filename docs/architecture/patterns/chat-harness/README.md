# Multi-Turn Chat Harness v0

Status: Draft reference pattern
Source artifact: [chat-harness-v0.html](chat-harness-v0.html)
Imported from: `/Users/pranavkumar/Downloads/chat_harness.html`
Owner: Engineering

## Where This Sits

This belongs in `docs/architecture/patterns/chat-harness/` because it is a reusable platform architecture pattern for multi-turn AI chat systems.

It is not a PRD, not a database migration, and not a prompt. It describes how a chat product can be structured across API entry points, orchestration, memory, tools, evaluation, workers, providers, and infrastructure.

## What The HTML Document Is

The HTML document is a visual architecture reference for a V0 multi-turn chat harness. It is adapted from AdvisorIntakeBE patterns and should be treated as a reusable blueprint, not as a literal Jyotish Companion implementation spec.

The inherited "board" vocabulary in the evaluation examples comes from the source system. For Jyotish Companion, translate that idea into our domain:

| Source term in HTML | Jyotish Companion equivalent |
| --- | --- |
| Board run | A deterministic product workflow run, such as chart computation, interpretation generation, report generation, memory review, or compatibility analysis |
| Build board | Build the structured output or product artifact |
| Build knowledge | Attach grounded facts, references, chart facts, or explanatory context |
| Trace evaluation | Evaluate whether the workflow stayed grounded, complete, safe, and correct |

## First-Principles Explanation

A multi-turn chat product is not just "send user text to an LLM and return an answer."

At production quality, every chat turn needs a controlled path:

1. Identify the user and session.
2. Save the incoming message.
3. Gather the right context.
4. Decide whether deterministic code can handle the next step.
5. Call the model only when model reasoning is actually needed.
6. Execute tools safely and idempotently.
7. Stream or return the answer.
8. Save the result.
9. Evaluate the run.
10. Improve the system from traces and feedback.

The HTML document lays out that full loop.

## End-To-End Flow

### 1. Client Layer

The client layer is intentionally pluggable. A user may arrive through a web UI, Slack, WhatsApp, an API, a CLI, an MCP client, or a voice assistant.

The key idea is that the backend should not care which client started the conversation. All clients should converge into the same chat API and session model.

### 2. Chat Entry Point

The FastAPI entry point exposes the core chat routes:

| Route | Purpose |
| --- | --- |
| `POST /chat/session` | Create a new chat session |
| `POST /chat/message` | Send a user message |
| `GET /chat/stream/{session_id}` | Stream assistant output |
| `POST /chat/feedback` | Collect user feedback |

Before orchestration starts, the request passes through authentication, rate limiting, and session management.

### 3. Auth Gate

The auth gate checks whether the request is allowed. In the V0 harness this is an API key. In a production version, this could become user auth, organization auth, role-based access, or policy-based access.

For Jyotish Companion, this eventually maps to account identity, user profile ownership, and permissions around sensitive birth data and memories.

### 4. Rate Limit

The rate limiter protects the system from overload, abuse, and runaway cost.

The HTML proposes Redis for fast counters and TTL-based limits. This is especially important for AI products because model calls, embeddings, and PDF/report generation can become expensive.

### 5. Session Management

The session manager owns the lifecycle of a conversation.

It creates sessions, retrieves sessions, appends messages, fetches recent history, and archives expired or completed sessions.

The HTML defines two core objects:

| Object | Role |
| --- | --- |
| `ChatSession` | Conversation container tied to a user |
| `Message` | Append-only message record with role, content, tool calls, tool results, metadata, and timestamp |

For Jyotish Companion, this maps closely to `conversations` and `messages`.

### 6. Orchestration Layer

The orchestration layer is the brain of the backend. It decides what must happen on each turn.

The HTML breaks orchestration into four major pieces:

| Component | Responsibility |
| --- | --- |
| Context Assembler | Builds the model input from user message, memory, recent chat, summaries, RAG, and tool definitions |
| Policy Engine | Uses deterministic rules to choose the next action when the state is clear |
| Memory Layer | Stores and retrieves short-term and long-term context |
| Tool Executor | Calls tools safely, with timeout, cache, and idempotency |

This split is important because it prevents the LLM from being responsible for everything. Deterministic code should handle deterministic state transitions. The LLM should handle language, reasoning, and synthesis.

### 7. Context Assembler Flow

The HTML describes the context assembler as:

1. Write
2. Select
3. Compress
4. Assemble

That means:

| Step | Meaning |
| --- | --- |
| Write | Persist the new user message before doing model work |
| Select | Pull recent messages, long-term memories, and relevant knowledge chunks |
| Compress | Summarize older context if it exceeds the token budget |
| Assemble | Put system prompt, memory, summary, recent turns, RAG context, tool definitions, and user message into a clean model input |

For Jyotish Companion, this is where we would assemble birth profile facts, computed chart facts, approved Jyotish knowledge, user memories, and the current question.

### 8. Policy Engine Flow

The policy engine is a deterministic action router.

Its main job is to answer: "Do we already know the next correct backend action without asking the LLM?"

The HTML example uses this sequence:

1. `gather_requirements`
2. `select_tools`
3. `build_board`
4. `build_knowledge`
5. `complete`

For Jyotish Companion, a comparable sequence could be:

1. Gather missing birth details.
2. Validate birth details.
3. Compute chart deterministically.
4. Retrieve grounded Jyotish knowledge.
5. Generate interpretation.
6. Apply safety and tone checks.
7. Present answer or report.

The principle is the same: clear state transitions should be handled by code, not guessed by the model.

### 9. Memory Layer Flow

The memory layer separates short-term and long-term memory.

| Memory type | Purpose | Example storage |
| --- | --- | --- |
| Short-term memory | Recent turns and active session state | Redis plus Postgres |
| Long-term memory | Durable facts about the user | Postgres plus pgvector |

For Jyotish Companion, this maps to current chat context plus reviewed long-term user memories. It also reinforces the existing decision that memory writes should be controlled and reviewable, not blindly accepted from every model output.

### 10. Evaluation System Flow

The HTML includes a post-run evaluation system. This is one of the most useful parts of the artifact.

It describes two evaluation entry points:

| Entry point | Trigger | Use |
| --- | --- | --- |
| Eval job handler | Async queue after a run completes | Automated evaluation of completed runs |
| Trace evaluation service | API-triggered | On-demand evaluation of a specific trace |

The evaluation system checks:

| Evaluation | What it asks |
| --- | --- |
| Completeness | Did the workflow finish all required steps? |
| Correctness | Are outputs valid, grounded, and aligned with expected results? |
| Goal achievement | Did the run satisfy the user goal? |
| Ground truth match | Does the result match known expected outputs using exact, contains, or regex checks? |
| Trace classification | Is the run good, partially good, or structurally bad? |

For Jyotish Companion, this can become the foundation for evaluating chart interpretation quality, groundedness, responsible prediction language, and whether deterministic chart facts were respected.

### 11. Tool Registry Flow

The tool registry wraps tool execution so tools are not called casually or repeatedly.

The HTML proposes:

1. Look up the tool by name.
2. Check idempotency cache.
3. Execute with timeout.
4. Record failures in a circuit breaker.
5. Cache the result by idempotency key.
6. Return a structured tool result.

For Jyotish Companion, tools could include chart computation, horoscope matching, report rendering, payments, calendar/timezone lookup, and retrieval over approved knowledge.

### 12. Data Model Flow

The HTML proposes five core tables:

| Table | Purpose |
| --- | --- |
| `chat_sessions` | Stores conversation/session metadata |
| `chat_messages` | Stores append-only chat messages |
| `board_run_evaluations` | Stores one evaluation per completed workflow run |
| `evaluation_scores` | Stores individual scores under an evaluation |
| `trace_evaluations` | Stores categorical trace verdicts and feedback |

For Jyotish Companion, this is conceptually aligned with conversations, messages, analysis runs, evaluation results, and trace records. The exact schema should be adapted to the platform repo rather than copied blindly.

### 13. Code Directory Flow

The HTML proposes a backend layout with these modules:

| Directory | Responsibility |
| --- | --- |
| `chat/` | Routes, sessions, messages, context assembly, memory, streaming |
| `policy/` | Deterministic action routing |
| `evaluation/` | Completeness, correctness, trace evaluation, job handler |
| `rl/` | Reward-style trace classification and feedback |
| `providers/` | Swappable model, vector, tool, and cache providers |
| `tools/` | Tool registry and built-in tools |
| `workers/` | Async workers for evals, TTL, and memory compaction |
| `db/` | ORM models and migrations |
| `config/` | Environment-based settings |

This is useful when we design the main platform repo. It suggests clean module boundaries instead of placing all chat logic in a single route handler.

### 14. Worker Flow

The HTML defines three workers:

| Worker | Trigger | Responsibility |
| --- | --- | --- |
| Eval worker | Queue message | Evaluate completed workflow runs and annotate traces |
| Session TTL worker | Cron | Expire stale sessions and evict hot state |
| Memory compaction worker | Cron | Summarize older chat turns and store useful memory |

For Jyotish Companion, these workers map cleanly to async architecture needs already discussed in schema v0.3: task queues, embedding lifecycle, report generation, and memory processing.

### 15. Infrastructure Flow

The HTML proposes a V0 Docker Compose stack:

| Service | Purpose |
| --- | --- |
| API | FastAPI app |
| Postgres with pgvector | Durable data and vector search |
| Redis | Rate limits, session state, cache |
| Langfuse | Tracing and score annotation |
| Workers | Async evaluation, TTL, and memory tasks |

For Jyotish Companion, the notable principle is provider neutrality. The HTML contains example defaults such as `MODEL_PROVIDER=openai` and `MODEL_ID=gpt-4o`, but our docs should continue treating provider choice as configurable and unresolved until explicitly decided.

### 16. V0 To V1 Graduation Flow

The HTML includes a graduation table from simple V0 infrastructure to production V1 infrastructure.

The direction is:

| Area | V0 | V1 |
| --- | --- | --- |
| Runtime | Single FastAPI process | Durable workflow engine |
| Streaming | SSE | SSE plus WebSocket control plane |
| Policy | In-process state machine | Workflow engine such as Temporal |
| Vector store | pgvector | Dedicated vector cluster if needed |
| Auth | API key | Full identity and authorization |
| Evaluation | Post-run eval | Continuous eval and A/B testing |
| Monitoring | Logs plus Langfuse | OpenTelemetry, Grafana, Sentry |
| Deployment | Docker Compose | Kubernetes and GitOps |

This is useful as a maturity model. It does not mean V1 must immediately use every enterprise tool.

### 17. Quick-Start Flow

The HTML ends with a local developer quick-start:

1. Start infrastructure with Docker Compose.
2. Run database migrations.
3. Create a chat session.
4. Send a streaming chat message.
5. Evaluate a trace.

This quick-start should be treated as illustrative until the platform repo implements the actual service.

## How We Should Use This

Use this artifact as a reference when designing the main platform repo structure.

The most important reusable ideas are:

- Keep chat entry points thin.
- Put orchestration in its own layer.
- Use deterministic policy routing before asking the LLM.
- Treat context assembly as a first-class component.
- Keep tools behind an idempotent registry.
- Separate short-term and long-term memory.
- Evaluate completed runs from traces.
- Keep model, vector, cache, and tool providers swappable.
- Move slow work into workers.

## What Not To Copy Blindly

Do not copy the board-specific names directly into Jyotish Companion.

Do not treat the OpenAI defaults in the sample environment variables as a provider decision.

Do not treat the V0 schema as the final database schema.

Do not implement RL or complex workflow infrastructure before the product needs it.

## Recommended Jyotish Companion Mapping

| Harness concept | Jyotish implementation direction |
| --- | --- |
| Session manager | `conversations` and `messages` |
| Context assembler | Birth profile, chart facts, memories, Jyotish knowledge, current question |
| Policy engine | Deterministic chart-compute and analysis flow routing |
| Tool registry | Chart engine, timezone lookup, report renderer, compatibility calculator, payment tools |
| Long-term memory | Reviewed user memory facts with embedding lifecycle |
| Evaluation system | Groundedness, safety, deterministic fact consistency, prediction quality |
| Workers | Async tasks for embeddings, reports, evaluation, memory compaction |
| Provider layer | Configured model, embedding, vector, cache, and tracing providers |

## Open Follow-Ups

- Decide which parts of this pattern become mandatory in the initial platform repo.
- Translate board-specific examples into Jyotish-specific workflow names.
- Align the proposed data model with schema v0.3 before implementation.
- Keep provider and embedding choices configurable.
- Decide whether Langfuse or another tracing platform is the first observability default.

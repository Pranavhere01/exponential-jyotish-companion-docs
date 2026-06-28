# Way Forward: Durable Base for Jyotish Companion

Status: Draft v0.2  
Date: 2026-06-28  
Audience: non-technical/product-first

## Plain-English diagnosis

### #2: The embedding dimension problem

An embedding is a numeric fingerprint for a piece of text. The database column size has to match the fingerprint size. If the database says "I only accept 1536-number fingerprints" and the provider sends 1024-number fingerprints, it is like trying to plug the wrong charger into the wrong port.

The current docs point in three directions:

- The PRD keeps the provider open: D5 says LLM providers and data terms are still a decision.
- The schema page says the dimension must match the embedding model, while also showing `vector(1536)`.
- The Learning Resources direction is Claude/Anthropic-oriented, and Anthropic does not provide first-party embeddings in Claude; their docs route embedding use cases to another embedding provider.

So the fix is simple: do not put `vector(1536)` directly on `memories` or `jyotish_knowledge`. Store embeddings in a separate provider-neutral table, record which embedding model created each vector, and add the fast search index only after the model is selected.

Decision: keep D5 open, keep `manual` as the real memory default, and make the schema flexible until the embedding provider is chosen.

### #4: The RAG knowledge-base prediction-delivery problem

RAG means "retrieve useful reference material and hand it to the model." That is useful only if the reference material is safe to retrieve.

The PRD says classical material can contain fatalistic or alarming statements and must not be reproduced as harmful certainty. The system design also suggests a Jyotish knowledge base to ground interpretations. Those can both be true, but only if the knowledge base has a review and delivery pipeline.

The unsafe version is:

1. Put classical text in a vector database.
2. Let the astrologer retrieve it directly.
3. Hope the final guardrail catches anything bad.

The better version is:

1. Store raw sources separately.
2. Break them into reviewable chunks.
3. Label chunks for topic, provenance, confidence, and delivery risk.
4. Allow reviewed challenging/negative chunks to be retrieved when relevant.
5. Use an evaluator agent plus prompt instructions to repair unsafe delivery without erasing legitimate caution.

Decision: the model can cite curated Jyotish knowledge, including difficult material. The product is not gatekeeping negativity; it is gatekeeping ungrounded certainty, doom framing, professional overreach, and fear-selling.

## PM decisions from 2026-06-29

- Build a model router. It should support open-source/open-weight Chinese models, hosted models, embeddings, evaluators, and fallbacks without rewriting product logic.
- Keep Manual memory as the default, but ask memory questions at the end of the chat during CSAT/session review.
- Use both an evaluator agent and prompt instructions for prediction delivery. The evaluator catches bad framing; the prompt sets the astrologer's bedside manner.
- Treat marriage matching as one example of a future multi-subject analysis, not the whole schema center.

## Expandability without overbuilding

Marriage matching should be treated as an example, not the center of the schema. The same base should later support compatibility, family charts, muhurta, relationship guidance, career timing, regional chart formats, or a pivot into another advisory product.

The pattern is:

- `birth_profiles`: people or subjects the user has saved.
- `charts`: immutable computed chart objects.
- `analysis_types`: catalog of possible analyses, such as natal profile, compatibility, muhurta, or future ideas.
- `analysis_runs`: one actual computed analysis with versioned inputs, deterministic result, optional narrative, model/prompt versions, and safety policy version.
- `analysis_run_subjects`: links one analysis to one or more charts/subjects.

That means V1 can stay single-user, while V2 can add multi-person analyses without rewriting the foundation.

## Version-control operating model

Use GitHub or a Git-based repository as the source of truth, not Google Drive. GitHub gives history, diffs, pull requests, branches, code owners, issues, and review comments. Drive can remain useful for stakeholder-friendly exports, but it should not be where primary decisions live.

Suggested structure:

```text
docs/
  01-way-forward.md
  adr/
    0001-provider-neutral-embeddings.md
    0002-safe-knowledge-rag.md
    0003-extension-ready-analysis-model.md
  sop/
    context-versioning-sop.md
db/
  schema_v0_2_base.sql
prompts/
  astrologer_persona/
evals/
  fixtures/
  rubrics/
```

## Immediate next steps

1. Put this repository in the Exponential shared GitHub organization/folder.
2. Treat Markdown, SQL, JSON, prompts, and eval fixtures as source files.
3. Use `docs/prd_jyotish_companion_v0_2.md` as the PRD source for the next revision.
4. Use ADRs for decisions like provider, memory default, responsible prediction UX, RAG policy, and chart engine.
5. Only export to Google Drive/HTML/PDF after a Git version is merged.

## Source notes

Project sources reviewed:

- PRD v0.1: D5 keeps LLM/provider selection open; safety section forbids fatalistic and harmful claims; memory default is manual.
- System Design v0.1: model calls flow through an LLM Gateway; optional Jyotish knowledge RAG is post-MVP; prompts are versioned artifacts in source control.
- Database architecture draft: memory and knowledge retrieval use embeddings; D5 says the current schema uses `vector(1536)` and must change if the embedding model differs.
- PRD v0.2 draft in this repo: model router, end-of-chat memory review, responsible prediction UX, open-model validation, and generic analysis runs.

External sources:

- Anthropic Claude Platform docs: Anthropic says it does not offer its own embedding model and points builders to Voyage AI for embeddings: https://docs.anthropic.com/en/docs/build-with-claude/embeddings
- Voyage AI text embedding docs: current Voyage 4 text models list `1024` as the default embedding dimension, with other supported dimensions for some models: https://docs.voyageai.com/docs/embeddings
- pgvector docs: pgvector allows a generic `vector` column for mixed dimensions, but indexes must be created over rows with the same dimension using expression/partial indexes: https://github.com/pgvector/pgvector
- GitHub docs: a repository stores files plus revision history and supports collaboration through issues and pull requests: https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories
- Qwen model family reference: https://github.com/QwenLM
- DeepSeek model reference: https://github.com/deepseek-ai
- Kimi model reference: https://github.com/MoonshotAI
- GLM model reference: https://github.com/THUDM

# ADR 0001: Provider-Neutral Embeddings

Status: Accepted for schema v0.2 base  
Date: 2026-06-28

## Context

The PRD leaves LLM and embedding provider selection open under D5. The existing schema notes that vector dimension must match the embedding model, but also commits to `vector(1536)` on domain tables. That silently assumes an embedding model with 1536 dimensions before the provider decision is made.

This is risky because the chat LLM provider and embedding provider may differ. For example, Claude can be the chat model while embeddings come from a separate embedding vendor.

## Decision

Do not store embedding vectors directly on domain tables such as `memories` or `jyotish_knowledge`.

Instead:

- Keep domain data in domain tables.
- Store embedding vectors in a separate `text_embeddings` table.
- Store provider/model/dimension metadata in `model_catalog`.
- Store the dimensions beside each vector and enforce `vector_dims(embedding) = dimensions`.
- Add model-specific pgvector indexes only after an embedding model is chosen.

## Consequences

The first implementation is a little more explicit, but provider swaps become safer. If the project starts with OpenAI embeddings and later moves to Voyage, Gemini, Cohere, or another provider, the domain schema does not need to be rewritten. We add a new model row, backfill embeddings, and add the correct index for that model.


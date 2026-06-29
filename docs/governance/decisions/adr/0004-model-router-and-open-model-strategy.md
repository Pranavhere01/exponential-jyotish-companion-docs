# ADR 0004: Model Router and Open-Model Strategy

Status: Accepted for v0.2 draft  
Date: 2026-06-29

## Context

The provider decision is open, and the product owner wants flexibility to plug and play any model. The likely model strategy is to validate open-source/open-weight Chinese models before committing to a hosted frontier provider.

The system already has an LLM Gateway concept. This ADR makes the model router explicit.

## Decision

All model calls go through a model router.

The router supports separate routes for:

- runtime astrologer
- profile synthesizer
- memory extractor
- prediction evaluator
- safety/moderation
- embeddings
- reranking

Open-source/open-weight Chinese models are a first-class candidate pool, not a hard dependency. Candidate families include Qwen, DeepSeek, Kimi, GLM, and successors. Each model must pass evals before production traffic.

## Consequences

The product can start with one hosted model, one self-hosted open model, or a hybrid. The schema and prompts remain stable while route configuration changes. Engineering must build observability for model, route, version, latency, cost, fallback, and quality outcome.

References:

- Qwen: https://github.com/QwenLM
- DeepSeek: https://github.com/deepseek-ai
- Kimi: https://github.com/MoonshotAI
- GLM: https://github.com/THUDM

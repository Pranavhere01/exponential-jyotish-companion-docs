# Version Manifest

Status: Draft v0.1  
Date: 2026-06-29

This file is the human-readable index of the current source-of-truth artifacts.
Update it whenever a durable document, prompt, schema, eval, or export version changes.

## Canonical Artifacts

| Artifact | Current version | Source path | Export path |
| --- | --- | --- | --- |
| PRD | v0.2 | `docs/prd_jyotish_companion_v0_2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md` |
| System Design | v0.2 | `docs/system_design_jyotish_companion_v0_2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/system_design_jyotish_companion_v0_2.md` |
| PM First-Principles Guide | v0.2 | `docs/pm_first_principles_guide.html` | `exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html` |
| Schema Base | v0.2 | `db/schema_v0_2_base.sql` | `exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql` |
| Context SOP | v0.2 | `docs/sop/context-versioning-sop.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/context-versioning-sop.md` |
| Way Forward | v0.2 | `docs/01-way-forward.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/01-way-forward.md` |
| Astrologer Persona Prompt | v0.2 | `prompts/astrologer_persona/v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_astrologer_persona_v0_2.md` |
| Profile Synthesizer Prompt | v0.2 | `prompts/profile_synthesizer/v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_profile_synthesizer_v0_2.md` |
| Memory Extractor Prompt | v0.2 | `prompts/memory_extractor/v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_memory_extractor_v0_2.md` |
| Prediction Evaluator Prompt | v0.2 | `prompts/prediction_evaluator/v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_prediction_evaluator_v0_2.md` |
| Model Router Eval Rubric | v0.1 | `evals/rubrics/model_router_validation_v0.1.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_validation_v0_1.md` |
| Responsible Prediction Eval Rubric | v0.1 | `evals/rubrics/responsible_prediction_v0.1.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/evals_responsible_prediction_v0_1.md` |
| Model Router Eval Fixtures | v0.1 | `evals/fixtures/model_router_cases_v0.1.jsonl` | `exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_cases_v0_1.jsonl` |

## ADR Index

| ADR | Status | Topic |
| --- | --- | --- |
| `docs/adr/0001-provider-neutral-embeddings.md` | accepted | Provider-neutral embeddings |
| `docs/adr/0002-safe-knowledge-rag.md` | accepted | Reviewed Jyotish knowledge retrieval |
| `docs/adr/0003-extension-ready-analysis-model.md` | accepted | Generic analysis runs |
| `docs/adr/0004-model-router-and-open-model-strategy.md` | accepted | Model router and open-model validation |
| `docs/adr/0005-responsible-prediction-ux.md` | accepted | Responsible prediction delivery |
| `docs/adr/0006-end-of-chat-memory-review.md` | accepted | End-of-chat Manual memory review |

## Versioning Rules

- Update this manifest in the same PR as any artifact version change.
- Keep exports derived from canonical source paths.
- Use ADRs for durable decisions that change architecture, schema, safety, provider strategy, or model behavior.
- Do not overwrite generated outputs in place. Supersede older outputs through explicit version fields and links.
- Run `scripts/verify_artifacts.sh` before merging.

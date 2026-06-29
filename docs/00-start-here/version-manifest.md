# Version Manifest

Status: Draft v0.1  
Date: 2026-06-29

This file is the human-readable index of the current source-of-truth artifacts.
Update it whenever a durable document, prompt, schema, eval, or export version changes.

## Canonical Artifacts

| Artifact | Current version | Source path | Export path |
| --- | --- | --- | --- |
| Knowledge Map | v0.1 | `docs/00-start-here/knowledge-map.md` | n/a |
| PRD | v0.2 | `docs/10-product/prd-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md` |
| System Design | v0.2 | `docs/20-architecture/system-design-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/system_design_jyotish_companion_v0_2.md` |
| PM First-Principles Guide | v0.2 | `docs/10-product/pm-first-principles-guide.html` | `exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html` |
| Schema Base | v0.2 | `docs/30-data-and-schema/schema-v0.2-base.sql` | `exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql` |
| Schema v0.3 Change Spec | v0.1 | `docs/30-data-and-schema/schema-v0.3-change-spec.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-change-spec.md` |
| Schema v0.3 Discovery and Plan | v0.1 | `docs/30-data-and-schema/schema-v0.3-discovery-and-plan.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-discovery-and-plan.md` |
| Context SOP | v0.2 | `docs/50-operations/context-versioning-sop.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/context-versioning-sop.md` |
| Way Forward | v0.2 | `docs/10-product/way-forward.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/01-way-forward.md` |
| Docs Site Guide | v0.1 | `docs/00-start-here/docs-site-guide.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/docs-site-guide.md` |
| Repository Split Execution Plan | v0.1 | `docs/50-operations/repo-split-execution-plan.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/repo-split-execution-plan.md` |
| Source Materials Archive | v0.1 | `docs/90-archive/source-materials/index.md` | n/a |
| Completion Audit | v0.1 | `docs/50-operations/completion-audit.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/completion-audit.md` |
| GitHub Setup | v0.1 | `docs/50-operations/github-setup.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/github-setup.md` |
| External Publish Runbook | v0.1 | `docs/50-operations/external-publish-runbook.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/external-publish-runbook.md` |
| Astrologer Persona Prompt | v0.2 | `docs/40-ai-quality/prompts/astrologer-persona-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_astrologer_persona_v0_2.md` |
| Profile Synthesizer Prompt | v0.2 | `docs/40-ai-quality/prompts/profile-synthesizer-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_profile_synthesizer_v0_2.md` |
| Memory Extractor Prompt | v0.2 | `docs/40-ai-quality/prompts/memory-extractor-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_memory_extractor_v0_2.md` |
| Prediction Evaluator Prompt | v0.2 | `docs/40-ai-quality/prompts/prediction-evaluator-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_prediction_evaluator_v0_2.md` |
| Model Router Eval Rubric | v0.1 | `docs/40-ai-quality/evals/model-router-validation-v0.1.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_validation_v0_1.md` |
| Responsible Prediction Eval Rubric | v0.1 | `docs/40-ai-quality/evals/responsible-prediction-v0.1.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/evals_responsible_prediction_v0_1.md` |
| Model Router Eval Fixtures | v0.1 | `docs/40-ai-quality/evals/model-router-cases-v0.1.jsonl` | `exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_cases_v0_1.jsonl` |

## ADR Index

| ADR | Status | Topic |
| --- | --- | --- |
| `docs/60-decisions/adr/0001-provider-neutral-embeddings.md` | accepted | Provider-neutral embeddings |
| `docs/60-decisions/adr/0002-safe-knowledge-rag.md` | accepted | Reviewed Jyotish knowledge retrieval |
| `docs/60-decisions/adr/0003-extension-ready-analysis-model.md` | accepted | Generic analysis runs |
| `docs/60-decisions/adr/0004-model-router-and-open-model-strategy.md` | accepted | Model router and open-model validation |
| `docs/60-decisions/adr/0005-responsible-prediction-ux.md` | accepted | Responsible prediction delivery |
| `docs/60-decisions/adr/0006-end-of-chat-memory-review.md` | accepted | End-of-chat Manual memory review |

## Versioning Rules

- Update this manifest in the same PR as any artifact version change.
- Keep exports derived from canonical source paths.
- Use ADRs for durable decisions that change architecture, schema, safety, provider strategy, or model behavior.
- Do not overwrite generated outputs in place. Supersede older outputs through explicit version fields and links.
- Run `scripts/verify_artifacts.sh` before merging.

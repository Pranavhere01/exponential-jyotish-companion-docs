# Version Manifest

Status: Draft v0.1  
Date: 2026-06-29

This file is the human-readable index of the current source-of-truth artifacts.
Update it whenever a durable document, prompt, schema, eval, or export version changes.

## Canonical Artifacts

| Artifact | Current version | Source path | Export path |
| --- | --- | --- | --- |
| Knowledge Map | v0.1 | `docs/handbook/knowledge-map.md` | n/a |
| PRD | v0.2 | `docs/product/requirements/prd-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md` |
| System Design | v0.2 | `docs/architecture/system/system-design-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/system_design_jyotish_companion_v0_2.md` |
| Multi-Turn Chat Harness Pattern | v0 | `docs/architecture/patterns/chat-harness/README.md` | n/a |
| PM First-Principles Guide | v0.2 | `docs/product/guides/pm-first-principles-guide.html` | `exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html` |
| Schema Base | v0.2 | `docs/engineering/data-model/schema-v0.2-base.sql` | `exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql` |
| Schema v0.3 Change Spec | v0.1 | `docs/engineering/data-model/schema-v0.3-change-spec.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-change-spec.md` |
| Schema v0.3 Discovery and Plan | v0.1 | `docs/engineering/data-model/schema-v0.3-discovery-and-plan.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-discovery-and-plan.md` |
| Context SOP | v0.2 | `docs/governance/standards/context-versioning-sop.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/context-versioning-sop.md` |
| Way Forward | v0.2 | `docs/product/strategy/way-forward.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/01-way-forward.md` |
| Contribution Guide | v0.1 | `docs/handbook/contribution-guide.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/contribution-guide.md` |
| Repository Split Execution Plan | v0.1 | `docs/operations/repository/repo-split-execution-plan.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/repo-split-execution-plan.md` |
| Source Materials Archive | v0.1 | `docs/archive/source-materials/index.md` | n/a |
| Completion Audit | v0.1 | `docs/operations/audits/completion-audit.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/completion-audit.md` |
| GitHub Setup | v0.1 | `docs/operations/repository/github-setup.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/github-setup.md` |
| External Publish Runbook | v0.1 | `docs/operations/publishing/external-publish-runbook.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/external-publish-runbook.md` |
| Astrologer Persona Prompt | v0.2 | `docs/ai/prompts/astrologer-persona-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_astrologer_persona_v0_2.md` |
| Profile Synthesizer Prompt | v0.2 | `docs/ai/prompts/profile-synthesizer-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_profile_synthesizer_v0_2.md` |
| Memory Extractor Prompt | v0.2 | `docs/ai/prompts/memory-extractor-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_memory_extractor_v0_2.md` |
| Prediction Evaluator Prompt | v0.2 | `docs/ai/prompts/prediction-evaluator-v0.2.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/prompts_prediction_evaluator_v0_2.md` |
| Model Router Eval Rubric | v0.1 | `docs/ai/evaluation/model-router-validation-v0.1.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_validation_v0_1.md` |
| Responsible Prediction Eval Rubric | v0.1 | `docs/ai/evaluation/responsible-prediction-v0.1.md` | `exports/google-drive/Exponential/Astrology/Documents/Text/evals_responsible_prediction_v0_1.md` |
| Model Router Eval Fixtures | v0.1 | `docs/ai/evaluation/model-router-cases-v0.1.jsonl` | `exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_cases_v0_1.jsonl` |

## ADR Index

| ADR | Status | Topic |
| --- | --- | --- |
| `docs/governance/decisions/adr/0001-provider-neutral-embeddings.md` | accepted | Provider-neutral embeddings |
| `docs/governance/decisions/adr/0002-safe-knowledge-rag.md` | accepted | Reviewed Jyotish knowledge retrieval |
| `docs/governance/decisions/adr/0003-extension-ready-analysis-model.md` | accepted | Generic analysis runs |
| `docs/governance/decisions/adr/0004-model-router-and-open-model-strategy.md` | accepted | Model router and open-model validation |
| `docs/governance/decisions/adr/0005-responsible-prediction-ux.md` | accepted | Responsible prediction delivery |
| `docs/governance/decisions/adr/0006-end-of-chat-memory-review.md` | accepted | End-of-chat Manual memory review |

## Versioning Rules

- Update this manifest in the same PR as any artifact version change.
- Keep exports derived from canonical source paths.
- Use ADRs for durable decisions that change architecture, schema, safety, provider strategy, or model behavior.
- Do not overwrite generated outputs in place. Supersede older outputs through explicit version fields and links.
- Run `scripts/verify_artifacts.sh` before merging.

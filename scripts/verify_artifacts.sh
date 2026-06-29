#!/usr/bin/env bash
set -euo pipefail

python3 -m html.parser docs/product/guides/pm-first-principles-guide.html
python3 -m html.parser docs/architecture/patterns/chat-harness/chat-harness-v0.html
python3 -m html.parser exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html
python3 -m html.parser docs/archive/source-materials/original-html/jyotish_companion_data_architecture.html
python3 -m html.parser docs/archive/source-materials/original-html/jyotish_companion_prd.html
python3 -m html.parser docs/archive/source-materials/original-html/personal-ai-astrologer-architecture.html

test -f docs/product/requirements/prd-v0.2.md
test -f docs/architecture/system/system-design-v0.2.md
test -f docs/engineering/data-model/schema-v0.2-base.sql
test -f mkdocs.yml
test -f docs/index.md
test -f docs/handbook/index.md
test -f docs/handbook/knowledge-architecture.md
test -f docs/handbook/knowledge-map.md
test -f docs/handbook/metadata-standard.md
test -f docs/handbook/artifact-registry.md
test -f docs/handbook/artifact-registry.yaml
test -f docs/handbook/relation-types.md
test -f docs/handbook/contribution-guide.md
test -f docs/handbook/version-manifest.md
test -f docs/product/index.md
test -f docs/architecture/index.md
test -f docs/architecture/patterns/index.md
test -f docs/architecture/patterns/context-graph-knowledge-system/README.md
test -f docs/architecture/patterns/chat-harness/README.md
test -f docs/architecture/patterns/chat-harness/chat-harness-v0.html
test -f docs/engineering/index.md
test -f docs/engineering/data-model/index.md
test -f docs/engineering/data-model/schema-v0.2-base.md
test -f docs/ai/index.md
test -f docs/operations/index.md
test -f docs/operations/repository/index.md
test -f docs/operations/publishing/index.md
test -f docs/operations/audits/index.md
test -f docs/domain-knowledge/index.md
test -f docs/domain-knowledge/jyotish/index.md
test -f docs/governance/index.md
test -f docs/governance/decisions/index.md
test -f docs/governance/decisions/adr/index.md
test -f docs/governance/decisions/adr/0007-context-graph-knowledge-system.md
test -f docs/governance/standards/index.md
test -f docs/archive/index.md
test -f docs/operations/repository/repo-split-execution-plan.md
test -f docs/archive/source-materials/index.md
test -f docs/archive/source-materials/original-html/jyotish_companion_data_architecture.html
test -f docs/archive/source-materials/original-html/jyotish_companion_prd.html
test -f docs/archive/source-materials/original-html/personal-ai-astrologer-architecture.html
test -f docs/archive/source-materials/codex-attachments/goal-objective.md
test -f docs/archive/source-materials/codex-attachments/prd-v0.1-pasted-text.txt
test -f docs/archive/source-materials/codex-attachments/system-design-v0.1-pasted-text.txt
test -f docs/archive/source-materials/codex-attachments/schema-v0.3-change-spec-pasted-text.txt
test -f docs/engineering/data-model/schema-v0.3-change-spec.md
test -f docs/engineering/data-model/schema-v0.3-discovery-and-plan.md
test -f docs/operations/audits/completion-audit.md
test -f docs/handbook/version-manifest.md
test -f .github/workflows/verify-artifacts.yml
test -f .github/workflows/deploy-docs-pages.yml
test -f docs/ai/prompts/astrologer-persona-v0.2.md
test -f docs/ai/prompts/profile-synthesizer-v0.2.md
test -f docs/ai/prompts/memory-extractor-v0.2.md
test -f docs/ai/prompts/prediction-evaluator-v0.2.md
test -f docs/ai/evaluation/model-router-validation-v0.1.md
test -f docs/ai/evaluation/responsible-prediction-v0.1.md
test -f docs/ai/evaluation/model-router-cases-v0.1.jsonl
test -f skills/jyotish-docs-entry/SKILL.md
test -f skills/jyotish-docs-entry/references/project-context.md
test -f skills/jyotish-docs-entry/agents/openai.yaml
test -f exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/system_design_jyotish_companion_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/version-manifest.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-change-spec.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-discovery-and-plan.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/contribution-guide.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/repo-split-execution-plan.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/completion-audit.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/github-setup.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/external-publish-runbook.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/prompts_astrologer_persona_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_cases_v0_1.jsonl

cmp -s docs/product/requirements/prd-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md
cmp -s docs/architecture/system/system-design-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/system_design_jyotish_companion_v0_2.md
cmp -s docs/product/strategy/way-forward.md exports/google-drive/Exponential/Astrology/Documents/Text/01-way-forward.md
cmp -s docs/engineering/data-model/schema-v0.2-base.sql exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql
cmp -s docs/handbook/version-manifest.md exports/google-drive/Exponential/Astrology/Documents/Text/version-manifest.md
cmp -s docs/operations/audits/completion-audit.md exports/google-drive/Exponential/Astrology/Documents/Text/completion-audit.md
cmp -s docs/operations/repository/github-setup.md exports/google-drive/Exponential/Astrology/Documents/Text/github-setup.md
cmp -s docs/operations/publishing/external-publish-runbook.md exports/google-drive/Exponential/Astrology/Documents/Text/external-publish-runbook.md
cmp -s docs/governance/standards/context-versioning-sop.md exports/google-drive/Exponential/Astrology/Documents/Text/context-versioning-sop.md
cmp -s docs/operations/repository/repo-split-execution-plan.md exports/google-drive/Exponential/Astrology/Documents/Text/repo-split-execution-plan.md
cmp -s docs/engineering/data-model/schema-v0.3-change-spec.md exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-change-spec.md
cmp -s docs/engineering/data-model/schema-v0.3-discovery-and-plan.md exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-discovery-and-plan.md
cmp -s docs/ai/prompts/index.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_README.md
cmp -s docs/ai/prompts/astrologer-persona-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_astrologer_persona_v0_2.md
cmp -s docs/ai/prompts/profile-synthesizer-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_profile_synthesizer_v0_2.md
cmp -s docs/ai/prompts/memory-extractor-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_memory_extractor_v0_2.md
cmp -s docs/ai/prompts/prediction-evaluator-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_prediction_evaluator_v0_2.md
cmp -s docs/ai/evaluation/index.md exports/google-drive/Exponential/Astrology/Documents/Text/evals_README.md
cmp -s docs/ai/evaluation/model-router-validation-v0.1.md exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_validation_v0_1.md
cmp -s docs/ai/evaluation/responsible-prediction-v0.1.md exports/google-drive/Exponential/Astrology/Documents/Text/evals_responsible_prediction_v0_1.md
cmp -s docs/ai/evaluation/model-router-cases-v0.1.jsonl exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_cases_v0_1.jsonl

python3 - <<'PY'
import json
from pathlib import Path

path = Path("docs/ai/evaluation/model-router-cases-v0.1.jsonl")
with path.open() as handle:
    for index, line in enumerate(handle, 1):
        if line.strip():
            json.loads(line)
PY

python3 - <<'PY'
from pathlib import Path
import yaml

path = Path("docs/handbook/artifact-registry.yaml")
data = yaml.safe_load(path.read_text())
assert data["registry_version"] == "v0.1"
artifact_ids = {artifact["id"] for artifact in data["artifacts"]}
required = {
    "prd:v0.2",
    "pattern:context-graph-knowledge-system:v0.1",
    "domain-knowledge:jyotish:index:v0.1",
    "skill:jyotish-docs-entry:v0.1",
}
missing = required - artifact_ids
if missing:
    raise SystemExit(f"Missing artifact registry ids: {sorted(missing)}")
PY

if rg -n "Only safe chunks|Only approved chunks|approved_for_user_retrieval" README.md docs exports --glob '!docs/archive/source-materials/**'; then
  echo "Found retired safe-chunks-only wording." >&2
  exit 1
fi

rg -n "model_routes|memory_candidates|prediction_evaluations|delivery_policy" docs/engineering/data-model/schema-v0.2-base.sql >/dev/null
rg -n "prompt_key|prompt_version|model_route" docs/ai/prompts >/dev/null
rg -n "model_router_validation|responsible_prediction" docs/ai/evaluation >/dev/null
rg -n "Model Router|Provider-Neutral Embeddings|Responsible Prediction Delivery|Future Analyses" docs/architecture/system/system-design-v0.2.md >/dev/null
rg -n "PRD|System Design|Schema Base|Astrologer Persona Prompt|Model Router Eval Rubric" docs/handbook/version-manifest.md >/dev/null
rg -n "Schema v0.3 Change Spec|Schema v0.3 Discovery and Plan" docs/handbook/version-manifest.md >/dev/null
rg -n "Completion Audit|GitHub Setup|External Publish Runbook" docs/handbook/version-manifest.md >/dev/null
rg -n "async_tasks|Embedding lifecycle|Hybrid retrieval|Chart reproducibility" docs/engineering/data-model/schema-v0.3-change-spec.md >/dev/null
rg -n "blocked for direct migration|memory_facts|text_embeddings|Draft PR description" docs/engineering/data-model/schema-v0.3-discovery-and-plan.md >/dev/null
rg -n "schema v0.3|runnable application repo|main.*stable baseline|dev.*working branch" docs/operations/audits/completion-audit.md >/dev/null
rg -n "exponential-jyotish-companion-docs|exponential-jyotish-companion-platform" README.md docs/index.md docs/operations/repository/github-setup.md docs/operations/publishing/external-publish-runbook.md docs/operations/audits/completion-audit.md >/dev/null
rg -n "Stage 1 - Set Up Documentation Repository|Stage 3 - Empty Main Platform Repository|Stage 5 - Build Platform Structure Plan" docs/operations/repository/repo-split-execution-plan.md >/dev/null
rg -n "Original HTML Exports|Codex Attachment Inputs|goal-objective.md" docs/archive/source-materials/index.md >/dev/null
rg -n "mkdocs-material|deploy-pages|mkdocs build --strict" .github/workflows/deploy-docs-pages.yml >/dev/null
rg -n "site_name: Exponential Jyotish Companion Docs|docs_dir: docs" mkdocs.yml >/dev/null
rg -n "Add Or Change A Document|Quality Bar|docs-as-code" docs/handbook/contribution-guide.md >/dev/null
rg -n "First Read Path|Placement Guide|Current Source Of Truth" docs/handbook/knowledge-map.md >/dev/null
rg -n "Information Architecture|Enterprise Rules|Naming Standard|Review Standard" docs/handbook/knowledge-architecture.md >/dev/null
rg -n "Required Fields|Relationship Rules|runtime_user_context" docs/handbook/metadata-standard.md >/dev/null
rg -n "registry_version: v0.1|prd:v0.2|pattern:context-graph-knowledge-system:v0.1|skill:jyotish-docs-entry:v0.1" docs/handbook/artifact-registry.yaml >/dev/null
rg -n "implemented_by|implements_policy|governed_by|Runtime Edge Label Examples" docs/handbook/relation-types.md >/dev/null
rg -n "Reviewed chunks|delivery_policy|context_graph_nodes|not a positivity filter" docs/domain-knowledge/jyotish/index.md >/dev/null
rg -n "Multi-Turn Chat Harness|End-To-End Flow|Recommended Jyotish Companion Mapping" docs/architecture/patterns/chat-harness/README.md >/dev/null
rg -n "architecture/patterns/chat-harness/README.md|Multi-Turn Chat Harness" mkdocs.yml docs/architecture/index.md docs/handbook/knowledge-map.md docs/handbook/version-manifest.md >/dev/null
rg -n "Context Graph And Knowledge System|Graph Scopes|Explanation Packet|Stale Fact Rule" docs/architecture/patterns/context-graph-knowledge-system/README.md >/dev/null
rg -n "0007-context-graph-knowledge-system|Context Graph And Knowledge System|Context Graph And Knowledge System Pattern" mkdocs.yml docs/architecture/index.md docs/architecture/patterns/index.md docs/handbook/knowledge-map.md docs/handbook/version-manifest.md docs/governance/decisions/adr/index.md >/dev/null
rg -n "Context Graph And Knowledge System|context-graph-knowledge-system" README.md docs/index.md >/dev/null
rg -n "Postgres-first|runtime_user_context|context_assembly_runs|Neo4j" docs/governance/decisions/adr/0007-context-graph-knowledge-system.md >/dev/null
rg -n "name: jyotish-docs-entry|artifact-registry.yaml|mkdocs build --strict|Postgres-first context graph" skills/jyotish-docs-entry/SKILL.md skills/jyotish-docs-entry/references/project-context.md >/dev/null
rg -n "handbook|product|architecture|engineering|ai|governance|operations|domain-knowledge|archive" README.md docs/handbook/knowledge-map.md mkdocs.yml >/dev/null
if rg -n "00-start-here|10-product|20-architecture|30-data-and-schema|40-ai-quality|50-operations|60-decisions|90-archive|docs/ai/evals|docs/governance/adr" README.md docs mkdocs.yml --glob '!docs/archive/source-materials/**'; then
  echo "Found retired folder taxonomy or stale docs path." >&2
  exit 1
fi
rg -n "main = stable baseline|dev  = working branch|collaborator-username" scripts/publish_to_github_after_auth.sh >/dev/null
rg -n "main.*stable baseline|dev.*working branch" docs/operations/repository/github-setup.md docs/operations/publishing/external-publish-runbook.md >/dev/null
rg -n "1WwsQmCiCqZxCctNEfqdnGwKJjtC2ChWf|1by8WT9dQ_jgxEd5irK5vy3A4fwYyZBzI|1uLn5DvIVTMw2yWJ83xM8TEx_a68wqwwb" docs/operations/publishing/external-publish-runbook.md docs/governance/standards/context-versioning-sop.md docs/operations/audits/completion-audit.md exports/google-drive/README.md >/dev/null
rg -n "schema-v0.3-change-spec|completion-audit|external-publish-runbook" exports/google-drive/README.md >/dev/null
rg -n "scripts/verify_artifacts.sh" .github/workflows/verify-artifacts.yml >/dev/null

echo "Artifacts verified."

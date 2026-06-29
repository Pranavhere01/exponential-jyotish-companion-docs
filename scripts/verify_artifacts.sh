#!/usr/bin/env bash
set -euo pipefail

python3 -m html.parser docs/10-product/pm-first-principles-guide.html
python3 -m html.parser exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html
python3 -m html.parser docs/90-archive/source-materials/original-html/jyotish_companion_data_architecture.html
python3 -m html.parser docs/90-archive/source-materials/original-html/jyotish_companion_prd.html
python3 -m html.parser docs/90-archive/source-materials/original-html/personal-ai-astrologer-architecture.html

test -f docs/10-product/prd-v0.2.md
test -f docs/20-architecture/system-design-v0.2.md
test -f docs/30-data-and-schema/schema-v0.2-base.sql
test -f mkdocs.yml
test -f docs/index.md
test -f docs/00-start-here/index.md
test -f docs/00-start-here/knowledge-map.md
test -f docs/00-start-here/docs-site-guide.md
test -f docs/10-product/index.md
test -f docs/20-architecture/index.md
test -f docs/30-data-and-schema/index.md
test -f docs/30-data-and-schema/schema-v0.2-base.md
test -f docs/40-ai-quality/index.md
test -f docs/50-operations/index.md
test -f docs/60-decisions/index.md
test -f docs/60-decisions/adr/index.md
test -f docs/90-archive/index.md
test -f docs/50-operations/repo-split-execution-plan.md
test -f docs/90-archive/source-materials/index.md
test -f docs/90-archive/source-materials/original-html/jyotish_companion_data_architecture.html
test -f docs/90-archive/source-materials/original-html/jyotish_companion_prd.html
test -f docs/90-archive/source-materials/original-html/personal-ai-astrologer-architecture.html
test -f docs/90-archive/source-materials/codex-attachments/goal-objective.md
test -f docs/90-archive/source-materials/codex-attachments/prd-v0.1-pasted-text.txt
test -f docs/90-archive/source-materials/codex-attachments/system-design-v0.1-pasted-text.txt
test -f docs/90-archive/source-materials/codex-attachments/schema-v0.3-change-spec-pasted-text.txt
test -f docs/30-data-and-schema/schema-v0.3-change-spec.md
test -f docs/30-data-and-schema/schema-v0.3-discovery-and-plan.md
test -f docs/50-operations/completion-audit.md
test -f docs/00-start-here/version-manifest.md
test -f .github/workflows/verify-artifacts.yml
test -f .github/workflows/deploy-docs-pages.yml
test -f docs/40-ai-quality/prompts/astrologer-persona-v0.2.md
test -f docs/40-ai-quality/prompts/profile-synthesizer-v0.2.md
test -f docs/40-ai-quality/prompts/memory-extractor-v0.2.md
test -f docs/40-ai-quality/prompts/prediction-evaluator-v0.2.md
test -f docs/40-ai-quality/evals/model-router-validation-v0.1.md
test -f docs/40-ai-quality/evals/responsible-prediction-v0.1.md
test -f docs/40-ai-quality/evals/model-router-cases-v0.1.jsonl
test -f exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/system_design_jyotish_companion_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/version-manifest.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-change-spec.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-discovery-and-plan.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/docs-site-guide.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/repo-split-execution-plan.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/completion-audit.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/github-setup.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/external-publish-runbook.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/prompts_astrologer_persona_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_cases_v0_1.jsonl

cmp -s docs/10-product/prd-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md
cmp -s docs/20-architecture/system-design-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/system_design_jyotish_companion_v0_2.md
cmp -s docs/10-product/way-forward.md exports/google-drive/Exponential/Astrology/Documents/Text/01-way-forward.md
cmp -s docs/30-data-and-schema/schema-v0.2-base.sql exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql
cmp -s docs/00-start-here/version-manifest.md exports/google-drive/Exponential/Astrology/Documents/Text/version-manifest.md
cmp -s docs/50-operations/completion-audit.md exports/google-drive/Exponential/Astrology/Documents/Text/completion-audit.md
cmp -s docs/50-operations/github-setup.md exports/google-drive/Exponential/Astrology/Documents/Text/github-setup.md
cmp -s docs/50-operations/external-publish-runbook.md exports/google-drive/Exponential/Astrology/Documents/Text/external-publish-runbook.md
cmp -s docs/50-operations/context-versioning-sop.md exports/google-drive/Exponential/Astrology/Documents/Text/context-versioning-sop.md
cmp -s docs/50-operations/repo-split-execution-plan.md exports/google-drive/Exponential/Astrology/Documents/Text/repo-split-execution-plan.md
cmp -s docs/30-data-and-schema/schema-v0.3-change-spec.md exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-change-spec.md
cmp -s docs/30-data-and-schema/schema-v0.3-discovery-and-plan.md exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-discovery-and-plan.md
cmp -s docs/40-ai-quality/prompts/index.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_README.md
cmp -s docs/40-ai-quality/prompts/astrologer-persona-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_astrologer_persona_v0_2.md
cmp -s docs/40-ai-quality/prompts/profile-synthesizer-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_profile_synthesizer_v0_2.md
cmp -s docs/40-ai-quality/prompts/memory-extractor-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_memory_extractor_v0_2.md
cmp -s docs/40-ai-quality/prompts/prediction-evaluator-v0.2.md exports/google-drive/Exponential/Astrology/Documents/Text/prompts_prediction_evaluator_v0_2.md
cmp -s docs/40-ai-quality/evals/index.md exports/google-drive/Exponential/Astrology/Documents/Text/evals_README.md
cmp -s docs/40-ai-quality/evals/model-router-validation-v0.1.md exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_validation_v0_1.md
cmp -s docs/40-ai-quality/evals/responsible-prediction-v0.1.md exports/google-drive/Exponential/Astrology/Documents/Text/evals_responsible_prediction_v0_1.md
cmp -s docs/40-ai-quality/evals/model-router-cases-v0.1.jsonl exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_cases_v0_1.jsonl

python3 - <<'PY'
import json
from pathlib import Path

path = Path("docs/40-ai-quality/evals/model-router-cases-v0.1.jsonl")
with path.open() as handle:
    for index, line in enumerate(handle, 1):
        if line.strip():
            json.loads(line)
PY

if rg -n "Only safe chunks|Only approved chunks|approved_for_user_retrieval" README.md docs exports --glob '!docs/90-archive/source-materials/**'; then
  echo "Found retired safe-chunks-only wording." >&2
  exit 1
fi

rg -n "model_routes|memory_candidates|prediction_evaluations|delivery_policy" docs/30-data-and-schema/schema-v0.2-base.sql >/dev/null
rg -n "prompt_key|prompt_version|model_route" docs/40-ai-quality/prompts >/dev/null
rg -n "model_router_validation|responsible_prediction" docs/40-ai-quality/evals >/dev/null
rg -n "Model Router|Provider-Neutral Embeddings|Responsible Prediction Delivery|Future Analyses" docs/20-architecture/system-design-v0.2.md >/dev/null
rg -n "PRD|System Design|Schema Base|Astrologer Persona Prompt|Model Router Eval Rubric" docs/00-start-here/version-manifest.md >/dev/null
rg -n "Schema v0.3 Change Spec|Schema v0.3 Discovery and Plan" docs/00-start-here/version-manifest.md >/dev/null
rg -n "Completion Audit|GitHub Setup|External Publish Runbook" docs/00-start-here/version-manifest.md >/dev/null
rg -n "async_tasks|Embedding lifecycle|Hybrid retrieval|Chart reproducibility" docs/30-data-and-schema/schema-v0.3-change-spec.md >/dev/null
rg -n "blocked for direct migration|memory_facts|text_embeddings|Draft PR description" docs/30-data-and-schema/schema-v0.3-discovery-and-plan.md >/dev/null
rg -n "schema v0.3|runnable application repo|main.*stable baseline|dev.*working branch" docs/50-operations/completion-audit.md >/dev/null
rg -n "exponential-jyotish-companion-docs|exponential-jyotish-companion-platform" README.md docs/index.md docs/50-operations/github-setup.md docs/50-operations/external-publish-runbook.md docs/50-operations/completion-audit.md >/dev/null
rg -n "Stage 1 - Set Up Documentation Repository|Stage 3 - Empty Main Platform Repository|Stage 5 - Build Platform Structure Plan" docs/50-operations/repo-split-execution-plan.md >/dev/null
rg -n "Original HTML Exports|Codex Attachment Inputs|goal-objective.md" docs/90-archive/source-materials/index.md >/dev/null
rg -n "mkdocs-material|deploy-pages|mkdocs build --strict" .github/workflows/deploy-docs-pages.yml >/dev/null
rg -n "site_name: Exponential Jyotish Companion Docs|docs_dir: docs" mkdocs.yml >/dev/null
rg -n "How to add a new document|GitHub Pages|Markdown-first" docs/00-start-here/docs-site-guide.md >/dev/null
rg -n "First read path|Where to put a new document|What must never be lost" docs/00-start-here/knowledge-map.md >/dev/null
rg -n "00-start-here|10-product|20-architecture|30-data-and-schema|40-ai-quality|50-operations|60-decisions|90-archive" README.md docs/00-start-here/knowledge-map.md mkdocs.yml >/dev/null
rg -n "main = stable baseline|dev  = working branch|collaborator-username" scripts/publish_to_github_after_auth.sh >/dev/null
rg -n "main.*stable baseline|dev.*working branch" docs/50-operations/github-setup.md docs/50-operations/external-publish-runbook.md >/dev/null
rg -n "1WwsQmCiCqZxCctNEfqdnGwKJjtC2ChWf|1by8WT9dQ_jgxEd5irK5vy3A4fwYyZBzI|1uLn5DvIVTMw2yWJ83xM8TEx_a68wqwwb" docs/50-operations/external-publish-runbook.md docs/50-operations/context-versioning-sop.md docs/50-operations/completion-audit.md exports/google-drive/README.md >/dev/null
rg -n "schema-v0.3-change-spec|completion-audit|external-publish-runbook" exports/google-drive/README.md >/dev/null
rg -n "scripts/verify_artifacts.sh" .github/workflows/verify-artifacts.yml >/dev/null

echo "Artifacts verified."

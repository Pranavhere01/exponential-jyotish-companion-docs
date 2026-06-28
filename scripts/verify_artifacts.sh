#!/usr/bin/env bash
set -euo pipefail

python3 -m html.parser docs/pm_first_principles_guide.html
python3 -m html.parser exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html

test -f docs/prd_jyotish_companion_v0_2.md
test -f docs/system_design_jyotish_companion_v0_2.md
test -f db/schema_v0_2_base.sql
test -f docs/schema-v0.3-change-spec.md
test -f docs/schema-v0.3-discovery-and-plan.md
test -f docs/completion-audit.md
test -f docs/version-manifest.md
test -f .github/workflows/verify-artifacts.yml
test -f prompts/astrologer_persona/v0.2.md
test -f prompts/profile_synthesizer/v0.2.md
test -f prompts/memory_extractor/v0.2.md
test -f prompts/prediction_evaluator/v0.2.md
test -f evals/rubrics/model_router_validation_v0.1.md
test -f evals/rubrics/responsible_prediction_v0.1.md
test -f evals/fixtures/model_router_cases_v0.1.jsonl
test -f exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/system_design_jyotish_companion_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/version-manifest.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-change-spec.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-discovery-and-plan.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/completion-audit.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/github-setup.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/external-publish-runbook.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/prompts_astrologer_persona_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_cases_v0_1.jsonl

cmp -s docs/version-manifest.md exports/google-drive/Exponential/Astrology/Documents/Text/version-manifest.md
cmp -s docs/completion-audit.md exports/google-drive/Exponential/Astrology/Documents/Text/completion-audit.md
cmp -s docs/schema-v0.3-change-spec.md exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-change-spec.md
cmp -s docs/schema-v0.3-discovery-and-plan.md exports/google-drive/Exponential/Astrology/Documents/Text/schema-v0.3-discovery-and-plan.md

python3 - <<'PY'
import json
from pathlib import Path

path = Path("evals/fixtures/model_router_cases_v0.1.jsonl")
with path.open() as handle:
    for index, line in enumerate(handle, 1):
        if line.strip():
            json.loads(line)
PY

if rg -n "Only safe chunks|Only approved chunks|approved_for_user_retrieval" README.md docs db prompts evals exports; then
  echo "Found retired safe-chunks-only wording." >&2
  exit 1
fi

rg -n "model_routes|memory_candidates|prediction_evaluations|delivery_policy" db/schema_v0_2_base.sql >/dev/null
rg -n "prompt_key|prompt_version|model_route" prompts >/dev/null
rg -n "model_router_validation|responsible_prediction" evals >/dev/null
rg -n "Model Router|Provider-Neutral Embeddings|Responsible Prediction Delivery|Future Analyses" docs/system_design_jyotish_companion_v0_2.md >/dev/null
rg -n "PRD|System Design|Schema Base|Astrologer Persona Prompt|Model Router Eval Rubric" docs/version-manifest.md >/dev/null
rg -n "Schema v0.3 Change Spec|Schema v0.3 Discovery and Plan" docs/version-manifest.md >/dev/null
rg -n "Completion Audit|GitHub Setup|External Publish Runbook" docs/version-manifest.md >/dev/null
rg -n "async_tasks|Embedding lifecycle|Hybrid retrieval|Chart reproducibility" docs/schema-v0.3-change-spec.md >/dev/null
rg -n "blocked for direct migration|memory_facts|text_embeddings|Draft PR description" docs/schema-v0.3-discovery-and-plan.md >/dev/null
rg -n "schema v0.3|runnable application repo|feat/schema-v0.3" docs/completion-audit.md >/dev/null
rg -n "scripts/verify_artifacts.sh" .github/workflows/verify-artifacts.yml >/dev/null

echo "Artifacts verified."

#!/usr/bin/env bash
set -euo pipefail

python3 -m html.parser docs/pm_first_principles_guide.html
python3 -m html.parser exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html

test -f docs/prd_jyotish_companion_v0_2.md
test -f docs/system_design_jyotish_companion_v0_2.md
test -f db/schema_v0_2_base.sql
test -f docs/completion-audit.md
test -f prompts/astrologer_persona/v0.2.md
test -f prompts/profile_synthesizer/v0.2.md
test -f prompts/memory_extractor/v0.2.md
test -f prompts/prediction_evaluator/v0.2.md
test -f evals/rubrics/model_router_validation_v0.1.md
test -f evals/rubrics/responsible_prediction_v0.1.md
test -f evals/fixtures/model_router_cases_v0.1.jsonl
test -f exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/system_design_jyotish_companion_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql
test -f exports/google-drive/Exponential/Astrology/Documents/Text/prompts_astrologer_persona_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/evals_model_router_cases_v0_1.jsonl

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

echo "Artifacts verified."

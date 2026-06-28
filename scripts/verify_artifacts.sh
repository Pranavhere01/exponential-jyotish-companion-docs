#!/usr/bin/env bash
set -euo pipefail

python3 -m html.parser docs/pm_first_principles_guide.html
python3 -m html.parser exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html

test -f docs/prd_jyotish_companion_v0_2.md
test -f db/schema_v0_2_base.sql
test -f docs/completion-audit.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/prd_jyotish_companion_v0_2.md
test -f exports/google-drive/Exponential/Astrology/Documents/Text/schema_v0_2_base.sql

if rg -n "Only safe chunks|Only approved chunks|approved_for_user_retrieval" README.md docs db exports; then
  echo "Found retired safe-chunks-only wording." >&2
  exit 1
fi

rg -n "model_routes|memory_candidates|prediction_evaluations|delivery_policy" db/schema_v0_2_base.sql >/dev/null

echo "Artifacts verified."


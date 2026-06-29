# Prompt Artifacts

Status: Draft v0.2  
Date: 2026-06-29

This folder stores prompt source files as versioned product artifacts.

Rules:

- Every prompt file must include `prompt_key`, `prompt_version`, and intended `model_route`.
- Prompts are not the only safety layer. Hard safety rules also need independent evaluator and gateway checks.
- Persona upgrades create a new version. Existing generated profiles should be marked `superseded` or regenerated through a tracked job.
- Prompt changes should be reviewed through pull requests and tested against `docs/40-ai-quality/evals/`.

Current prompt set:

- `astrologer_persona/v0.2.md`
- `profile_synthesizer/v0.2.md`
- `memory_extractor/v0.2.md`
- `prediction_evaluator/v0.2.md`

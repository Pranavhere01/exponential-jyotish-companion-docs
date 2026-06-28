# SOP: Context and Version Control

Status: Draft v0.2  
Date: 2026-06-28

## Rule 1: Git is the source of truth

All product, architecture, schema, prompt, eval, and SOP context for Exponential Jyotish Companion lives in the Exponential shared Git repository from day 1.

Google Drive can hold exports for reading or presentation, but Drive files are not the canonical source. If a decision is only in Drive, it is not considered durable.

## Rule 2: Keep context MCP-friendly

Prefer plain text formats:

- Markdown for PRDs, architecture, SOPs, and ADRs.
- SQL for schemas and migrations.
- JSON/YAML for machine-readable configs.
- CSV/JSONL for eval fixtures.
- Prompt files in text/Markdown with explicit version headers.

Avoid making PDFs, screenshots, HTML, or slides the only copy of a decision.

## Rule 3: Use ADRs for decisions

Any decision that changes architecture, schema, safety, provider selection, data retention, costing assumptions, or model behavior gets an ADR.

ADR template:

- Status
- Date
- Context
- Decision
- Consequences

## Rule 4: Use pull requests for meaningful changes

Every non-trivial change should happen through a branch and pull request:

- Branch name: `docs/<topic>` or `schema/<topic>`.
- PR title includes the affected artifact, such as `schema: provider-neutral embeddings`.
- PR description says why the change exists and what it replaces.
- Reviews happen on the diff, not in a separate chat thread.

## Rule 5: Version outputs, do not overwrite meaning

For generated artifacts such as interpretive profiles, reports, prompts, and analysis results:

- Store the generator version.
- Store the prompt version.
- Store the model/provider version.
- Mark older generated outputs as `superseded` or `stale`; do not silently mutate history.

This supports persona upgrades and future use-case-specific versions.

## Rule 6: Costing is business-owned, measurement is engineering-owned

The business team owns pricing and costing decisions. Engineering still records model provider, model version, tokens, latency, cache-hit status, and estimated cost per model call so the business team has reliable data.

## Rule 7: Current project memory

Persistent context to carry forward:

- We work in the Exponential shared repository/folder from day 1.
- Documentation must be versioned clearly and accessible through MCP.
- Memory default is `manual`, with memory confirmation at end-of-chat/CSAT.
- The provider decision is open; route model calls through `model_routes` and do not hard-code an embedding dimension.
- Open-source/open-weight Chinese models are a first validation path, subject to evals and licensing.
- Negative/cautionary predictions are allowed when grounded and responsibly delivered; do not gatekeep all negativity.
- Future features should be backward-compatible and pivot-friendly.

## Rule 8: Drive folder mapping

When publishing exports to Google Drive, use this structure:

- `Exponential / Astrology / Documents / Html` for HTML exports.
- `Exponential / Astrology / Documents / Text` for Markdown or plain-text exports.

The Git file remains canonical even after the Drive export exists.

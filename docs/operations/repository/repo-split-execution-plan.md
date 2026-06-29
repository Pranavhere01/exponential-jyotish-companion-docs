# Repository Split Execution Plan

Status: Draft v0.1  
Date: 2026-06-29

## Goal

Split Jyotish Companion into two clean repositories:

1. `exponential-jyotish-companion-docs` - internal documentation, resources, PRDs, architecture, schemas, prompts, evals, SOPs, and decision history.
2. `exponential-jyotish-companion-platform` - the main application/codebase repository.

Both repositories use:

- `main` as the stable branch.
- `dev` as the working branch.

## Stage 1 - Set Up Documentation Repository

Plan:

- Keep the current knowledge-heavy repository as the documentation/resources repository.
- Add a Markdown-first docs-site scaffold.
- Keep the repository easy to extend by adding `.md` files under `docs/`.
- Add GitHub Pages/MkDocs workflow as the default hosted-docs path.
- Push the complete docs state to both `main` and `dev` in `exponential-jyotish-companion-docs`.

Exit criteria:

- Docs repository exists on GitHub.
- Docs repository has `main` and `dev`.
- `dev` is the working branch.
- `main` contains the complete current docs state for publishing.
- `scripts/verify_artifacts.sh` passes.

## Stage 2 - Populate Documentation Repository

Plan:

- Ensure every durable product, architecture, schema, prompt, eval, SOP, and publishing artifact is in the docs repo.
- Track durable artifacts in `docs/handbook/version-manifest.md`.
- Keep Drive exports as derived copies, not the source of truth.
- Preserve raw schema, prompts, and eval fixtures because they are project knowledge, not app code.

Exit criteria:

- Version manifest includes all durable docs/resources.
- Export package includes all intended Drive-ready text/HTML copies.
- Verification catches missing or stale export copies.

## Stage 3 - Empty Main Platform Repository

Plan:

- Only after Stage 1 and Stage 2 are verified, remove documentation content from the old `exponential-jyotish-companion` repository.
- Preserve the repo itself as the future platform/codebase repo.
- Force-push an empty tree commit to both `main` and `dev` so no documentation knowledge remains in the platform repo.
- Keep repository private.

Exit criteria:

- `exponential-jyotish-companion` has `main` and `dev`.
- Both branches point to an empty tree commit.
- Documentation knowledge lives in the docs repo, not the platform repo.

## Stage 4 - Read and Understand Documentation

Plan:

- Read the PRD, system design, schema, ADRs, SOPs, prompt artifacts, eval artifacts, and PM guide.
- Extract the product invariants and architecture constraints.
- Separate product context from implementation structure.
- Identify what belongs in app code, shared packages, infra, docs, evals, and operations.

Exit criteria:

- A synthesis document exists with product invariants, architecture constraints, and implementation implications.

## Stage 5 - Build Platform Structure Plan

Plan:

- Create a backward-compatible, modular production folder structure for the main platform repo.
- Factor in multi-repo needs before scaffolding code.
- Keep app code independent from docs, but link back to docs repo as the source of product/architecture truth.
- Prefer incremental phases over a giant first commit.

Exit criteria:

- A phased platform repository structure plan exists.
- The plan identifies which packages/services/modules come first.
- The plan explains how the structure supports future pivots, model routing, deterministic chart computation, memory, evals, and multi-subject analyses.

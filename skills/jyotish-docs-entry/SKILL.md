---
name: jyotish-docs-entry
description: Use when Codex needs to add, update, refactor, publish, or organize Exponential Jyotish Companion documentation in the docs repo. Applies to PRDs, architecture docs, schema specs, ADRs, prompts, evals, domain knowledge, artifact-registry entries, context graph metadata, MkDocs navigation, exports, verification, commits, pushes, and GitHub Pages publishing. Prefer surgical edits to existing canonical docs over creating duplicate content.
---

# Jyotish Docs Entry

Use this skill for documentation work in the Exponential Jyotish Companion docs repository.

## Project Ground Rules

- Treat Git as the source of truth.
- Preserve the enterprise domains: `handbook`, `product`, `architecture`, `engineering`, `ai`, `governance`, `operations`, `domain-knowledge`, and `archive`.
- Prefer surgical edits to existing canonical files. Create a new artifact only when it has a distinct owner, lifecycle, or graph role.
- Keep runtime user context out of the docs repo.
- Keep raw source inputs immutable under `docs/archive/`.
- Keep Drive exports as derived copies.
- Preserve core product decisions: Manual memory default, model router, provider-neutral embeddings, reviewed-not-positive-only Jyotish RAG, generic analysis runs, responsible prediction evaluator, and Postgres-first context graph.

## Required Reading

Before editing, read only the relevant files:

- Always inspect `docs/handbook/knowledge-map.md`, `docs/handbook/knowledge-architecture.md`, and `docs/handbook/artifact-registry.yaml`.
- For placement or metadata questions, read `docs/handbook/metadata-standard.md` and `docs/handbook/relation-types.md`.
- For architecture/context changes, read `docs/architecture/patterns/context-graph-knowledge-system/README.md`.
- For durable decisions, read `docs/governance/decisions/adr/index.md` and the relevant ADRs.
- For product behavior, read `docs/product/requirements/prd-v0.2.md`.
- For a compact project reminder, read `references/project-context.md`.

## Workflow

1. Classify the incoming material:
   - product intent -> `docs/product/`
   - system shape or reusable pattern -> `docs/architecture/`
   - schema or implementation spec -> `docs/engineering/`
   - prompt/eval/model behavior -> `docs/ai/`
   - durable decision or standard -> `docs/governance/`
   - runbook/audit/publishing -> `docs/operations/`
   - reviewed Jyotish doctrine -> `docs/domain-knowledge/`
   - raw source/provenance -> `docs/archive/`
2. Search for an existing canonical artifact before adding a new one.
3. Make the smallest coherent edit.
4. Add or update stable graph metadata in `docs/handbook/artifact-registry.yaml` for durable artifacts.
5. Use only relation names from `docs/handbook/relation-types.md`.
6. Update `docs/handbook/version-manifest.md` for source-of-truth artifacts.
7. Update section indexes and `mkdocs.yml` when humans need navigation.
8. Refresh export copies when the edited artifact has an export path.
9. Update `scripts/verify_artifacts.sh` when a new required durable artifact should be guarded.
10. Run `git diff --check`, `scripts/verify_artifacts.sh`, and `mkdocs build --strict`.
11. Commit to `dev`, push `dev`, then push `dev:main` when publishing is requested or expected.
12. Check GitHub Actions and public Pages URLs after publishing.

## Metadata Rules

- Give durable artifacts a stable ID.
- Use `project_knowledge` for repo docs, `domain_knowledge` for reviewed Jyotish material, and never store `runtime_user_context` in docs.
- Record relationships in `artifact-registry.yaml`, not as scattered prose.
- Add a new relation type before using it.
- Do not duplicate long explanations across files. Link instead.

## Safety Rules

- Do not turn reviewed Jyotish retrieval into "positive only" retrieval.
- Do not add user PII, user memories, chart facts for real users, or private runtime traces to docs.
- Do not hard-code embedding dimensions or provider choices.
- Do not create plaintext search/index recommendations for sensitive user data unless the encryption-versus-searchability decision is explicitly accepted.
- Do not create a new top-level domain unless it has a clear owner and lifecycle.

## Output Expectations

When finished, report:

- files changed;
- where the new or edited material sits;
- verification commands run;
- commit hash and public link when pushed/published;
- any open decisions.

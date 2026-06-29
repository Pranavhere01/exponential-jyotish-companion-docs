# Contribution Guide

Status: Accepted v0.1  
Date: 2026-06-29

This repository follows docs-as-code practices: reviewable Markdown, explicit ownership, stable paths, and generated exports.

## Add Or Change A Document

1. Pick the owning domain from [Knowledge Architecture](knowledge-architecture.md).
2. Add or edit the canonical file under `docs/`.
3. Use title, status, date, and owner/context for durable artifacts.
4. Add or update links from the relevant section `index.md`.
5. Update [Version Manifest](version-manifest.md) if the artifact is durable.
6. Refresh export copies when the artifact has a Drive/share export.
7. Run `scripts/verify_artifacts.sh`.
8. Build the site with `mkdocs build --strict`.
9. Commit to `dev`; promote to `main` after review.

## Structure

```text
docs/
  handbook/       # Documentation system, contribution rules, manifests
  product/        # Strategy, requirements, PM-facing guides
  architecture/   # System design and platform direction
  engineering/    # Data model, schema, implementation specs
  ai/             # Prompts, evaluation, model quality
  governance/     # ADRs, standards, source-of-truth policy
  operations/     # Publishing, repository workflows, audits
  archive/        # Immutable original source materials
exports/          # Derived sharing copies
```

## Quality Bar

- Prefer one canonical file over duplicated explanations.
- Use links for cross-domain context.
- Keep raw source inputs immutable.
- Do not bury current source-of-truth material in archive folders.
- Do not introduce a new top-level domain unless it has a distinct owner and lifecycle.

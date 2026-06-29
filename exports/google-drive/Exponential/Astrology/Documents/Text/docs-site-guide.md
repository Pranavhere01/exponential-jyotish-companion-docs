# Docs Site Guide

Status: Draft v0.1  
Date: 2026-06-29

## Purpose

This repository is the internal documentation and resources hub for Jyotish Companion. It is Markdown-first so product, architecture, schema, prompt, eval, SOP, and decision context can be reviewed through Git and published as a readable site.

## How to add a new document

1. Add a Markdown file under the right `docs/` shelf.
2. Use a clear lowercase filename, such as `memory-retrieval-plan.md`.
3. Start with a title, status, date, and owner/context when useful.
4. Link the new file from the section index. Link it from `docs/index.md` only if it is a durable entry point.
5. If it is a durable artifact, add it to [Version Manifest](version-manifest.md).
6. If it needs a Drive export, copy it into `exports/google-drive/Exponential/Astrology/Documents/Text/`.
7. Run `scripts/verify_artifacts.sh`.
8. Commit on `dev`, then merge to `main` through a PR.

## Structure

```text
docs/
  index.md                    # Site home
  00-start-here/              # Orientation, map, manifest, contribution guide
  10-product/                 # Product strategy, PRD, PM-readable guides
  20-architecture/            # System design and technical architecture
  30-data-and-schema/         # Schema SQL, data model specs, migration/change specs
  40-ai-quality/              # Prompts, eval rubrics, fixtures
  50-operations/              # SOPs, repo setup, publishing, audits
  60-decisions/               # ADRs and durable decisions
  90-archive/                 # Original source inputs and provenance
exports/google-drive/         # Derived sharing/export package, not source of truth
```

## Publishing

The site is configured with `mkdocs.yml` and a GitHub Pages workflow. The intended flow is:

- write and review on `dev`;
- merge to `main`;
- GitHub Actions builds and publishes the Pages site from `main`.

If private GitHub Pages is unavailable on the current GitHub plan, keep the repository private and use the generated site artifact or a free private-docs alternative such as Cloudflare Pages with access controls.

## Best practices

- Keep decisions in Markdown, SQL, JSON, YAML, CSV, or JSONL.
- Avoid making screenshots, PDFs, or slides the only copy of a decision.
- Use ADRs for durable architecture, safety, provider, schema, or model-behavior choices.
- Prefer links over duplication.
- Keep generated outputs versioned instead of overwritten in place.
- Keep raw source inputs in `docs/90-archive/` and edit canonical docs elsewhere.

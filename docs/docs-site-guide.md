# Docs Site Guide

Status: Draft v0.1  
Date: 2026-06-29

## Purpose

This repository is the internal documentation and resources hub for Jyotish Companion. It is Markdown-first so product, architecture, schema, prompt, eval, SOP, and decision context can be reviewed through Git and published as a readable site.

## How to add a new document

1. Add a Markdown file under `docs/`.
2. Use a clear lowercase filename, such as `memory-retrieval-plan.md`.
3. Start with a title, status, date, and owner/context when useful.
4. Link the new file from `docs/index.md` if it is a start-here or durable reference.
5. If it is a durable artifact, add it to `docs/version-manifest.md`.
6. If it needs a Drive export, copy it into `exports/google-drive/Exponential/Astrology/Documents/Text/`.
7. Run `scripts/verify_artifacts.sh`.
8. Commit on `dev`, then merge to `main` through a PR.

## Structure

```text
docs/
  index.md                    # Site home
  prd_*.md                    # Product requirements
  system_design_*.md          # Architecture and system design
  schema-*.md                 # Schema specs and implementation plans
  adr/                        # Architecture decision records
  sop/                        # Operating procedures
prompts/                      # Versioned prompt artifacts
evals/                        # Rubrics and fixtures
db/                           # Canonical schema SQL
exports/google-drive/         # Derived sharing/export package
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

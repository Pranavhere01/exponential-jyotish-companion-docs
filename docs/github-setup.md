# GitHub Setup

Status: Draft  
Date: 2026-06-29

## Goal

Make this repository the canonical source of truth for Exponential Jyotish Companion documentation, schema, prompts, and evals.

## Repository split

Documentation/resources repository:

```text
exponential-jyotish-companion-docs
```

Main platform repository:

```text
exponential-jyotish-companion-platform
```

Suggested visibility:

```text
private
```

Suggested default branch:

```text
main
```

Branch policy:

- `main`: stable baseline, protected, merged into intentionally.
- `dev`: working branch where current documentation/schema changes live.

## Initial publish commands

Run these after GitHub authentication is working for the docs repo:

```bash
scripts/publish_to_github_after_auth.sh <org-or-user>/exponential-jyotish-companion-docs
```

To invite a collaborator with push access during publish:

```bash
scripts/publish_to_github_after_auth.sh <org-or-user>/exponential-jyotish-companion-docs <github-username>
```

The script creates the repo as private if needed, pushes `main` and `dev`, keeps `main` as the default branch, and makes `dev` the branch for active work.

## Required repo settings

- Require pull requests for `main`.
- Use `dev` for active work and branch off it for focused changes when needed.
- Require at least one approving review before merge.
- Use the PR template in `.github/pull_request_template.md`.
- Store docs, schema, prompts, and eval changes in Git before exporting to Drive.
- Keep Google Drive as an export/shared-reading layer, not as the canonical source.

## Current blocker observed locally

`gh` is installed, but the current token is invalid. Re-authenticate before publishing:

```bash
gh auth login -h github.com
```

Then verify:

```bash
gh auth status
```

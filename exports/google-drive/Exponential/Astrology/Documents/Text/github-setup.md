# GitHub Setup

Status: Draft  
Date: 2026-06-29

## Goal

Make this repository the canonical source of truth for Exponential Jyotish Companion documentation, schema, prompts, and evals.

## Recommended repository

Suggested repository name:

```text
exponential-jyotish-companion
```

Suggested visibility:

```text
private
```

Suggested default branch:

```text
main
```

## Initial publish commands

Run these after GitHub authentication is working:

```bash
git remote add origin git@github.com:<org-or-user>/exponential-jyotish-companion.git
git push -u origin main
```

If creating the repo with GitHub CLI:

```bash
gh repo create <org-or-user>/exponential-jyotish-companion --private --source . --remote origin --push
```

## Required repo settings

- Require pull requests for `main`.
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


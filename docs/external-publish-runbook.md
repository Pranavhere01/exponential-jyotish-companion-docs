# External Publish Runbook

Status: ready after auth/access  
Date: 2026-06-29

## Current local state

The local repository is committed on `main`.

Latest commits:

- `996f407 Add Drive export package and completion audit`
- `38b5221 Initialize Jyotish Companion docs base`

## Verify local artifacts

```bash
scripts/verify_artifacts.sh
```

## Publish to GitHub

The current blocker is GitHub auth: `gh auth status` reports an invalid token for `Pranavhere01`.

After re-authentication:

```bash
gh auth login -h github.com
```

Create the GitHub repository if it does not already exist:

```bash
gh repo create <owner>/exponential-jyotish-companion --private --source . --remote origin --push
```

If the repo already exists:

```bash
scripts/publish_to_github_after_auth.sh <owner>/exponential-jyotish-companion
```

## Publish to Google Drive

The intended folder structure is:

```text
Exponential/
  Astrology/
    Documents/
      Html/
      Text/
```

Local export package:

```text
exports/google-drive/Exponential/Astrology/Documents/
```

Upload after the connector can see the shared Drive folder:

- `exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html` to `Html`
- all files in `exports/google-drive/Exponential/Astrology/Documents/Text/` to `Text`

Current Drive blocker: the connector cannot see the screenshot folder IDs and returns `404` for the `Exponential` folder ID.


# External Publish Runbook

Status: ready after auth/access  
Date: 2026-06-29

## Current local state

The local repository is committed, with the latest schema/documentation work on branch
`feat/schema-v0.3`. Use this command to see the latest local commits:

```bash
git log --oneline --max-count=5
```

## Verify local artifacts

```bash
scripts/verify_artifacts.sh
```

After the repository is pushed, GitHub Actions will run the same check through `.github/workflows/verify-artifacts.yml`.

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

The intended folder structure visible in the screenshots is:

```text
Exponential/
  Astrology/
    Documents/
      Html/
      Text/
```

Browser-visible folder IDs from the screenshots:

| Folder | Browser URL ID | Notes |
| --- | --- | --- |
| `Exponential` | `1WwsQmCiCqZxCctNEfqdnGwKJjtC2ChWf` | Shared with me; owner shown as `plaggayi`. |
| `Astrology` | `1by8WT9dQ_jgxEd5irK5vy3A4fwYyZBzI` | Child of `Exponential`; owner shown as `plaggayi`. |
| `Documents` | `1uLn5DvIVTMw2yWJ83xM8TEx_a68wqwwb` | Child of `Astrology`; contains `Html` and `Text`. |

Local export package:

```text
exports/google-drive/Exponential/Astrology/Documents/
```

Upload after the connector can see the shared Drive folder:

- `exports/google-drive/Exponential/Astrology/Documents/Html/pm_first_principles_guide.html` to `Html`
- all files in `exports/google-drive/Exponential/Astrology/Documents/Text/` to `Text`

Current Drive blocker:

- The connector cannot see the screenshot folder IDs.
- Live re-check on 2026-06-29:
  - `Exponential` folder ID `1WwsQmCiCqZxCctNEfqdnGwKJjtC2ChWf` returns `404`.
  - `Astrology` folder ID `1by8WT9dQ_jgxEd5irK5vy3A4fwYyZBzI` returns `404`.
  - `Documents` folder ID `1uLn5DvIVTMw2yWJ83xM8TEx_a68wqwwb` returns `400`.
- Drive search for accessible folders named `Exponential`, `Astrology`, and `Documents` returned no matching folders.
- The connector can see the individual doc `System Design & Technical Architecture — Personal AI Astrologer`, but its parent folder is not exposed.
- The Google Doc URL from the objective resolves to `Fundamentals - ML and MLops`, so do not treat that URL as the Jyotish PRD without user confirmation.

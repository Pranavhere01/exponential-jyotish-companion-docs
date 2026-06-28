#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/publish_to_github_after_auth.sh <github-repo>

Example:
  scripts/publish_to_github_after_auth.sh Pranavhere01/exponential-jyotish-companion

Before running:
  gh auth login -h github.com

What this does:
  1. Verifies GitHub CLI auth.
  2. Adds origin if missing.
  3. Pushes main to the GitHub repo.

It does not create the GitHub repo. Create the repo first, or run:
  gh repo create <owner>/<repo> --private --source . --remote origin --push
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

repo="${1:-}"
if [[ -z "$repo" ]]; then
  usage
  exit 2
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not authenticated. Run: gh auth login -h github.com" >&2
  exit 1
fi

if [[ -n "$(git status --short)" ]]; then
  echo "Working tree is not clean. Commit or stash changes before publishing." >&2
  git status --short >&2
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin "git@github.com:${repo}.git"
fi

git push -u origin main


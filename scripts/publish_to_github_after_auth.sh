#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/publish_to_github_after_auth.sh <github-repo> [collaborator-username]

Example:
  scripts/publish_to_github_after_auth.sh Pranavhere01/exponential-jyotish-companion
  scripts/publish_to_github_after_auth.sh Pranavhere01/exponential-jyotish-companion teammate-github-user

Before running:
  gh auth login -h github.com

What this does:
  1. Verifies GitHub CLI auth.
  2. Creates the private GitHub repo if it does not already exist.
  3. Adds origin if missing.
  4. Pushes clean main and working dev.
  5. Optionally grants push access to one collaborator.

Branch policy:
  main = stable baseline
  dev  = working branch with current documentation/schema changes
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

repo="${1:-}"
collaborator="${2:-}"
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

for branch in main dev; do
  if ! git rev-parse --verify "$branch" >/dev/null 2>&1; then
    echo "Missing required local branch: $branch" >&2
    exit 1
  fi
done

if ! gh repo view "$repo" >/dev/null 2>&1; then
  gh repo create "$repo" --private --source . --remote origin
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin "git@github.com:${repo}.git"
fi

git push origin main:main
git push -u origin dev:dev

gh repo edit "$repo" \
  --visibility private \
  --accept-visibility-change-consequences \
  --default-branch main

if [[ -n "$collaborator" ]]; then
  gh api \
    -X PUT \
    "repos/${repo}/collaborators/${collaborator}" \
    -f permission=push >/dev/null
  echo "Invited collaborator: ${collaborator}"
fi

echo "Published private repo: ${repo}"
echo "Pushed branches: main, dev"

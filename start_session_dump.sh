#!/usr/bin/env bash
set -euo pipefail

echo "FOCUSPILOT_START_SESSION_DUMP v1"
echo "DATE: $(date -Iseconds)"
echo "REPO: $(basename "$(git rev-parse --show-toplevel)")"
echo "BRANCH: $(git rev-parse --abbrev-ref HEAD)"
echo "HEAD: $(git rev-parse HEAD)"
echo

echo "WORKTREE_DIRTY:"
if [ -n "$(git status --porcelain=v1)" ]; then
  echo "YES"
else
  echo "NO"
fi
echo

echo "UNCOMMITTED_FILES:"
git status --porcelain=v1 || true
echo

echo "LAST_COMMITS_10:"
git log -n 10 --oneline --decorate || true
echo

echo "OPEN_STASHES:"
git stash list || true
echo

echo "REMOTE_STATUS:"
git status -sb || true
echo

echo "END_START_DUMP"

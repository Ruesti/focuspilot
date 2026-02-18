#!/usr/bin/env bash
set -euo pipefail

echo "FOCUSPILOT_SESSION_DUMP v1"
echo "DATE: $(date -Iseconds)"
echo "REPO: $(basename "$(git rev-parse --show-toplevel)")"
echo "BRANCH: $(git rev-parse --abbrev-ref HEAD)"
echo "HEAD: $(git rev-parse HEAD)"
echo

echo "STATUS_PORCELAIN:"
# zeigt nur Änderungen, gut maschinenlesbar
git status --porcelain=v1 || true
echo

echo "DIFFSTAT_WORKTREE:"
# Statistik der uncommitted Änderungen
git diff --stat || true
echo

echo "DIFFSTAT_CACHED:"
# Statistik der staged Änderungen
git diff --cached --stat || true
echo

echo "LAST_COMMITS_15:"
git log -n 15 --oneline --decorate || true
echo

echo "REMOTE:"
git remote -v || true
echo

echo "END_DUMP"

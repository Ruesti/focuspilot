@'
$ErrorActionPreference = "Stop"

Write-Output "FOCUSPILOT_START_SESSION_DUMP v1"
Write-Output ("DATE: " + (Get-Date).ToString("o"))

try {
  $top = git rev-parse --show-toplevel
  $repo = Split-Path $top -Leaf
  Write-Output ("REPO: " + $repo)
} catch {
  Write-Output "REPO: <unknown>"
}

Write-Output ("BRANCH: " + (git rev-parse --abbrev-ref HEAD))
Write-Output ("HEAD: " + (git rev-parse HEAD))
Write-Output ""

$dirty = git status --porcelain
if ($dirty) {
  Write-Output "WORKTREE_DIRTY: YES"
} else {
  Write-Output "WORKTREE_DIRTY: NO"
}
Write-Output ""

Write-Output "UNCOMMITTED_FILES:"
git status --porcelain
Write-Output ""

Write-Output "LAST_COMMITS_10:"
git log -n 10 --oneline --decorate
Write-Output ""

Write-Output "OPEN_STASHES:"
git stash list
Write-Output ""

Write-Output "REMOTE_STATUS:"
git status -sb
Write-Output ""

Write-Output "END_START_DUMP"
'@ | Set-Content -Encoding UTF8 start_session_dump.ps1

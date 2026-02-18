@'
$ErrorActionPreference = "Stop"

Write-Output "FOCUSPILOT_SESSION_DUMP v1"
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

Write-Output "STATUS_PORCELAIN:"
git status --porcelain=v1
Write-Output ""

Write-Output "DIFFSTAT_WORKTREE:"
git diff --stat
Write-Output ""

Write-Output "DIFFSTAT_CACHED:"
git diff --cached --stat
Write-Output ""

Write-Output "LAST_COMMITS_15:"
git log -n 15 --oneline --decorate
Write-Output ""

Write-Output "REMOTE:"
git remote -v
Write-Output ""

Write-Output "END_DUMP"
'@ | Set-Content -Encoding UTF8 end_session_dump.ps1

param()

$candidates = @()

if ($env:WECHAT_NODE_EXE) {
  $candidates += $env:WECHAT_NODE_EXE
}

try {
  $whereNode = & where.exe node 2>$null
  if ($whereNode) {
    $candidates += ($whereNode -split "`r?`n" | Where-Object { $_ })
  }
} catch {}

$candidates += @(
  $(if ($env:NVM_SYMLINK) { Join-Path $env:NVM_SYMLINK "node.exe" }),
  $(if ($env:NVM_HOME -and $env:NVM_CURRENT) { Join-Path $env:NVM_HOME ($env:NVM_CURRENT + "\node.exe") }),
  "C:\Program Files\nodejs\node.exe"
)

try {
  $cli = & (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "find-wechat-devtools.ps1") 2>$null
  if ($cli) {
    $devtoolsRoot = Split-Path -Parent $cli
    $candidates += @(
      (Join-Path $devtoolsRoot "node.exe"),
      (Join-Path $devtoolsRoot "node-18.exe")
    )
  }
} catch {}

$found = $candidates | Select-Object -Unique | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if ($found) {
  Write-Output $found
  exit 0
}

Write-Error "No usable Node runtime was found. If you use nvm for Windows, make sure NVM_SYMLINK points to the active node installation."
exit 1

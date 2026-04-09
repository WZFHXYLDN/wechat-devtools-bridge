param()

$candidates = @()

try {
  $whereNode = & where.exe node 2>$null
  if ($whereNode) {
    $candidates += ($whereNode -split "`r?`n" | Where-Object { $_ })
  }
} catch {}

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

Write-Error "No usable Node runtime was found."
exit 1

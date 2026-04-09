param()

$candidates = @()

if ($env:WECHAT_NPX_CMD) {
  $candidates += $env:WECHAT_NPX_CMD
}

try {
  $whereNpx = & where.exe npx 2>$null
  if ($whereNpx) {
    $candidates += ($whereNpx -split "`r?`n" | Where-Object { $_ })
  }
} catch {}

$candidates += @(
  $(if ($env:NVM_SYMLINK) { Join-Path $env:NVM_SYMLINK "npx.cmd" }),
  $(if ($env:NVM_HOME -and $env:NVM_CURRENT) { Join-Path $env:NVM_HOME ($env:NVM_CURRENT + "\npx.cmd") }),
  "C:\Program Files\nodejs\npx.cmd",
  "$env:APPDATA\npm\npx.cmd"
)

$found = $candidates | Select-Object -Unique | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if ($found) {
  Write-Output $found
  exit 0
}

Write-Error "No usable npx command was found. If you use nvm for Windows, make sure NVM_SYMLINK points to the active node installation."
exit 1

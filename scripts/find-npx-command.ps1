param()

$candidates = @()

try {
  $whereNpx = & where.exe npx 2>$null
  if ($whereNpx) {
    $candidates += ($whereNpx -split "`r?`n" | Where-Object { $_ })
  }
} catch {}

$candidates += @(
  "C:\Program Files\nodejs\npx.cmd",
  "$env:APPDATA\npm\npx.cmd"
)

$found = $candidates | Select-Object -Unique | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if ($found) {
  Write-Output $found
  exit 0
}

exit 1

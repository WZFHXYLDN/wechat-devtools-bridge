param()

$searchRoots = @(
  "C:\Program Files\Tencent",
  "C:\Program Files (x86)\Tencent",
  "$env:LOCALAPPDATA\Tencent",
  "$env:LOCALAPPDATA"
) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }

$candidates = @()

foreach ($root in $searchRoots) {
  try {
    $dirs = Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue |
      Where-Object { $_.Name -like '*开发者工具*' -or $_.Name -like '*web*' }
    foreach ($dir in $dirs) {
      $candidates += Join-Path $dir.FullName 'cli.bat'
    }
  } catch {}
}

$candidates += @(
  "C:\Program Files (x86)\Tencent\微信web开发者工具\cli.bat",
  "C:\Program Files\Tencent\微信web开发者工具\cli.bat",
  "C:\Program Files (x86)\Tencent\微信开发者工具\cli.bat",
  "C:\Program Files\Tencent\微信开发者工具\cli.bat"
)

$found = $candidates | Select-Object -Unique | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if ($found) {
  Write-Output $found
  exit 0
}

Write-Error "WeChat DevTools CLI was not found in common Windows locations."
exit 1

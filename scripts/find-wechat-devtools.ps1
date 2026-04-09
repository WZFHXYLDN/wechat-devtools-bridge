param()

$candidates = @(
  "C:\Program Files\Tencent\微信web开发者工具\cli.bat",
  "C:\Program Files (x86)\Tencent\微信web开发者工具\cli.bat",
  "C:\Program Files\Tencent\微信开发者工具\cli.bat",
  "C:\Program Files (x86)\Tencent\微信开发者工具\cli.bat",
  "$env:LOCALAPPDATA\Tencent\微信开发者工具\cli.bat",
  "$env:LOCALAPPDATA\微信开发者工具\cli.bat"
) | Where-Object { $_ }

$found = $candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if ($found) {
  Write-Output $found
  exit 0
}

Write-Error "WeChat DevTools CLI was not found in common Windows locations."
exit 1

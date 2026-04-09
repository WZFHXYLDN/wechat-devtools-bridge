param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Args
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$checker = Join-Path $scriptRoot "check-prereqs.ps1"
$findNpx = Join-Path $scriptRoot "find-npx-command.ps1"
$findCli = Join-Path $scriptRoot "find-wechat-devtools.ps1"

& $checker | Out-Null
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

if (-not $env:WECHAT_DEVTOOLS_CLI) {
  $env:WECHAT_DEVTOOLS_CLI = & $findCli
}

$npx = ""
try { $npx = & $findNpx 2>$null } catch { $npx = "" }
if ($npx -isnot [string]) { $npx = "" }

if ($npx) {
  & $npx -y weapp-ide-cli @Args
  exit $LASTEXITCODE
}

& $env:WECHAT_DEVTOOLS_CLI @Args
exit $LASTEXITCODE

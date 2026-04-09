param(
  [string]$ProjectPath = $env:WECHAT_PROJECT_PATH
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$invoker = Join-Path $scriptRoot "invoke-weapp-cli.ps1"

if (-not $ProjectPath) {
  $ProjectPath = (Resolve-Path (Join-Path $scriptRoot "..\..\..")).Path
} elseif (Test-Path -LiteralPath $ProjectPath) {
  $ProjectPath = (Resolve-Path $ProjectPath).Path
}

& $invoker open --project $ProjectPath
exit $LASTEXITCODE

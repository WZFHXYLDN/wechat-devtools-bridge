param()

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$checker = Join-Path $scriptRoot "check-prereqs.ps1"
$finder = Join-Path $scriptRoot "find-wechat-devtools.ps1"

& $checker | Out-Null
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

if (-not $env:WECHAT_DEVTOOLS_CLI) {
  $env:WECHAT_DEVTOOLS_CLI = & $finder
}

if (-not $env:WECHAT_WS_ENDPOINT) {
  $env:WECHAT_WS_ENDPOINT = "ws://127.0.0.1:9420"
}

if (-not $env:WECHAT_PROJECT_PATH) {
  $env:WECHAT_PROJECT_PATH = (Resolve-Path (Join-Path $scriptRoot "..\..\..")).Path
}

& npx -y weapp-devtools-mcp

param()

$node = Get-Command node -ErrorAction SilentlyContinue
$npx = Get-Command npx -ErrorAction SilentlyContinue
$cli = $env:WECHAT_DEVTOOLS_CLI

if (-not $cli) {
  $scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
  $finder = Join-Path $scriptRoot "find-wechat-devtools.ps1"
  try {
    $cli = & $finder
  } catch {
    $cli = ""
  }
}

$report = [ordered]@{
  node = if ($node) { $node.Source } else { "" }
  npx = if ($npx) { $npx.Source } else { "" }
  wechatDevtoolsCli = $cli
  wsEndpoint = if ($env:WECHAT_WS_ENDPOINT) { $env:WECHAT_WS_ENDPOINT } else { "ws://127.0.0.1:9420" }
}

$report | ConvertTo-Json -Depth 5

if (-not $node -or -not $npx) {
  Write-Error "Node.js and npx are required."
  exit 1
}

if (-not $cli) {
  Write-Error "WeChat DevTools CLI was not found. Set WECHAT_DEVTOOLS_CLI first."
  exit 1
}

exit 0

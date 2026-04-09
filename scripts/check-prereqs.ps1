param()

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$findNode = Join-Path $scriptRoot "find-node-runtime.ps1"
$findNpx = Join-Path $scriptRoot "find-npx-command.ps1"
$finder = Join-Path $scriptRoot "find-wechat-devtools.ps1"

$node = ""
$npx = ""
$cli = $env:WECHAT_DEVTOOLS_CLI

try { $node = & $findNode 2>$null } catch { $node = "" }
try { $npx = & $findNpx 2>$null } catch { $npx = "" }
if ($node -isnot [string]) { $node = "" }
if ($npx -isnot [string]) { $npx = "" }

if (-not $cli) {
  try { $cli = & $finder 2>$null } catch { $cli = "" }
  if ($cli -isnot [string]) { $cli = "" }
}

$report = [ordered]@{
  node = $node
  npx = $npx
  wechatDevtoolsCli = $cli
  projectPath = if ($env:WECHAT_PROJECT_PATH) { $env:WECHAT_PROJECT_PATH } else { (Resolve-Path (Join-Path $scriptRoot "..\..\..")).Path }
  wsEndpoint = if ($env:WECHAT_WS_ENDPOINT) { $env:WECHAT_WS_ENDPOINT } else { "ws://127.0.0.1:9420" }
  mcpPackage = if ($env:WECHAT_MCP_NPX_PACKAGE) { $env:WECHAT_MCP_NPX_PACKAGE } else { "" }
}

$report | ConvertTo-Json -Depth 5

if (-not $node) {
  Write-Error "A usable Node runtime was not found."
  exit 1
}

if (-not $cli) {
  Write-Error "WeChat DevTools CLI was not found. Set WECHAT_DEVTOOLS_CLI first."
  exit 1
}

exit 0

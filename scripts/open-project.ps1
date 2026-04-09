param(
  [string]$ProjectPath = $env:WECHAT_PROJECT_PATH
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$invoker = Join-Path $scriptRoot "invoke-weapp-cli.ps1"
$findCli = Join-Path $scriptRoot "find-wechat-devtools.ps1"

if (-not $ProjectPath) {
  $ProjectPath = (Resolve-Path (Join-Path $scriptRoot "..\..\..")).Path
} elseif (Test-Path -LiteralPath $ProjectPath) {
  $ProjectPath = (Resolve-Path $ProjectPath).Path
}

$devtoolsRunning = Get-Process -ErrorAction SilentlyContinue | Where-Object {
  $_.ProcessName -like 'wechatdevtools*'
} | Select-Object -First 1

if ($devtoolsRunning) {
  Write-Output "WeChat DevTools is already running."
  exit 0
}

if (-not $env:WECHAT_DEVTOOLS_CLI) {
  try {
    $env:WECHAT_DEVTOOLS_CLI = & $findCli 2>$null
  } catch {
    $env:WECHAT_DEVTOOLS_CLI = ""
  }
}

if ($env:WECHAT_DEVTOOLS_CLI) {
  $devtoolsRoot = Split-Path -Parent $env:WECHAT_DEVTOOLS_CLI
  $guiExe = Join-Path $devtoolsRoot "wechatdevtools.exe"
  if (Test-Path -LiteralPath $guiExe) {
    Start-Process -FilePath $guiExe | Out-Null
  }
}

& $invoker open --project $ProjectPath
exit 0

param(
  [Parameter(Mandatory = $true)]
  [string]$Version,
  [Parameter(Mandatory = $true)]
  [string]$Desc,
  [string]$ProjectPath = $env:WECHAT_PROJECT_PATH,
  [string]$Robot = "",
  [string]$PrivateKeyPath = "",
  [string]$AppId = ""
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$invoker = Join-Path $scriptRoot "invoke-weapp-cli.ps1"

if (-not $ProjectPath) {
  $ProjectPath = (Resolve-Path (Join-Path $scriptRoot "..\..\..")).Path
} elseif (Test-Path -LiteralPath $ProjectPath) {
  $ProjectPath = (Resolve-Path $ProjectPath).Path
}

$args = @("upload", "--project", $ProjectPath, "--version", $Version, "--desc", $Desc)
if ($Robot) {
  $args += @("--robot", $Robot)
}
if ($PrivateKeyPath) {
  $args += @("--private-key-path", $PrivateKeyPath)
}
if ($AppId) {
  $args += @("--appid", $AppId)
}

& $invoker @args
exit $LASTEXITCODE

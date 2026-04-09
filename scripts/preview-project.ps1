param(
  [string]$ProjectPath = $env:WECHAT_PROJECT_PATH,
  [string]$QrFormat = "terminal",
  [string]$Output = ""
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$invoker = Join-Path $scriptRoot "invoke-weapp-cli.ps1"

if (-not $ProjectPath) {
  $ProjectPath = (Resolve-Path (Join-Path $scriptRoot "..\..\..")).Path
} elseif (Test-Path -LiteralPath $ProjectPath) {
  $ProjectPath = (Resolve-Path $ProjectPath).Path
}

$args = @("preview", "--project", $ProjectPath, "--qr-format", $QrFormat)
if ($Output) {
  $args += @("--output", $Output)
}

& $invoker @args
exit $LASTEXITCODE

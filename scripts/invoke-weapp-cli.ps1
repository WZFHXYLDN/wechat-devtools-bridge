param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Args
)

$checker = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "check-prereqs.ps1"
& $checker | Out-Null
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& npx -y weapp-ide-cli @Args
exit $LASTEXITCODE

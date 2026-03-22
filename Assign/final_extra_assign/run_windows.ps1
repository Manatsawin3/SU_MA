# Run Flutter for Windows when the project lives under a path that breaks the toolchain
# (non-ASCII segments like OneDrive\เอกสาร, or SUBST to "X:\" which breaks PROJECT_DIR quoting in CMake).
$ErrorActionPreference = 'Stop'
$target = (Resolve-Path -LiteralPath $PSScriptRoot).ProviderPath

$sha = [System.Security.Cryptography.SHA256]::Create().ComputeHash(
  [Text.Encoding]::UTF8.GetBytes($target))
$hash = [BitConverter]::ToString($sha).Replace('-', '').Substring(0, 12).ToLowerInvariant()
$junctionRoot = Join-Path $env:LOCALAPPDATA 'FlutterPathJunctions'
$junction = Join-Path $junctionRoot "final_extra_assign_$hash"

if (-not (Test-Path -LiteralPath $junctionRoot)) {
  New-Item -ItemType Directory -Path $junctionRoot | Out-Null
}

if (-not (Test-Path -LiteralPath $junction)) {
  New-Item -ItemType Junction -Path $junction -Target $target | Out-Null
} else {
  $link = Get-Item -LiteralPath $junction
  $current = if ($link.Target) { (Resolve-Path -LiteralPath $link.Target[0]).ProviderPath } else { $null }
  if ($current -and $current -ne $target) {
    Write-Error "Junction already exists at $junction but points elsewhere. Remove that folder and retry."
  }
}

Push-Location $junction
try {
  if ($args.Count -eq 0) {
    flutter run -d windows
  } else {
    flutter @args
  }
} finally {
  Pop-Location
}

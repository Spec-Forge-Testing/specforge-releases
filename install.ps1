# Installs Spec Forge for the current user on Windows. No administrator rights needed.
#
#   powershell -c "irm https://raw.githubusercontent.com/Spec-Forge-Testing/specforge-releases/master/install.ps1 | iex"
#
# Running it again updates to the latest release. $env:SPECFORGE_VERSION = "v0.1.0" pins one.
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"  # Invoke-WebRequest is many times slower with it on

$Repo = "Spec-Forge-Testing/specforge-releases"
$InstallDir = Join-Path $env:LOCALAPPDATA "specforge"

if (-not [Environment]::Is64BitOperatingSystem) {
    throw "specforge: only 64-bit Windows is published"
}

$Version = $env:SPECFORGE_VERSION
if (-not $Version) {
    $Version = (Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest").tag_name
}

$Archive = "specforge-$Version-windows-x86_64.zip"
$Tmp = Join-Path ([IO.Path]::GetTempPath()) ([Guid]::NewGuid())
New-Item -ItemType Directory -Path $Tmp | Out-Null

try {
    Write-Host "Downloading Spec Forge $Version..."
    Invoke-WebRequest "https://github.com/$Repo/releases/download/$Version/$Archive" -OutFile (Join-Path $Tmp $Archive)
    Expand-Archive (Join-Path $Tmp $Archive) -DestinationPath $Tmp

    if (Test-Path $InstallDir) { Remove-Item $InstallDir -Recurse -Force }
    Move-Item (Join-Path $Tmp "specforge") $InstallDir
}
finally {
    Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue
}

$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (($UserPath -split ";") -notcontains $InstallDir) {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
    Write-Host "Added $InstallDir to your PATH: open a new terminal to use it."
}

Write-Host "Spec Forge $Version installed in $InstallDir"
Write-Host "Run 'specforge' inside your API's folder to start."

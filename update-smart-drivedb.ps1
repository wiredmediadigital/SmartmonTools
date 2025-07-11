<#
.SYNOPSIS
    Downloads the latest smartmontools drive database (drivedb.h) and updates the local copy used by smartctl.

.DESCRIPTION
    This script downloads the latest version of drivedb.h from the official smartmontools GitHub repo and replaces the existing drivedb.h file used by smartctl.exe. This ensures smartctl is using the most up-to-date drive definitions.

.NOTES
    Requires smartctl to be installed and accessible (either in the same directory or in PATH).
    Should be run with administrative privileges.

.LINK
    https://github.com/mirror/smartmontools/blob/master/drivedb.h
#>

$ErrorActionPreference = 'Stop'

# Define where smartctl is installed or located (adjust if needed)
$SmartCtlPath = "$env:ProgramData\SmartmonTools\bin\smartctl.exe"
$DriveDBPath  = "$env:ProgramData\SmartmonTools\bin\drivedb.h"
$TempDBPath   = "$env:TEMP\drivedb.h"

# Download the latest drive database from smartmontools GitHub mirror
$DownloadURL = "https://raw.githubusercontent.com/mirror/smartmontools/master/drivedb.h"
Write-Output "Downloading latest drive database from $DownloadURL..."
Invoke-WebRequest -Uri $DownloadURL -OutFile $TempDBPath

# Check if smartctl exists
if (-not (Test-Path $SmartCtlPath)) {
    Write-Error "smartctl.exe not found at $SmartCtlPath. Ensure Smartmontools is installed."
    exit 1
}

# Replace the existing drivedb.h file
Write-Output "Replacing old drive database at $DriveDBPath..."
Copy-Item -Path $TempDBPath -Destination $DriveDBPath -Force

# Reload the DB (optional: verifies update worked)
Write-Output "Verifying drive database update..."
& $SmartCtlPath --version

Write-Output "Drive database successfully updated."

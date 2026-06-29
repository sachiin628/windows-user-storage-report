<#
.SYNOPSIS
    Cleans browser cache, user temp files, system temp files, and the Recycle Bin
    for all user profiles on the C: drive.

.DESCRIPTION
    Safe cleanup script that ONLY removes cache/temp data (never personal files,
    documents, or browser profile/bookmark data). For every user profile under
    C:\Users it clears:
      - Google Chrome cache
      - Microsoft Edge cache
      - Firefox cache (cache2 folder per profile)
      - User Temp folder (AppData\Local\Temp)

    It then clears:
      - Windows System Temp (C:\Windows\Temp)
      - Recycle Bin

    Designed to be run manually or automated via Windows Task Scheduler for
    regular server/PC maintenance and disk space recovery.

.NOTES
    Author : <your-name>
    Run as : Administrator (required to clean other users' folders and system temp)

.EXAMPLE
    .\Clear-ServerCache.ps1
#>

Write-Output "Cleanup Started: $(Get-Date)"

$UserProfiles = Get-ChildItem "C:\Users" -Directory | Where-Object {
    $_.Name -notin @("Public", "Default", "Default User", "All Users")
}

foreach ($Profile in $UserProfiles) {

    $UserPath = $Profile.FullName
    Write-Output "Cleaning User: $UserPath"

    # -------------------------------
    # Google Chrome Cache
    # -------------------------------
    $ChromeCache = "$UserPath\AppData\Local\Google\Chrome\User Data\Default\Cache"
    if (Test-Path $ChromeCache) {
        Remove-Item "$ChromeCache\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Output "Chrome Cache Cleaned"
    }

    # -------------------------------
    # Microsoft Edge Cache
    # -------------------------------
    $EdgeCache = "$UserPath\AppData\Local\Microsoft\Edge\User Data\Default\Cache"
    if (Test-Path $EdgeCache) {
        Remove-Item "$EdgeCache\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Output "Edge Cache Cleaned"
    }

    # -------------------------------
    # Firefox Cache
    # -------------------------------
    $FirefoxProfiles = "$UserPath\AppData\Local\Mozilla\Firefox\Profiles"
    if (Test-Path $FirefoxProfiles) {
        Get-ChildItem $FirefoxProfiles -Directory | ForEach-Object {
            $FFCache = "$($_.FullName)\cache2"
            if (Test-Path $FFCache) {
                Remove-Item "$FFCache\*" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Output "Firefox Cache Cleaned"
            }
        }
    }

    # -------------------------------
    # User Temp
    # -------------------------------
    $TempPath = "$UserPath\AppData\Local\Temp"
    if (Test-Path $TempPath) {
        Remove-Item "$TempPath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Output "User Temp Cleaned"
    }
}

# -------------------------------
# Windows System Temp
# -------------------------------
$SystemTemp = "C:\Windows\Temp"
if (Test-Path $SystemTemp) {
    Remove-Item "$SystemTemp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "System Temp Cleaned"
}

# -------------------------------
# Recycle Bin
# -------------------------------
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Write-Output "Cleanup Completed: $(Get-Date)"

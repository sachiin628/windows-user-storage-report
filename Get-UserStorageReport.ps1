<#
.SYNOPSIS
    Generates a user-wise storage usage report for all user profiles on the C: drive.

.DESCRIPTION
    Scans every user folder under C:\Users and calculates storage usage (in GB) for:
      - Total profile size
      - Desktop
      - Downloads
      - Documents
      - AppData (total)
      - Chrome browser data
      - Edge browser data
      - Firefox browser data

    Useful for quickly identifying which user accounts and which folders
    (browser cache/profile data, downloads, etc.) are consuming the most disk space.

.NOTES
    Author : <your-name>
    Run as : Administrator (recommended, so all user folders can be read)

.EXAMPLE
    .\Get-UserStorageReport.ps1
#>

$ErrorActionPreference = "SilentlyContinue"

function Get-FolderSizeGB {
    param([string]$Path)

    if (Test-Path $Path) {
        $size = (Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue |
                 Measure-Object -Property Length -Sum).Sum
        return [math]::Round($size / 1GB, 2)
    }
    else {
        return 0
    }
}

$usersPath = "C:\Users"
$results = @()

$users = Get-ChildItem $usersPath -Directory | Where-Object {
    $_.Name -notmatch "Public|Default|All Users"
}

foreach ($user in $users) {

    $u = $user.FullName

    $obj = [PSCustomObject]@{
        User        = $user.Name
        TotalGB     = Get-FolderSizeGB $u
        DesktopGB   = Get-FolderSizeGB "$u\Desktop"
        DownloadsGB = Get-FolderSizeGB "$u\Downloads"
        DocumentsGB = Get-FolderSizeGB "$u\Documents"
        AppDataGB   = Get-FolderSizeGB "$u\AppData"
        ChromeGB    = Get-FolderSizeGB "$u\AppData\Local\Google\Chrome\User Data"
        EdgeGB      = Get-FolderSizeGB "$u\AppData\Local\Microsoft\Edge\User Data"
        FirefoxGB   = Get-FolderSizeGB "$u\AppData\Roaming\Mozilla\Firefox"
    }

    $results += $obj
}

# Display table sorted by highest total usage
$results | Sort-Object TotalGB -Descending | Format-Table -AutoSize

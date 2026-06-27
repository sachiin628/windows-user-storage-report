# Windows User Storage Report

A simple PowerShell script that scans every user profile on the `C:\` drive and reports how much disk space (in GB) each user is consuming — broken down by Desktop, Downloads, Documents, AppData, and individual browser data (Chrome, Edge, Firefox).

Useful for quickly finding out **which user account** and **which folder** is eating up your disk space.

## What it reports

For every user folder under `C:\Users`, the script calculates:

| Column        | What it measures                                      |
|----------------|--------------------------------------------------------|
| `TotalGB`      | Total size of the user's entire profile folder         |
| `DesktopGB`    | Size of the Desktop folder                              |
| `DownloadsGB`  | Size of the Downloads folder                             |
| `DocumentsGB`  | Size of the Documents folder                              |
| `AppDataGB`    | Size of the entire AppData folder                          |
| `ChromeGB`     | Size of Chrome's `User Data` folder (cache, profiles, etc.) |
| `EdgeGB`       | Size of Edge's `User Data` folder                            |
| `FirefoxGB`    | Size of Firefox's profile folder                               |

Results are displayed as a table, sorted by `TotalGB` in descending order — so the heaviest user shows up first.

## Requirements

- Windows 10 / 11
- PowerShell 5.1 or later (built into Windows)
- Run as **Administrator** is recommended, so the script can read other users' folders without permission errors

## How to use

1. Download `Get-UserStorageReport.ps1` from this repository.
2. Open **PowerShell as Administrator**.
3. Navigate to the folder where you saved the script:
   ```powershell
   cd "C:\path\to\downloaded\script"
   ```
4. If script execution is blocked, allow it for this session:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
5. Run the script:
   ```powershell
   .\Get-UserStorageReport.ps1
   ```
6. A table will print showing storage usage for every user, sorted by total size.

## Example output

```
User      TotalGB DesktopGB DownloadsGB DocumentsGB AppDataGB ChromeGB EdgeGB FirefoxGB
----      ------- --------- ----------- ----------- --------- -------- ------ ---------
John      45.32   2.1       18.4        3.2         21.6      12.3     4.1    0.8
Priya     12.05   0.5       3.2         1.1         7.25      5.4      1.2    0.0
```

## Notes

- The script ignores `Public`, `Default`, and `All Users` system folders since these aren't real user accounts.
- Folders that don't exist (e.g. a user never installed Firefox) simply report `0`.
- Large `AppData` or browser sizes are usually caused by cache, extensions, or sync data and can often be safely cleaned up via each browser's own settings.

## License

This project is licensed under the MIT License — feel free to use, modify, and share.

## Author

Maintained by [your-name]. Contributions and suggestions welcome via Issues or Pull Requests.

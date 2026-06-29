# Windows User Storage Report & Cleanup Toolkit

A small collection of PowerShell scripts for monitoring and maintaining disk space on Windows machines (PCs or servers) with multiple user profiles. Useful for IT admins, sysadmins, or anyone managing a shared/multi-user Windows system.

## Scripts in this repo

| Script | Purpose |
|---|---|
| [`Get-UserStorageReport.ps1`](#1-get-userstoragereportps1--storage-report) | Reports how much disk space each user account is using (Desktop, Downloads, Documents, AppData, browser data) |
| [`Clear-ServerCache.ps1`](#2-clear-servercacheps1--cache-cleanup) | Safely cleans browser cache, temp files, and Recycle Bin for all users to free up space |

Together, you can run the report script to **find** what's eating space, then run the cleanup script to **reclaim** it — and automate the cleanup on a schedule.

---

## 1. `Get-UserStorageReport.ps1` — Storage Report

Scans every user profile on `C:\` and reports storage usage (in GB), broken down by:

| Column | What it measures |
|---|---|
| `TotalGB` | Total size of the user's entire profile folder |
| `DesktopGB` | Size of the Desktop folder |
| `DownloadsGB` | Size of the Downloads folder |
| `DocumentsGB` | Size of the Documents folder |
| `AppDataGB` | Size of the entire AppData folder |
| `ChromeGB` | Size of Chrome's `User Data` folder |
| `EdgeGB` | Size of Edge's `User Data` folder |
| `FirefoxGB` | Size of Firefox's profile folder |

Results print as a table sorted by `TotalGB` descending — the heaviest user appears first.

### Usage
```powershell
cd "C:\path\to\script"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Get-UserStorageReport.ps1
```

### Example output
```
User      TotalGB DesktopGB DownloadsGB DocumentsGB AppDataGB ChromeGB EdgeGB FirefoxGB
----      ------- --------- ----------- ----------- --------- -------- ------ ---------
John      45.32   2.1       18.4        3.2         21.6      12.3     4.1    0.8
Priya     12.05   0.5       3.2         1.1         7.25      5.4      1.2    0.0
```

---

## 2. `Clear-ServerCache.ps1` — Cache Cleanup

A **safe** cleanup script — it only removes temporary/cache data and never touches personal files, documents, or saved browser data (bookmarks, passwords, history, etc.).

For every user profile, it clears:
- Google Chrome cache
- Microsoft Edge cache
- Firefox cache (`cache2` folder)
- User Temp folder (`AppData\Local\Temp`)

It then clears:
- Windows System Temp (`C:\Windows\Temp`)
- Recycle Bin

### Usage
```powershell
cd "C:\path\to\script"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Clear-ServerCache.ps1
```

### Automating with Task Scheduler

To run this cleanup automatically (e.g. weekly, or every night on a server):

1. Open **Task Scheduler** → **Create Task** (not "Basic Task", so you get full options).
2. **General tab:**
   - Name: `Server Cache Cleanup`
   - Select **Run whether user is logged on or not**
   - Check **Run with highest privileges** (required to clean other users' folders and system temp)
3. **Triggers tab → New:**
   - Set your schedule (e.g. Weekly, every Sunday at 2:00 AM)
4. **Actions tab → New:**
   - Action: **Start a program**
   - Program/script:
     ```
     powershell.exe
     ```
   - Add arguments:
     ```
     -ExecutionPolicy Bypass -File "C:\Scripts\Clear-ServerCache.ps1"
     ```
   - (Adjust the path to wherever you save the script on the server)
5. **Conditions / Settings tabs:** adjust as needed (e.g. allow it to run on battery if it's a laptop).
6. Click **OK**, enter admin credentials when prompted, and the task is now scheduled.

You can test it immediately by right-clicking the task → **Run**, and checking the script's console output (redirect it to a log file if you want a history — see note below).

> **Tip:** To keep a log of each run, change the Action arguments to:
> ```
> -ExecutionPolicy Bypass -File "C:\Scripts\Clear-ServerCache.ps1" >> "C:\Scripts\cleanup-log.txt" 2>&1
> ```

---

## Requirements

- Windows 10 / 11 or Windows Server
- PowerShell 5.1 or later (built into Windows)
- Run as **Administrator** (required for both scripts to access other users' folders and system-level paths)

## Notes

- Both scripts skip `Public`, `Default`, and `All Users` system folders since these aren't real user accounts.
- Folders that don't exist (e.g. a user never installed Firefox) are simply skipped/reported as `0`.
- `Clear-ServerCache.ps1` is intentionally conservative — it does not delete browser profiles, saved passwords, bookmarks, or any non-cache data.
- Always test scripts on a non-production machine first before scheduling them on a live server.

## License

This project is licensed under the MIT License — feel free to use, modify, and share.

## Author

Maintained by [your-name]. Contributions and suggestions welcome via Issues or Pull Requests.

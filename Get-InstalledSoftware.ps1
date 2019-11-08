﻿Write-Host "`n --------------------------------------  x86  -------------------------------------- `n" -ForegroundColor Green
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object DisplayName, Publisher, DisplayVersion, InstallSource, InstallDate, UninstallString | ? {$_.DisplayName -ne $null} | sort DisplayName
Write-Host "`n --------------------------------------  x86_64  -------------------------------------- `n" -ForegroundColor Green
Get-ItemProperty "HKLM:\SOFTWARE\Wow6432node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object DisplayName, Publisher, DisplayVersion, InstallSource, InstallDate, UninstallString | ? {$_.DisplayName -ne $null} | sort DisplayName
Write-Host "`n --------------------------------------  Current User  -------------------------------------- `n" -ForegroundColor Green
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object DisplayName, Publisher, DisplayVersion, InstallSource, InstallDate, UninstallString | ? {$_.DisplayName -ne $null} | sort DisplayName
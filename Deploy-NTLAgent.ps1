Set-Location C:\
foreach ($server in (Get-Content C:\computerlist.txt)) {Robocopy.exe C:\ \\$server\c$\ NTLProtect_DEA473ADA16B44A5AE60C16B1FE287C2-E5.exe /v /r:1 /w:10}
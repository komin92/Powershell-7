<#
    This script is used to detect IoC for the EMOTET.TROJAN
#>
#Create Logfile 
$LogTime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
$LogFile = 'C:\Users\braeden.hopper\'+"$env:computername"+$LogTime+".txt" 


#Registry checks
 "`n REGISTRY `n" >> $LogFile
Get-ChildItem -Path HKLM:\SYSTEM\CurrentControlSet\Services >> $LogFile
Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run >> $LogFile


#OS checks - not file specific
"`n SYSTEM FILES `n" >> $LogFile 
Get-ChildItem -Path C:\ -Hidden >> $LogFile
Get-ChildItem -Path C:\ >> $LogFile
Get-ChildItem -Path C:\Users\administrator\appdata\roaming -Recurse >> $LogFile
Get-ChildItem -Path C:\Windows\System32 >> $LogFile
Get-ChildItem -Path C:\Windows\System32\Tasks >> $LogFile
Get-ChildItem -Path C:\Windows >> $LogFile
Get-ChildItem -Path C:\Windows\SysWOW64 >> $LogFile
Get-ChildItem -Path C:\Windows\Temp >> $LogFile

#OS checks - file specific
"`n EXECUTABLES & TMP FILES `n" >> $LogFile 
Get-ChildItem -Path C:\Windows -Filter *.exe >> $LogFile
Get-ChildItem -Path C:\Windows\SysWOW64 -Filter *.exe >> $LogFile 
Get-ChildItem -Path C:\Windows\Temp -Filter *.tmpw >> $LogFile

#Service checks
"`n SERVICES `n" >> $LogFile 
Get-Service "[0-9]*" >> $LogFile
Get-Service >> $LogFile


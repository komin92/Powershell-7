<# Created by Braeden Hopper 
   October 24 2019
   Gets users, service accounts, computers and memberships in AD using AD module
#> 

$file = "C:\Users\Public\audit.txt"
$separator = "`n ============================================================ `n"
$ErrorActionPreference = "silentlycontinue"


"AD AUDIT" > $file
date >> $file
$separator >> $file


"Active Directory User Accounts `n" >> $file
(Get-ADUser -Filter *).Name >> $file
$separator >> $file


"Active Directory Service Accounts `n" >> $file
(Get-ADServiceAccount -Filter *).Name >> $file
$separator >> $file


"Active Directory Computers `n" >> $file
(Get-ADComputer -Filter *).name >> $file
$separator >> $file


"Group Memeberships `n" >> $file
$grouplist = (Get-ADGroup -Filter *).Name
ForEach ($i in $grouplist) {
    $i >> $file
    Get-ADGroupMember -Identity $i -Recursive | Select-Object -Property name,objectClass >> $file
    " " >> $file
    $separator >> $file
}

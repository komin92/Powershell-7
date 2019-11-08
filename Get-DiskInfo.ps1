<#$disks = Get-Disk | Format-List *
foreach($disk in $disks.Count) {
    Write-Host "Disk name is " $disk[$i].FriendlyName
    Write-Host "Disk size is " $disks[$i].TotalSize

}#>



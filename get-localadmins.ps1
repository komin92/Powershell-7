function get-localadmins{
  [cmdletbinding()]
  Param(
  [string]$computerName
  )
  $group = get-wmiobject win32_group -ComputerName $computerName -Filter "LocalAccount=True AND SID='S-1-5-32-544'"
  $query = "GroupComponent = `"Win32_Group.Domain='$($group.domain)'`,Name='$($group.name)'`""
  $list = Get-WmiObject win32_groupuser -ComputerName $computerName -Filter $query
  $list | ForEach{$_.PartComponent} | ForEach{$_.substring($_.lastindexof("Domain=") + 7).replace("`",Name=`"","\")}
}

foreach($computer in (Get-ADComputer -filter * | select name).name){
Write-Verbose "Checking $computer" -Verbose
get-localadmins -computerName $computer
}
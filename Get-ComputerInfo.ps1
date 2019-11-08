$Computer = "localhost"
$Manufacturer = Get-WmiObject -ComputerName $Computer -class win32_computersystem | select -ExpandProperty Manufacturer
$Model = Get-WmiObject -class win32_computersystem -ComputerName $Computer | select -ExpandProperty model
$Serial = Get-WmiObject -class win32_bios -ComputerName $Computer | select -ExpandProperty SerialNumber
$wmi_os = Get-WmiObject -class Win32_OperatingSystem -ComputerName $Computer | select CSName,Caption,Version,OSArchitecture,LastBootUptime
$wmi_build = ""
$testval = $wmi_os.Version
switch($testval){
'10.0.10240'{$wmi_build = "1507"; break;}
'10.0.10586'{$wmi_build = "1511"; break;}
'10.0.14393'{$wmi_build = "1607"; break;}
'10.0.15063'{$wmi_build = "1703"; break;}
'10.0.16299'{$wmi_build = "1709"; break;}
'10.0.17134'{$wmi_build = "1803"; break;}
'10.0.17763'{$wmi_build = "1809"; break;}
'10.0.18362'{$wmi_build = "1903"; break;}
default {Write-Host "No matching OS Version"} 
}
$wmi_cpu = Get-WmiObject -class Win32_Processor -ComputerName $Computer | select -ExpandProperty DataWidth
$wmi_memory = Get-WmiObject -class cim_physicalmemory -ComputerName $Computer | select Capacity | %{($_.Capacity / 1024kb)}
$DNName = Get-ADComputer -Filter "Name -like '$Computer'" | select -ExpandProperty DistinguishedName
$Boot=[System.DateTime]::ParseExact($($wmi_os.LastBootUpTime).Split(".")[0],'yyyyMMddHHmmss',$null)
[TimeSpan]$uptime = New-TimeSpan $Boot $(get-date)
Write-Host "------Computer Info for $Computer------------------`r"
Write-Host "Hostname from WMI`: $($wmi_os.CSName)"
Write-Host "$DNName"
Write-Host "$Manufacturer $Model SN`:$Serial"
Write-Host "$($wmi_os.Caption) $wmi_build $($wmi_os.OSArchitecture) $($wmi_os.Version)" 
Write-Host "CPU Architecture: $wmi_cpu"
Write-Host "Memory: $wmi_memory"
Write-Host "Uptime`: $($uptime.days) Days $($uptime.hours) Hours $($uptime.minutes) Minutes $($uptime.seconds) Seconds"
Write-Host "--------------------------------------------------------"
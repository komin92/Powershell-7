<# 
    Preliminary script to install all necessary tools for the PartnerIT module 
    Requires: Run As Administrator

#>

#Create log file 
$logfile = New-Item -ItemType File -Path $env:TEMP -Name pit-psmodule-log.txt
date >> $logfile

#Create info file 
$infofile = New-Item -ItemType File -Path $env:TEMP -Name pit-psmodule-info.txt

#System Query
$os_version = (Get-WmiObject -Class Win32_OperatingSystem).Caption

#RSAT for SERVER
if ($os_version -eq "Microsoft Windows Server 2019 Standard"){
    Install-WindowsFeature -IncludeAllSubFeature RSAT
    Get-WindowsFeature >> $logfile
}
elseif ($os_version -eq "Microsoft Windows Server 2016 Standard"){
    Install-WindowsFeature -IncludeAllSubFeature RSAT
    Get-WindowsFeature >> $logfile
}
elseif ($os_version -eq "Microsoft Windows Server 2012 R2 Standard"){
    Install-WindowsFeature -IncludeAllSubFeature RSAT
    Get-WindowsFeature >> $logfile
}
elseif ($os_version -eq "Microsoft Windows Server 2012 Standard"){
    Install-WindowsFeature -IncludeAllSubFeature RSAT
    Get-WindowsFeature >> $logfile
}


#RSAT for WORKSTATION
elseif ($os_version -eq "Microsoft Windows 10 Pro"){
    Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online #add rsat to windows
    Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State >> $logfile #log it
}
elseif ($os_version -eq "Microsoft Windows 10 Enterprise"){
   Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online #add rsat to windows
   Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State >> $logfile #log it
}


#NO RSAT for SERVER - GUI OR EOL
elseif ($os_version -eq "Microsoft Windows Server 2008 R2 Standard"){
    #RSAT - EOL + GUI
    Write-Host "RSAT must be installed via GUI - refer to webpage"
    Start-Process -PSPath https://4sysops.com/wiki/how-to-install-the-powershell-active-directory-module/
}
elseif ($os_version -ccontains "Microsoft Windows Server 2008 Standard"){
    #No RSAT - EOL 
    Write-Host "RSAT is not available"
}
elseif ($os_version -ccontains "Microsoft Windows Server 2008 Standard FE"){
    #No RSAT - EOL 
    Write-Host "RSAT is not available"
}


#NO RSAT for WORKSTATION - GUI OR EOL
elseif ($os_version -eq "Microsoft Windows 10 Home"){
    #No RSAT - EOL + GUI
    Write-Host "RSAT is not available"
}
elseif ($os_version -eq "Microsoft Windows 8.1 Pro"){
    #No RSAT - EOL + GUI
    Write-Host "RSAT must be installed via GUI - refer to webpage"
    Start-Process -PSPath https://4sysops.com/wiki/how-to-install-the-powershell-active-directory-module/
}
elseif ($os_version -eq "Microsoft Windows 7 Professional"){
    #No RSAT - EOL + GUI
    Write-Host "RSAT must be installed via GUI - refer to webpage"
    Start-Process -PSPath https://4sysops.com/wiki/how-to-install-the-powershell-active-directory-module/
}
else {
    #OS NOT SUPPORTED
    Write-Host "OS not supported"
}


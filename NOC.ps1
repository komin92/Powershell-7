<#
.SYNOPSIS
    Toolkit for managing devices who don't have the ConnectWise Agent
.AUTHORS
    Braeden Hopper - PartnerIT - November 2019
.PREREQUISITES
    Domain Admin rights
    Extract PsTools.zip into C:\Windows\Temp\
    C:\Windows\Temp\AgentUninstall.exe
    C:\Windows\Temp\Agent_Install.exe
    C:\Windows\Temp\tls-reg.ps1
#>


## GLOBAL VARIABLES
##############################################

$Global:ModuleUser = ""
$Global:ModulePass = ""

##############################################

## WELCOME HEADER
Write-Host -ForegroundColor DarkYellow "                       _oo0oo_"
Write-Host -ForegroundColor DarkYellow "                      o8888888o"
Write-Host -ForegroundColor DarkYellow "                      88`" . `"88"
Write-Host -ForegroundColor DarkYellow "                      (| -_- |)"
Write-Host -ForegroundColor DarkYellow "                      0\  =  /0"
Write-Host -ForegroundColor DarkYellow "                    ___/`----'\___"
Write-Host -ForegroundColor DarkYellow "                  .' \\|     |// '."
Write-Host -ForegroundColor DarkYellow "                 / \\|||  :  |||// \"
Write-Host -ForegroundColor DarkYellow "                / _||||| -:- |||||- \"
Write-Host -ForegroundColor DarkYellow "               |   | \\\  -  /// |   |"
Write-Host -ForegroundColor DarkYellow "               | \_|  ''\---/''  |_/ |"
Write-Host -ForegroundColor DarkYellow "               \  .-\__  '-'  ___/-. /"
Write-Host -ForegroundColor DarkYellow "             ___'. .'  /--.--\  `. .'___"
Write-Host -ForegroundColor DarkYellow "          .`"`" '<  `.___\_<|>_/___.' >' `"`"."
Write-Host -ForegroundColor DarkYellow "         | | :  `- \`.;`\ _ /`;.`/ - ` : | |"
Write-Host -ForegroundColor DarkYellow "         \  \ `_.   \_ __\ /__ _/   .-` /  /"
Write-Host -ForegroundColor DarkYellow "     =====`-.____`.___ \_____/___.-`___.-'====="
Write-Host -ForegroundColor DarkYellow "                       `=---='"
Write-Host -ForegroundColor DarkYellow "                      ZEN NOC                  "

##############################################


Function Check-Result {
   Param(
        [Parameter(Mandatory=$true)]
        $res
    )
    if ($res) {
        Write-Host "Success" -ForegroundColor Green
    }
    else {
        Write-Error "Failed"
    }

}


Function Set-ModuleCredentials {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $User,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Password
    )
    Write-Host "`n Setting credentials for module use. Recommended to use account with Domain Admin rights" -ForegroundColor Gray
    $Global:ModuleUser = $User
    $Global:ModulePass = $Password
} Export-ModuleMember -Function


Function Start-Probe {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    )
    # Test WSMAN
    Write-Host "`n Testing for WS-MAN Connection (uses WinRM service)" -ForegroundColor Gray
    Test-WSMan -ComputerName $ComputerName
    Check-Result($?)
   
    # Test TCP::5985 (WSMAN Port)
    Write-Host "`n Testing for TCP Connectivity over Port 5985 (WinRM port)" -ForegroundColor Gray
    Test-NetConnection -ComputerName "192.168.101.115" -Port 5985
    Check-Result($?)

    # Test PS-Remoting
    Write-Host "`n Testing for PS Remoting" -ForegroundColor Gray
    try {
        $errorActionPreference = "Stop"
        $result = Invoke-Command -ComputerName $ComputerName { 1 }
    }
    catch {
        Write-Error $_ 
    }
    # Check result
    if($result -ne 1) {
        Write-Error "Remoting to $ComputerName returned an unexpected result."
    }
} Export-ModuleMember -Function


Function RemEnable-PSRemoting {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    )
    Write-Host "`n Remotely Enabling PowerShell Remoting..." -ForegroundColor Gray
    C:\Windows\Temp\psexec.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass -accepteula -s c:\windows\system32\winrm.cmd quickconfig -quiet
    Check-Result($?)
} Export-ModuleMember -Function
 

Function Uninstall-LTService {
    Param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName
    )
    Write-Host "`n Uninstalling ConnectWise Agent" -ForegroundColor Gray
    C:\Windows\Temp\psexec.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass -accepteula -c -s "C:\Windows\Temp\Agent_Uninstall.exe" 
    Check-Result($?)
} Export-ModuleMember -Function


Function Install-LTService {
    Param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName
    )
    Write-Host "`n Installing ConnectWise Agent" -ForegroundColor Gray
    C:\Windows\Temp\psexec.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass -accepteula -c -s "C:\Windows\Temp\Agent_Install.exe" /quiet /norestart
    Check-Result($?)
} Export-ModuleMember -Function Install-LTService


Function Start-LTService {
    Param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName
    )
    Write-Host "`n Starting LTService on $ComputerName" -ForegroundColor Gray
    C:\Windows\Temp\PsExec.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass net start LTService
    Check-Result($?)

} Export-ModuleMember -Function Start-LTService 


Function Stop-LTService {
    Param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName
    )
    Write-Host "`n Starting LTService on $ComputerName" -ForegroundColor Gray
    C:\Windows\Temp\PsExec.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass net stop LTService
    Check-Result($?)

} Export-ModuleMember -Function Stop-LTService


Function Start-LTMonService {
    Param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName
    )
    Write-Host "`n Starting LTService on $ComputerName" -ForegroundColor Gray
    C:\Windows\Temp\PsExec.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass net start LTSvcMon
    Check-Result($?)

} Export-ModuleMember -Function Start-LTMonService


Function Stop-LTMonService {
    Param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName
    )
    Write-Host "`n Starting LTService on $ComputerName" -ForegroundColor Gray
    C:\Windows\Temp\PsExec.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass net stop LTSvcMon
    Check-Result($?)

} Export-ModuleMember -Function Stop-LTMonService


Function Reset-LTService {
    Param(
                [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [string] $ComputerName
    )
    Write-Host "`n Resetting LT Service on $ComputerName " -ForegroundColor Gray
    Invoke-Command -ComputerName $ComputerName -ScriptBlock { %windir%\system32\WindowsPowerShell\v1.0\powershell.exe "(new-object Net.WebClient).DownloadString('https://bit.ly/ltposh') | iex; Redo-LTService" }
    Check-Result($?)
} Export-ModuleMember -Function Reset-LTService 


Function Get-LTErrors {
   Param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName
    )
    Write-Host "`n Retrieving ConnectWise Agent Error Log" -ForegroundColor Gray
    Copy-Item "\\$ComputerName\C:\Windows\Temp\LTErrors.txt" -Destination "C:\Users\Public\$ComputerName-LTErrors.txt"
    Check-Result($?)
} Export-ModuleMember -Function Get-LTErrors


Function Enable-TLS {
    Param(
                [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [string] $ComputerName
    )
    Write-Host "`n Enabling TLS 1.2 on $ComputerName " -ForegroundColor Gray
    Copy-Item C:\Windows\Temp\tls-reg.ps1 \\$ComputerName\C$\Windows\Temp\tls-reg.ps1
    Invoke-Command -ComputerName $ComputerName -ScriptBlock { powershell -file "C:\Windows\Temp\tls-reg.ps1" }
    Check-Result($?)
} Export-ModuleMember -Function Enable-TLS


Function Copy-File {
    Param(
                [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [string] $ComputerName, 
                [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [string] $FilePath,
                [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [string] $FileName
    )
    Write-Host "`n Sending $FilePath to $ComputerName" -ForegroundColor Gray
    Copy-Item $FilePath -Destination "\\$ComputerName\C$\Users\Public\$FileName"
    Check-Result($?)
} Export-ModuleMember -Function Copy-File


Function Get-Info {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    )
    Write-Host "`n Retreiving computer info from: $ComputerName" -ForegroundColor Gray
    C:\Windows\Temp\psinfo.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass
    Check-Result($?)
} Export-ModuleMember -Function Get-Info


Function Get-ProcessList {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    )
    Write-Host "`n Listing Process Information from: $ComputerName" -ForegroundColor Gray
    C:\Windows\Temp\pslist.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass
    Check-Result($?)
} Export-ModuleMember -Function Get-ProcessList


Function Get-ServiceList {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    )
    Write-Host "`n Listing Service Information from: $ComputerName" -ForegroundColor Gray
    C:\Windows\Temp\psservice.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass query 
} Export-ModuleMember -Function Get-ServiceList


Function Change-Password {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName, 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $User,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Password
    )
    Write-Host "`n Changing password on: $ComputerName for $User" -ForegroundColor Gray
    C:\Windows\Temp\pspasswd.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass $User $Password
    Check-Result($?)
} Export-ModuleMember -Function Change-Password


Function Reboot-Computer {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    )
    Write-Host "`n $ComputerName will be rebooted..." -ForegroundColor Gray
    C:\Windows\Temp\psshutdown.exe \\$ComputerName -k 
    Check-Result($?)
} Export-ModuleMember -Function Reboot-Computer


Function Get-LoggedOnUser {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    )
    Write-Host "`n Obtaining logged on users for $ComputerName" -ForegroundColor Gray
    C:\Windows\Temp\psloggedon.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass
    Check-Result($?)
} Export-ModuleMember -Function Get-LoggedOnUser


Function Find-LoggedOnUser {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $UserName
    )
    Write-Host "`n Finding computer where $UserName is logged on" -ForegroundColor Gray
    C:\Windows\Temp\psloggedon.exe $UserName -u $Global:ModuleUser -p $Global:ModulePass
    Check-Result($?)
} Export-ModuleMember -Function Find-LoggedOnUser


Function Get-Shell {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    )
    Write-Host "`n Opening interactive shell from $ComputerName"
    C:\Windows\Temp\PsExec.exe \\$ComputerName -u $Global:ModuleUser -p $Global:ModulePass cmd.exe 
} Export-ModuleMember -Function Get-Shell
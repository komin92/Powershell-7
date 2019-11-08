$arch=(Get-WmiObject -Class Win32_operatingsystem).Osarchitecture
$reg32bWinHttp = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
$reg64bWinHttp = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
$regWinHttpDefault = "DefaultSecureProtocols"
$regWinHttpValue = "0x00000a00"
$regTLS11 = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
$regTLS12 = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
$regTLSDefault = "DisabledByDefault"
$regTLSValue = "0x00000000"


#Make backup of the keys 
Reg Export HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols C:\Windows\Temp\ExportedProtocolsRegKey.reg
 
Clear-Host
Write-Output "Creating Registry Keys...`n"
Write-Output "Creating registry key $reg32bWinHttp\$regWinHttpDefault with value $regWinHttpValue"
 
IF(!(Test-Path $reg32bWinHttp)) {
    New-Item -Path $reg32bWinHttp -Force | Out-Null
    New-ItemProperty -Path $reg32bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
}
ELSE {
    New-ItemProperty -Path $reg32bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
}
 
IF($arch -eq "64-bit") {
    Write-Output "Creating registry key $reg64bWinHttp\$regWinHttpDefault with value $regWinHttpValue"
    IF(!(Test-Path $reg64bWinHttp)) {
        New-Item -Path $reg64bWinHttp -Force | Out-Null
        New-ItemProperty -Path $reg64bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
    }
    ELSE {
        New-ItemProperty -Path $reg64bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
    }
}
     
Write-Output "Creating registry key $regTLS11\$regTLSDefault with value $regTLSValue"
 
IF(!(Test-Path $regTLS11)) {
    New-Item -Path $regTLS11 -Force | Out-Null
    New-ItemProperty -Path $regTLS11 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
    }
ELSE {
    New-ItemProperty -Path $regTLS11 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
}
     
Write-Output "Creating registry key $regTLS12\$regTLSDefault with value $regTLSValue"
 
IF(!(Test-Path $regTLS12)) {
    New-Item -Path $regTLS12 -Force | Out-Null
    New-ItemProperty -Path $regTLS12 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
    }
ELSE {
    New-ItemProperty -Path $regTLS12 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
}
 
Write-Output "`nComplete!"
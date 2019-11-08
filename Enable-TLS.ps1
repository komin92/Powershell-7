#Adds registry keys for TLS 1.2 

$regPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2" 
$clientName = "Client"
$fullRegPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"


$name_1 = "DisabledByDefault"
$value_1 = "0"

$name_2 = "Enabled"
$value_2 = "1"

IF(!(Test-Path $regPath)){
    New-Item -Path $regPath -Force | Out-Null #Create TLS 1.2 RegKey
    New-Item -Path $regPath -Name $clientName -Force | Out-Null #Create Client RegKey
    New-ItemProperty -Path $fullRegPath -Name $name_1 -Value $value_1 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $fullRegPath -Name $name_2 -Value $value_2 -PropertyType DWORD -Force | Out-Null
}
ELSE {
    New-ItemProperty -Path $fullRegPath -Name $name_1 -Value $value_1 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $fullRegPath -Name $name_2 -Value $value_2 -PropertyType DWORD -Force | Out-Null
}
$debug = Get-Childitem -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\" -Recurse | Where-Object { $_.Property -eq "Debugger" } | Where-Object { $_.pschildname -ne "DeviceCensus.exe" }
if(!$debug) { 
    $DebuggerFound = "Healthy - No Debugers found"
} else {
foreach($key in $debug){
$DebuggerFound += "$($key.pschildname) is debugged <br>`n"
}
}
$WDigestNegotiate           = get-childitem -path "HKLM:\System\CurrentControlSet\Control\SecurityProviders\WDigest" | Where-Object {$_.Property -eq "Negotiate"}
$WDigestUseLogonCredential  =  get-childitem -path "HKLM:\System\CurrentControlSet\Control\SecurityProviders\WDigest" | Where-Object {$_.Property -eq "UseLogonCredential"}
$CachedCredentialsAllowed   = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon").CachedLogonsCount
$NTLMCompatibilityLevel     = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").lmcompatibilitylevel


Write-Host "`n WDigestNegotiate Value: " $WDigestNegotiate
Write-Host "`n WDigestUseLogonCredential Value: " $WDigestUseLogonCredential
Write-Host "`n CachedCredentialAllowed Value: " $CachedCredentialsAllowed
Write-Host "`n NTLM Compatibility Level Value: " $NTLMCompatibilityLevel

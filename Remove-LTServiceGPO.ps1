<# Removes the Redo LT Service GPO
   The GPO was meant to re-initialize the Labtech agent when it broke after failing to update to a required version in March 2019 
 #>

Set-ExecutionPolicy -ExecutionPolicy Unrestricted
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$domain = (Get-ADDomain).Forest
$gpolist = Get-GPO -All -Domain $domain
$gpoExists = $null
$gpoName = "Redo LT Service"
ForEach ($gpo in $gpolist) {
    $name = ($gpo).DisplayName
    if ($name -eq $gpoName){
        $gpoExists = $true
    }
}


if ( $isAdmin ){
    if ( $gpoExists ){
        Remove-GPO -Name $gpoName
    }
    else {
        Write-Error "GPO: `"Redo LT Service `" Does Not Exist"
    }
}
else {
    Write-Warning "Elevated shell required for Removing GPO" 
}
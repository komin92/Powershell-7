<# Group Policy Auditing Script #>

# Get GPO listing
Write-Host " `n Generating Group Policy Objects List `n" -ForegroundColor Green
$domain = (Get-ADDomain).Forest
Get-GPO -All -Domain $domain | Out-File -FilePath "C:\Users\Public\GPO-List.html"


# Create GPO Report
Write-Host " `n Generating GPO Report `n" -ForegroundColor Green
Get-GPOReport -All -Domain $domain -ReportType Html -Path "C:\Users\Public\GPO-Report-All.html"


# Obtain resultant set of policy (RSOP)
Write-Host " `n Generating RSOP for $env:USERNAME in current session on $env:COMPUTERNAME `n" -ForegroundColor Green
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ( $isAdmin ){
    Get-GPResultantSetOfPolicy -ReportType Html -Path "C:\Users\Public\RSOP.html"
}
else {
    Write-Warning "Elevated shell required for RSOP" 
}

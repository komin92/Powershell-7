Write-Host "Please enter the admin credentials `n"
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Write-Host "Connecting to Robertson Hall Office365...`n" -ForegroundColor Yellow
Import-PSSession $Session -DisableNameChecking
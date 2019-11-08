<# Get RDP users #> 
Write-Host "qwinsta results:" -ForegroundColor Green
qwinsta
Write-Host "`n `n quser results:" -ForegroundColor Green
quser
#Write-Host "`n `n Get-RDUserSession results:" -ForegroundColor Green
#Get-RDUserSession

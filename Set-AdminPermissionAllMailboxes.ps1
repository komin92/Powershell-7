<# 
    Created by: Braeden Hopper
    Date: August 22 2019
    Purpose: Connects to Office365 Online for Robertson hall and adds full permissions to the admin account. Then disconnects the session automatically. 
#>
#Global Variables 
$admin_account ="Ellen Heine" #can be upn, alias or domain\user
#email = eheine@robertsonhall.com

#Connect
Write-Host "Please enter the admin credentials `n"
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Write-Host "Connecting to Robertson Hall Office365...`n" -ForegroundColor Yellow
Import-PSSession $Session -DisableNameChecking

#Modify Permissions
If ($Session) {
    Write-Host "Connected Successfully! `n" -ForegroundColor Green
    #Give permissions
    $res = Get-Mailbox -ResultSize unlimited -Filter * | Add-MailboxPermission -User $admin_account -AccessRights fullaccess -InheritanceType all -AutoMapping $false
    # optional filter: (RecipientTypeDetails -eq 'UserMailbox') -and
    #Check result
    If ($res) {
        Write-Host "Admin permissions to all mailboxes successfully assigned to " $UserCredential.UserName -ForegroundColor Green
        Get-MailboxPermission -Identity * -User "eheine@robertsonhall.com" | Select User, AccessRights, Deny, Valid
        #Cleanup
        Write-Host "Disconnecting from session...`n"
        Remove-PSSession $Session
        Write-Host "Disconnected"
    }
    Else {
        Write-Host "Failed to assign permissions. Please validate credentials provided. If you are using a proxy server, adjust the session parameters and try again. `n" -ForegroundColor Red
        #Cleanup
        Write-Host "Disconnecting from session...`n" -ForegroundColor Yellow
        Remove-PSSession $Session
        Write-Host "Disconnected" -ForegroundColor Red
    }
}
Else {
    Write-Host "Failed to connect `n Exiting Script" -ForegroundColor Red
    exit
}


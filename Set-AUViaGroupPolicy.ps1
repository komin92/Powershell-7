Import-Module GroupPolicy
<#
    Created By: Braeden Hopper
    Date: May 9 2018

    Purpose of Script: Automate Enabling of Windows Updates to Download and Install Automatically using Group Policy Object

    Function: Creates a Group Policy Object and links it to a target (Sets the scope of the gpo)
              The Target can be a local group policy, domain, site or ou
              All Clients will have to be restarted with gpupdate /force 
              By Default, Windows Update will randomly check for updates every 17-22 hours
              Ensure to apply it to users only with the $target parameter of the function -> Do not want this on a server or it will randomly shut down upon finding updates

    Requires: Active Directory Powershell Module Must be Installed on ADDC
              Module must be run from the Domain Controller - I dont know if this script will run with a remote ps session
              
#>
Function Enable-AutoUpdateGPO {

    #Ensure the Target is not aimed at servers
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Medium')] 
    Param(
        [string]
        $Target
    )
    if($Target){
        $GPO = "Enable Automatic Windows Updates"
        $Comment = "Enable Automatic Windows Updates"
        #target in form "ou=org,dc=domainc1,dc=domainc2"
        
        Try{
            #This will create a GPO in the domain of the user and link it to the Target (Domain, site or OU) It also enforces the GPO so that it cannot be overwritten by other GPOs that may exist
            New-GPO -Name $GPO -Comment $Comment | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "Install" -Value 4 -Type "DWord" | Out-Null
            (Get-GPO -Name $GPO).User.Enabled=$False
            Set-GPLink -Name $GPO -Target $Target -LinkEnabled Yes -Enforced Yes -Order 1 #No other GPO Can conflict with this one
            $New = Get-GPO -Name $GPO
            Write-Verbose "The new GPO has been created :" $New
            }
        Catch {
             Write-Warning "Failed to set Windows Automatic Updates in Group Policy" 
             Write-Error "Error :" $_
        }
    }
}
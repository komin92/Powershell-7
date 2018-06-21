<#
    Created By: Braeden Hopper
    Date: May 8 2018

    .SYNOPSIS 
    Automate verification of current UAC Setting and Modify it to the appropriate setting if desired 

    .DESCRIPTION 
    Checks Registry values according to Group Policy Settings and Registry Setting outlined in microsoft docs
    Uses optimal security Specifications to enforce strong administrative elevation privilege requirements and security 
    
    DEPLOYMENT: This is meant for the clients that are not part of a domain -> use for local account computers 
    
    .EXAMPLE
    > Run Script
    C:\> Set-SecureUACLevels -Confirm Y
               
    VALUES OBTAINED FROM:
    https://docs.microsoft.com/en-us/windows/security/identity-protection/user-account-control/user-account-control-group-policy-and-registry-key-settings
#>

# KEY VARIABLES

 $Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\"

 $FilterAdministratorToken_Name = 'FilterAdministratorToken'
 $EnableUIADesktopToggle_Name  = 'EnableUIADesktopToggle'
 $ConsentPromptBehaviorAdmin_Name = 'ConsentPromptBehaviorAdmin'
 $ConsentPromptBehaviorUser_Name = 'ConsentPromptBehaviorUser'
 $EnableInstallerDetection_Name = 'EnableInstallerDetection'
 $ValidateAdminCodeSignatures_Name = 'ValidateAdminCodeSignatures'
 $EnableSecureUIAPaths_Name = 'EnableSecureUIAPaths'
 $EnableLUA_Name = 'EnableLUA'
 $PromptOnSecureDesktop_Name = 'PromptOnSecureDesktop'
 $EnableVirtualization_Name = 'EnableVirtualization'


 Function Get-RegistryValue($key, $value) {  
 #Enables -WhatIf use on any command
   (Get-ItemProperty $key $value).$value  
}  

Function Set-RegistryValue($key, $name, $value, $type="Dword") {  
  If ((Test-Path -Path $key) -Eq $false) { New-Item -ItemType Directory -Path $key | Out-Null }  
       Set-ItemProperty -Path $key -Name $name -Value $value -Type $type -WhatIf -Confirm
}  

 Function Get-UACLevel(){ 
    [CmdLetBinding(SupportsShouldProcess=$True)]
    $FilterAdministratorToken_Value = Get-RegistryValue $Key $FilterAdministratorToken_Name
    $EnableUIADesktopToggle_Value  = Get-RegistryValue $Key $EnableUIADesktopToggle_Name
    $ConsentPromptBehaviorAdmin_Value = Get-RegistryValue $Key $ConsentPromptBehaviorAdmin_Name
    $ConsentPromptBehaviorUser_Value = Get-RegistryValue $Key $ConsentPromptBehaviorUser_Name
    $EnableInstallerDetection_Value = Get-RegistryValue $Key $EnableInstallerDetection_Name
    $ValidateAdminCodeSignatures_Value = Get-RegistryValue $Key $ValidateAdminCodeSignatures_Name
    $EnableSecureUIAPaths_Value = Get-RegistryValue $Key $EnableSecureUIAPaths_Name
    $EnableLUA_Value = Get-RegistryValue $Key $EnableLUA_Name
    $PromptOnSecureDesktop_Value = Get-RegistryValue $Key $PromptOnSecureDesktop_Name
    $EnableVirtualization_Value = Get-RegistryValue $Key $EnableVirtualization_Name
    
    Write-Verbose "Finished Retrieving Registry Keys...\n"
} 


Function Set-SecureUACLevels {

    # VALUES OBTAINED FROM:
    # https://docs.microsoft.com/en-us/windows/security/identity-protection/user-account-control/user-account-control-group-policy-and-registry-key-settings

    [CmdLetBinding(SupportsShouldProcess=$True)] 
    param(
    [string][ValidateSet("Y","y")]
    $Confirm
    )

    $FilterAdministratorToken_Value = 1
    $EnableUIADesktopToggle_Value  = 0
    $ConsentPromptBehaviorAdmin_Value = 1
    $ConsentPromptBehaviorUser_Value = 1
    $EnableInstallerDetection_Value = 1
    $ValidateAdminCodeSignatures_Value = 0
    $EnableSecureUIAPaths_Value = 1
    $EnableLUA_Value = 1
    $PromptOnSecureDesktop_Value = 1
    $EnableVirtualization_Value = 1
    
    Try{
        Write-Verbose "Performing Critical Operation: Writing Values to Registry... `n"
        Set-RegistryValue -Key $Key -Name $FilterAdministratorToken_Name -Value $FilterAdministratorToken_Value -WhatIf -Confirm
        Set-RegistryValue -key $Key -Name $EnableUIADesktopToggle_Name -Value $EnableUIADesktopToggle_Value -WhatIf -Confirm
        Set-RegistryValue -key $Key -name $ConsentPromptBehaviorAdmin_Name -value $ConsentPromptBehaviorAdmin_Value -WhatIf -Confirm
        Set-RegistryValue -key $Key -name $ConsentPromptBehaviorUser_Name -value $ConsentPromptBehaviorUser_Value -WhatIf -Confirm
        Set-RegistryValue -key $Key -name $EnableInstallerDetection_Name -value $EnableInstallerDetection_Value -WhatIf -Confirm
        Set-RegistryValue -key $Key -name $ValidateAdminCodeSignatures_Name -value $ValidateAdminCodeSignatures_Value -WhatIf -Confirm
        Set-RegistryValue -key $Key -name $EnableSecureUIAPaths_Name -value $EnableSecureUIAPaths_Value -WhatIf -Confirm
        Set-RegistryValue -key $Key -name $EnableLUA_Name -value $EnableLUA_Value -WhatIf -Confirm
        Set-RegistryValue -key $Key -name $PromptOnSecureDesktop_Name -value $PromptOnSecureDesktop_Value -WhatIf -Confirm
        Set-RegistryValue -key $Key -name $EnableVirtualization_Name -value $EnableVirtualization_Value -WhatIf -Confirm
    }
    Catch{
        Write-Error $_
        Write-Verbose "Error Writing to Registry - Unable to complete the action" 
    }

}

Export-ModuleMember -Function Get-UACLevel 
Export-ModuleMember -Function Set-SecureUACLevel
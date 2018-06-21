Function Set-DomainPasswordPolicyViaADModule{
    <#
    Created By: Braeden Hopper
    Date: May 8 2018

    .SYNOPSIS 
    Automate Domain policy Deployment and Enforcement => Needed to maintain high security score

    .DESCRIPTION
    By verifying the default policy for the domain we can check the current state of domain policies using the Active Directory Module in powershell
    It should be noted that RSAT must be installed & Enabled on the domain controller and ADLS or ADDS must be enabled 
    Must be run in powershell as Administrator
    This script should be applied to devices that are a part of an Active Directory Domain - I am unsure how a group policy objects interact with these modules but I think these set registry values for an AD Domain they may be over-
    written by OU GPOs that conflict with the settings of this script

    DEPLOYMENT: Run as a Scheduled Task attached to a GPO to ensure this is always maintained
    
    If there is a conflicting GPO applied at OU level or Child OU -> Disable and create a new GPO that enforces these policies 

    .EXAMPLE
    Open Powershell ISE 
    Run Script
    In Powershell Command Line:  
    C:\ > Set-DomainPasswordPolicyViaADModule -Domain "dc=example,dc=com" or
    C:\ > Get-ADDomain -Property DistinguishedName | Set-DomainPasswordPolicyViaADModule
    or add > 
    Set-DomainPasswordPolicyViaADModule -Domain "dc=example,dc=com" 
    to the end of this file

#>
    
    
    [CmdLetBinding(SupportsShouldProcess=$True)] #Enables -WhatIf use on any command
    Param(
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$True)]
        [ValidateNotNull()]
        $Domain
    )

    begin{Write-Verbose "Beginning Function Exe... `n"}

    process{
        Try{
            if ($Domain){

                # Policy Context = PASSWORDS
                $Default_Domain_Policy = Get-ADDefaultDomainPasswordPolicy
                $DC_Psswd_Rep_Policy = Get-ADDomainControllerPasswordReplicationPolicy
                $Fined_Psswd_Policy = Get-ADFineGrainedPasswordPolicy #Possibly NULL 
                $User_Psswd_Policy = Get-ADUserResultantPasswordPolicy

                if ($User_Psswd_Policy.Length -eq 0){
                    Write-Verbose "No User Password Policy | The Default Domain Password Policy is Applied"
                }

                if ($Default_Domain_Policy.Length -ne 0){
        
                    #Domain Policy Exists So lets Verify its Legitimacy
                    if ($Default_Domain_Policy.ComplexityEnabled -eq 'False'){
                        Set-ADDefaultDomainPasswordPolicy -Identity $Domain -ComplexityEnabled True -WhatIf -Confirm
                    }
                    if ($Default_Domain_Policy.MinPasswordLength -lt 8){
                        Set-ADDefaultDomainPasswordPolicy -Identity $Domain -MinPasswordLength 8 -WhatIf -Confirm
                    }
                    if ($Default_Domain_Policy.LockoutThreshold -eq 0){
                        Set-ADDefaultDomainPasswordPolicy -Identity $Domain -LockoutThreshold 9 -WhatIf -Confirm
                    } 
                    if ($Default_Domain_Policy.MaxPasswordAge -gt 90){ #verify formatting before deployment
                        Set-ADDefaultDomainPasswordPolicy -Identity $Domain -MaxPasswordAge 60 -WhatIf -Confirm
                    }
                        if ($Default_Domain_Policy.PasswordHistoryCount -lt 1){ #verify formatting before deployment
                        Set-ADDefaultDomainPasswordPolicy -Identity $Domain -PasswordHistoryCount 24 -WhatIf -Confirm
                    }
                    if ($Default_Domain_Policy.ReversibleEncryptionEnabled -eq 'True'){
                        Set-ADDefaultDomainPasswordPolicy -Identity $Domain -ReversibleEncryptionEnabled $false -WhatIf -Confirm
                    }
                }
            }
        }
        Catch{
            Write-Error $_
        }
    }
    end {Write-Verbose "Function has Terminated... `n"}
 }
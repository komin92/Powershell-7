



Function Enable-AllFirewallProfilesLocally{
    <#
        .SYNOPSIS
        Enables all firewall profiles on a single device
    
        .DESCRIPTION
        This script will verify if all firewall profiles are enabled and if not, it will automatically enable them.
        This script should be added as a LOGON SCRIPT AND ENFORCED THROUGH A GROUP POLICY -> Targeting it too difficult for GPOs in automation, so its best to create the GPO Manually in GPMSC.exe
        
        .EXAMPLE
        Enable-AllFirewallProfiles -Confirm Y

        RUNS ON VISTA AND LATER
    #>



    [CmdLetBinding(ShouldSupportProcess=$True)]
    param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$False
        )][ValidateSet("Y", "y")]
        [string]
        $Confirm
    )
    begin {Write-Verbose "Beginning Function EXE... `n"}
    process{
        Try
        {
            $FirewallProfileStates = Get-NetFirewallProfile | Select Name,Enabled
            ForEach ($Profile in $FirewallProfileStates){
                if ($Profile.Enabled -eq 'False'){
                    $ProfileName = $Profile.Name
                    Set-NetFirewallProfile -Profile $ProfileName -Enabled True
                }
            }
            #$wshell = New-Object -ComObject Wscript.Shell #Wait Notifier
            #$wshell.Popup("Firewalls have been enabled successfully",15,"FIREWALLS ENABLED",48)
        }
        Catch
        {
        #If the above scan didnt work then we need to set the 
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            $wshell = New-Object -ComObject Wscript.Shell #Wait Notifier
            $wshell.Popup($ErrorMessage,15,$FailedItem,48)
            Break
        }
    }
    end {Write-Verbose "Function Exe has Terminated... `n"}
}


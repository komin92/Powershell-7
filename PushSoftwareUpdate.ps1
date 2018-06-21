Function Push-SoftwareUpdate{
    <# 

    .SYNOPSIS
    Installs missing updates

    .DESCRIPTION
    Creates a COM Object to retrieve updates, set approvals and install updates automatically
    Should be deployed as a logon/logoff script through a GPO and run on client machines or for clients not on a domaain -> Update policies will be pushed via Managed Workplace

    .EXAMPLE
    C:\> Push-SoftwareUpdates -Confirm Y

    Version: 1.0 
    Modified By: Braeden Hopper
    Original: http://ahultgren.blogspot.ca/

    #>
    [CmdLetBinding(ShouldSupportProcess=$True)]
    param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$False
        )][ValidateSet("Y", "y")]
        [string]
        $Confirm
    )
    begin {Write-Verbose "Launching Updates... `n"}
    process{
        Try {

            $UpdatePath = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'

            $UpdateSource = Get-ItemProperty $UpdatePath

            if ($UpdateSource.Length -eq 0){
                #If we are here then it means that our update source is a WSUS Server not Windows Server
                #The computer is going to be on a domain 
                Write-Verbose "System Administrator manages updates"
            }
            else {
                $UpdateSession = New-Object -ComObject 'Microsoft.Update.Session'
                $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
                $SearchResult = $UpdateSearcher.Search("IsInstalled=0 and IsHidden=0")
                $RebootRequired = $False

                $Install = New-Object -ComObject 'Microsoft.Update.UpdateColl'
                for($i=0;$i -lt $SearchResult.Updates.Count;$i++) {
                    $Update = $SearchResult.Updates.Item($i)
                    Write-Verbose $Update.Title
                    if($Update.InstallationBehavior.CanRequestUserInput) {
                        Write-Verbose 'CanRequestUserInput True'
                        Continue
                    }
                    if($Update.EulaAccepted -eq $False) {
                        Write-Verbose 'Accepting EULA'
                        $Update.AcceptEula()
                    }
                    if($Update.IsDownloaded) {
                        Write-Verbose 'IsDownloaded'
                        $Install.Add($Update) | Out-Null
                        if($Update.InstallationBehavior.RebootBehavior -gt 0) {
                            $RebootRequired = $True
                        }
                    } else {
                        Write-Verbose 'NotDownloaded'
                    }
                }

                if($Install.Count -eq 0) {
                    Write-Verbose 'No updates to install'
                    break
                }

                $UpdateInstaller = $UpdateSession.CreateUpdateInstaller()
                $UpdateInstaller.Updates = $Install
                $Results = $UpdateInstaller.Install()

                switch($Results.ResultCode)
                    {
                        0 {Write-Verbose "Update Install Not Started"}
                        1 {Write-Verbose "Update Install In Progress"}
                        2 {Write-Verbose "Update Install Succeeded"}
                        3 {Write-Verbose "Update Install Succeeded With Errors!"}
                        4 {Write-Verbose "Update Install Failed!"}
                        5 {Write-Verbose "Update Install Aborted!"}
                    }
        

                If ($RebootRequired) { 

                    Write-Verbose "You have 5 minutes to save. Your computer will begin updating in 5 minutes"   
                    $wshell = New-Object -ComObject Wscript.Shell #Wait Notifier
                    $wshell.Popup("This computer is scheduled for shutdown in 5 minutes for updates",15,"Please Save Your Data Now",48)
                    sleep 300
                    Restart-Computer 
                }
            }
        }


        Catch {
            #For Some Reason the update Failed 
            Write-Error $_
            Write-Verbose "Windows Update Failed PLEASE CONTACT YOUR SYSTEM ADMIN" 
            Write-Warning $_.exception.message
            Write-Verbose $Results.ResultCode
        }
    }
    end {"Update Command Has Terminated... `n"}
}
 <#
    $Results.ResultCode:

    Return Value    Meaning
    0               Not Started
    1               In Progress
    2               Succeeded
    3               Succeeded With Errors
    4               Failed
    5               Aborted
#>

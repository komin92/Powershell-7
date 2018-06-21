<#
    .AUTHOR
    Braeden Hopper

    .SYNOPSIS 
    Quick and simple function to remove a specified update
    Add this script to a logon script and add that to the GPO to assure it is removed for all computers in an OU

#>

Function Rollback-Update {

    [CmdLetBinding(ShouldSupportProcess=$True)]
    param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$False
        )][ValidateNotNullOrEmpty]
        [string]
        $Update
    )
    $Command = "wusa /uninstall /kb" + $Update + "/quiet /norestart"
    Invoke-Expression -Command $Command
    Write-Verbose "Action Completed"
}
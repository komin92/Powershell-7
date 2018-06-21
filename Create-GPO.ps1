Function Create-GPO {
    
<#
    .AUTHOR
    Braeden Hopper 
    May 11 2018

    .SYNOPSIS
    Powershell script to ease creation of Group Policy Objects, to be run on Domain Controller

    .DESCRIPTION
    Creates a GPO using the Group Policy Module in Powershell
    Then links the newly created GPO to a target 
    Fianlly Verifies that the GPO Was successfully created
#>


    [CmdLetBinding(SupportsShouldProcess=$True)]
    Param(
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$False)]
        [ValidateNotNull()]
        [string]
        $Name,

        [Parameter(Mandatory=$True,
        ValueFromPipeline=$False)]
        [ValidateNotNull()]
        [string]
        $Domain,
        
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$False)]
        [ValidateNotNull()]
        [string]
        $Comment,

        [Parameter(Mandatory=$True,
        ValueFromPipeline=$False)]
        [ValidateNotNull()]
        [string]
        $Target,

        [Parameter(Mandatory=$True,
        ValueFromPipeline=$False)]
        [ValidateNotNull()]
        [ValidateSet("Yes","No")]
        [string]
        $Enforced
    )

    begin {Write-Verbose "Executing Task Create-GPO... `n"}

    process {
        Try{
            $GPO = New-GPO -Name $Name -Domain $Domain -Comment $Comment | New-GPLink -Target $Target -LinkEnabled Yes -Domain $Domain -Enforced $Enforced
            $test = Get-GPO -Guid ($GPO.Guid)
            if ($test){
                Write-Verbose "The GPO Was Successfully Created... Verifying GPO attributes"
                if($test.DisplayName -eq $Name){Write-Verbose "DisplayName applied Successfully"}
                else {Write-Verbose "DisplayName application FAILED"}
                if($test.DomainName -eq $Domain){Write-Verbose "Domain applied Successfully"}
                else {Write-Verbose "Domain application FAILED"}
                if($test.Description -eq $Comment){Write-Verbose "Comment applied Successfully"}
                else {Write-Verbose "Comment application FAILED"}
            }
            else{
                Write-Verbose "Error Creating GPO, the GPO is NULL and was not applied"
            }
            Write-Verbose "To Determine if your GPO link was established, please go to the GPO GUI and verify"
        }
        Catch{
            Write-Error $_
        }
    }
    end {Write-Verbose "Function Has Terminated...Exiting `n"}
}
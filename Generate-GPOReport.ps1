 Function Generate-GPOReport {
     <#
        .AUTHOR
        Braeden Hopper
        May 11 2018
     
        .SYNOPSIS 
        Get a Report of all GPOs for a domain or the current domain of the user if none is specified - to be run on the ADDC

        .EXAMPLE
        C:\ > Run Script 
        C:\ > Generate-GPOReport -Filename report [-Domain <FQDN>]
     #>
     
     param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Filename,

        [Parameter(Mandatory=$False)]
        [string]
        $Domain
     )
     begin {Write-Verbose "Generating Report... `n"}
     process{
        
        if($Domain){
            Try{
                Get-GPOReport -Domain $Domain -ReportType HTML -Path $Filename
            }
            Catch{
                Write-Error $_
            }
        }
        else {
            Try{
                Get-GPOReport -All -ReportType HTML -Path $Filename
            }
            Catch{
                Write-Error $_
            }
        }
     }
     end {Write-Verbose "Report Generated" }

 }

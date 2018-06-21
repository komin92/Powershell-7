


Function Set-LocalSecurityPasswordPolicy{
    <#
    .SYNOPSIS 
    Automate Setting of Local Password Policies to better improve 

    .DESCRIPTION
    All users on the device that are NOT part of a domain will have this policy applied to them
    
    
    DEPLOYMENT: This script is for clients not belonging to a domain, so I will have to run this script directly on the client, I will include this script in an automation schedule and run it on the devices through MW

    .EXAMPLE
    C:\ > Set-LocalSecurityPasswordPolicy -Confirm Y
    #>

    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$False
        )][ValidateSet("Y", "y")]
        [string]
        $Confirm
    )
    
    begin {Write-Verbose "Beginning Function exe... `n"}

    process{
        Try{
            if ($Confirm -eq 'Y' -or $Confirm -eq 'y'){

                $LocalAccounts = Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" | Select PSComputername, Name, Status, Disabled, AccountType, Lockout, PasswordRequired, PasswordChangeable, SID
                $UserNames = Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" | Select Name
                $MaxPasswordAge = 90
                $MinPasswordLength = 7


                ForEach ($User in $LocalAccounts){
                    $Name = $User.Name
                    if ($User.Disabled -eq 'True'){
                        Continue
                    }
                    else{
                    #Validate Password
                        if($User.PasswordRequired -eq "False"){
                            $ValidPassword = False
                            while(!($ValidPassword)) {
                                Write-Verbose "Please Enter Your Password: "
                                $Password = Read-Host -AsSecureString
                                Write-Verbose "Please Enter Your Password Again For Verification "
                                $Check = Read-Host -AsSecureString
                                if ($Password -ne $Check){
                                    Write-Host "Failed! Passwords Did NOT Match, Try Again"
                                }
                                else {
                                    Set-LocalUser -Name $Name -Password $Password
                                    Set-LocalUser -Name $Name -PasswordNeverExpires False 
                                    Invoke-Expression "net accounts /MAXPWAGE:60"
                                    Invoke-Expression "net accounts /MINPWLEN:8"
                                    Invoke-Expression "net accounts /lockoutthreshold:9"
                                    Invoke-Expression "net accounts /UNIQUEPW:24"
                                    $ValidPassword = True
                                }
                            } #End While
                        }
                    }   
                } #End For Each
            } #End IF
    
            else {
                Write-Verbose "The -Confirm Option Must state Y or y `n"
            }
        }
        Catch{
            Write-Error $_
        }
    }
    end {Write-Verbose "Function Exe Has Terminated... `n"}
}


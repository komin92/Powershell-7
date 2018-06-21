

Function Set-RDP{
<#

Set this as a logon script enforced via a GPO 


USAGE
---------------------------

C:\> Set-RDP -remote 1
C:\> Set-RDP -remote 0


Supports
---------------------------
Windows XP
Windows Vista
Windows 7
Windows 8
Windows Server 2003 and 2003 R2
Windows Server 2008 and 2008 R2
Windows Server 2012 and 2012 R2

Parameters
----------------------------------
remote 

1 = Enable RDP = Enable the check box so that the script enables RDP on the remote Windows Client
0 = Disable RDP
Common Errors
----------------------------------
1063 - Unable to update Windows registry, RDP settings will not be updated. 

12004 - PowerShell version 1 is installed and not supported.  Please install PowerShell version 2 and run the script again.
#>


    Param(
        [Parameter(Mandatory=$True)] 
        [ValidateRange(0,1)]
	    [int]$remote
    )

    #Get Powershell Version
    $PSVersion = (Get-Host).Version.Major
    #Checking if the Powershell version is valid
    If ($PSVersion -lt 2)
	    {

		    $host.UI.WriteErrorLine('PowerShell version 1 is installed and not supported.  Please install PowerShell version 2 and run the script again.')
		    [Environment]::Exit("12004")
	    }

    #Registry Path
    $registryKey = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server"

    #Registry Value
    $registryValue = $registryKey.fDenyTSConnections


    If ($remote -eq 1)
    {
	    If ($registryValue -eq 0)
	    {
		    Write-Host "Attempting to enable Remote Desktop"
		    Write-Host "Remote Desktop is already enabled, no changes were made to the Windows at this time"		
	    }
	
	    Else
	    {
		    Write-Host "Attempting to enable Remote Desktop"
		    Write-Host "Remote Desktop is currently disabled"
		
		    #Change the Registry Value
		    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-Name "fDenyTSConnections" -Value 0
		    Write-Host "Successfully enabled Remote Desktop"
		
		    $exitCode = 0
		
		    If ($exitCode -ne 0)
		    {
			    $host.UI.WriteErrorLine('Unable to update Windows registry, RDP settings will not be updated. ')
			    [Environment]::Exit("1063")

		    }
	    }

    }
    Elseif ($remote -eq 0)
    {
	    If ($registryValue -eq 1)
	    {
		    Write-Host "Attempting to Disable Remote Desktop"
		    Write-Host "Remote Desktop is already disabled, no changes were made to Windows at this time"
	    }
	    Else
	    {
		    Write-Host "Attempting to disable Remote Desktop"
		    Write-Host "Remote Desktop is currently enabled"
		
		    #Change the Registry Value
		    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-Name "fDenyTSConnections" -Value 1
		    Write-Host "Successfully disabled Remote Desktop"
		
		    $exitCode = 0
		
		    If ($exitCode -ne 0)
		    {
			    $host.UI.WriteErrorLine('Unable to update Windows registry, RDP settings will not be updated. ')
			    [Environment]::Exit("1063")

		    }	
	    }

    }
}

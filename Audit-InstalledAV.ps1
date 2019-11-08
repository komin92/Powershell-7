
#Script Name: Audit-InstalledAV.ps1
#Version : 1.1.20130305
#Created On : 16th April 2014
#Execution : ".\Audit-InstalledAV.ps1"
#Category : 
#Notes  : Server OSs not supported
#Example : ".\Audit-InstalledAV.ps1"
#######################
<#
Parameters
--------------------------------
There are no parameters for this script

Supports Operating Systems
--------------------------------------
Microsoft Windows XP Professional, Microsoft Windows Vista, Microsoft Windows 7, Microsoft Windows 8, Windows 10

Common Error Messages
-------------------------------------
1136 - The detected operating system is (ValueOfOSName) which is not a supported operating system. This script does not support server class operating systems.

11002 - Windows Security Center reports there is no Anti-Virus software installed. 

11003 - Definition files are out of date


12004 - PowerShell version 1 is installed and not supported.  Please install PowerShell 2 and run the script again
#>
#Exit if Powershell version is less than ver.2
if($Host.Version -lt '2.0')
{
	$host.ui.WriteErrorLine('PowerShell version ' + $Host.Version + ' is installed and not supported.  Please install PowerShell version 2 and run the script again.')
	[Environment]::Exit("12004")
}

#Function to determine operating system.
function checkOSCompatibility
{
	$strVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption
	write-host 'Operating System detected is' $strVersion
	if ($strVersion.contains("Server"))
	{
		$host.ui.WriteErrorLine('The detected operating system is ' + $strVersion + ' which is not a supported operating system. This script does not support server class operating systems.')
		[Environment]::Exit("1136")
	}
}	

checkOSCompatibility

$computername=$env:computername

$OSVersion = (Get-WmiObject win32_operatingsystem -computername $computername).version 
$OS = $OSVersion.split(".")


#Post-Vista clients  
function chkAVproductState
{
	# Flag set
	$exitCode = 0
	
	foreach($AVP in $AntiVirusProduct) {  
	
		if($AVP.displayName -eq $null){
		
			$host.ui.WriteErrorLine('Windows Security Center reports there is no anti-virus software installed.')
			[Environment]::Exit("11002")
		}
		
		else {
		
			Write-Host $AVP.displayName 'is installed on the target system'
			
			$intHex = "{0:X0}" -f $AVP.productState
			$strHex = $intHex.Tostring()
			$intSubString = $strHex.Substring(3)

			if ($intSubString -eq "00"){
				Write-Host $AVP.displayName ' definition files are up to date.'
			}
			elseif ($intSubString -eq "10"){
				$host.ui.WriteErrorLine($AVP.displayName + " " + $AVP.versionNumber + ' definition files are out of date.')
				$exitCode = 1
			}
			else{
				$host.ui.WriteErrorLine("Unable to determine if the definition files for " + $AVP.displayName + " " + $AVP.versionNumber + ' are current or out of date. The information is not available via WMI.')
				[Environment]::Exit("11004")
			}
		}
		
	}
	
	If ($exitCode -eq 1)
	{
		[Environment]::Exit("11003")
	}
}

#Pre-Vista clients  
function chkAVproductUpToDate
{
	#Flag Set
	$exitCode = 0

	foreach($AVP in $AntiVirusProduct) {  

		if($AVP.displayName -eq $null){
		
			$host.ui.WriteErrorLine('Windows Security Center reports there is no anti-virus software installed.')
			[Environment]::Exit("11002")
		}
		else {
				Write-Host $AVP.displayName " is installed on the target system."
				
				if ($AVP.productUpToDate -eq "true"){
					Write-Host $AVP.displayName " " $AVP.versionNumber " definition files are up to date."
				}
				elseif ($AVP.productUpToDate -eq "false"){
					$host.ui.WriteErrorLine($AVP.displayName + " " + $AVP.versionNumber + ' definition files are out of date.')
					$exitCode = 1

				}
				else {
					$host.ui.WriteErrorLine("Unable to determine if the definition files for " + $AVP.displayName + " " + $AVP.versionNumber + ' are current or out of date. The information is not available via WMI.')
					[Environment]::Exit("11004")
				}
		}			
	}
	
	If ($exitCode -eq 1)
	{
		[Environment]::Exit("11003")
	}
}

if ($OS[0] -eq "5") 
{ 
	#Get Antivirus data from SecurityCenter.
	$AntiVirusProduct = Get-WmiObject -Namespace root\SecurityCenter -Class AntiVirusProduct  -ComputerName $env:computername
	chkAVproductUpToDate
}

elseif ($OS[0] -eq "6" -or $OS[0] -eq 10) {
	
	#Get Antivirus data from SecurityCenter2.
	$AntiVirusProduct = Get-WmiObject -Namespace root\SecurityCenter2 -Class AntiVirusProduct  -ComputerName $env:computername
	chkAVproductState
}

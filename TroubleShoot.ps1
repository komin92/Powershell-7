<#
    .AUTHOR
    Braeden Hopper

    .SYNOPSIS
    Script for diagnosing generic issues with Windows PC

    .DESCRIPTION
    Covers:
        -Ping Connection to Servers
        -DNS Settings
        -Windows Firewall
#>

### FUNCTIONS ###

Function PingTest {
    
    Write-Host "Gathering network information..."

    $DHCP_Status = (Get-wmiObject Win32_networkAdapterConfiguration | ?{$_.IPEnabled}).DHCPEnabled
    $DefaultGateway = (Get-wmiObject Win32_networkAdapterConfiguration | ?{$_.IPEnabled}).DefaultIPGateway
    $MyIP = (Get-wmiObject Win32_networkAdapterConfiguration | ?{$_.IPEnabled}).IPAddress[0]

    Write-Host "Sending ping from " $MyIP
    Write-Host "Sending ping to default gateway " $DefaultGateway
    Write-Host "`n"
    for ($i=0;$i -lt 5;$i++){
        $PingSuccess = Test-Connection -Source $env:COMPUTERNAME -Destination $DefaultGateway -Count 5
        
        if ($PingSuccess) {
        
            Write-Host "Ping " ($i + 1) " to default gateway successful"
            $rt = ($PingSuccess | Select ResponseTime)
            $rtacc = $rt[$i].ResponseTime
            Write-Host "Ping response time was " $rtacc " ms `n"
        }
        else {
            Write-Host "Ping test to default gateway failed, check the firewall and connection settings "   
        }
    }
}

Function DnsTest {
    
    "" > DNS.txt
    Write-Host "Gathering Network DNS Information..."
    $nsquery = nslookup $env:USERDNSDOMAIN
    $DNS_Domain = $env:USERDNSDOMAIN
    $result = Resolve-DnsName -Name $DNS_Domain -DnsOnly
    Write-Host "Results for resolving dns name : " 
    $result
    Write-Host
    $Domain_Server_IP_List = $result.IPAddress

    #LOGGING
    "Domain: " + $DNS_Domain >> DNS.txt
    "DNS Info : " + $nsquery >> DNS.txt
    "`n" >> DNS.txt
    $result >> DNS.txt
    "`n" >> DNS.txt



    Write-Host "Testing connection (Ping) to Domain Servers..."
    ForEach ($ip in $Domain_Server_IP_List) {

        Write-Host "Sending ping to " $ip
        for ($i=0;$i -lt 5;$i++){

            $PingSuccess = Test-Connection -Source $env:COMPUTERNAME -Destination $ip -Count 5
        
            if ($PingSuccess) {

                $rt = ($PingSuccess | Select ResponseTime)
                $rtacc = $rt[$i].ResponseTime
                Write-Host "Ping " ($i + 1) " to " $ip " was successful"
                Write-Host "Ping response time was " $rtacc " ms `n"

                #LOGGING
                "Ping " + $i + " from " + $env:COMPUTERNAME + " to " + $ip + " took " + $rtacc + " ms `n"  >> DNS.txt


            }
            else {

                Write-Host "Ping test to " $ip " failed, check the firewall and connection settings "   
                "Ping test to " + $ip + " failed, check the firewall and connection settings " >> DNS.txt
            }
        }
    }

}


Function WinFirewallTest {
    "" > WindowsFirewall.txt
    "" > WF_BlockingRules.txt
    "" > WF_AllowingRules.txt
    #Test Windows Firewall
    Write-Host "Gathering Windows Firewall Data...."
    $Win_Firewall = Get-NetFirewallRule
    $Enabled_Rules = @()
    $Blocking_Rules = @()
    $Allow_Rules = @()
    ForEach ($rule in $Win_Firewall) {
        
        $en = $rule.Enabled
        $blk = $rule.Action 
        if ($en -eq $True){
            $Enabled_Rules = $Enabled_Rules + $rule
            if ($blk -eq 'Block'){
                $Blocking_Rules = $Blocking_Rules + $rule
            }
            else {
                $Allow_Rules = $Allow_Rules + $rule
            }
        }
        else{
            continue
        }
    } 
    $Enabled_Rules >> WindowsFirewall.txt
    $Blocking_Rules >> WF_BlockingRules.txt
    $Allow_Rules >> WF_AllowingRules.txt
    Write-Host "Firewall Data logged to text files in this folder..."
    #check blocking on external firewall
    Write-Host "Checking external firewall for blocked ports..."
    Write-Host "Blocked ports: "
    $Extern_Firewall_Blocked_Ports = netstat -ano | findstr -i SYN_SENT
}

### MAIN ###

PingTest
DnsTest
WinFirewallTest
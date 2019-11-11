<#
    .SYNOPSIS 
        Firewall Configuration:
            No incoming connections
            Outgoing only
#>

## Start with Firewall 
Set-NetFirewallProfile -All -Enabled true -ErrorAction Stop
Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True -LogFileName %SystemRoot%\System32\LogFiles\Firewall\pfirewall.log


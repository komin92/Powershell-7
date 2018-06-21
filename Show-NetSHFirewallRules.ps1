<#
    Created By: Braeden Hopper
    Date: May 9 2018

    Purpose of Script: Create a quick script to use a cmdlet-like command that will use NETSHELL to show firewall rules and be able to parse them as a powershell object

#>


Function Show-NetshFireWallrule  {
    Param(
        [String]$RuleName
    )
    if ($RuleName){
        $Rules = netsh advfirewall firewall show rule name="$ruleName"
    }else{
        $Rules = netsh advfirewall firewall show rule name="all"
    }
    
    $return = @()
     $Hash = [Ordered]@{}
        foreach ($Rule in $Rules){
         
            if ($Rule -match '^Rule Name:\s+(?<RuleName>.+$)'){
              $Hash.RuleName = $Matches.RuleName
            }Else{
              if ($Rule -notmatch "----------------------------------------------------------------------"){
                switch -Regex ($Rule){
                    #Little bit of Regex magic
                  '^Rule Name:\s+(?<RuleName>.*$)'{$Hash.RuleName = $Matches.RuleName;Break}
                  '^Enabled:\s+(?<Enabled>.*$)'{$Hash.Enabled = $Matches.Enabled;Break}
                  '^Direction:\s+(?<Direction>.*$)'{$Hash.Direction = $Matches.Direction;Break}
                  '^Profiles:\s+(?<Profiles>.*$)'{$Hash.Profiles = $Matches.Profiles;Break}
                  '^Grouping:\s+(?<Grouping>.*$)'{$Hash.Grouping = $Matches.Grouping;Break}
                  '^LocalIP:\s+(?<LocalIP>.*$)'{$Hash.LocalIP = $Matches.LocalIP;Break}
                  '^RemoteIP:\s+(?<RemoteIP>.*$)'{$Hash.RemoteIP = $Matches.RemoteIP;Break}
                  '^Protocol:\s+(?<Protocol>.*$)'{$Hash.Protocol = $Matches.Protocol;Break}
                  '^LocalPort:\s+(?<LocalPort>.*$)'{$Hash.LocalPort = $Matches.LocalPort;Break}
                  '^RemotePort:\s+(?<RemotePort>.*$)'{$Hash.RemotePort = $Matches.RemotePort;Break}
                  '^Edge traversal:\s+(?<Edge_traversal>.*$)'{$Hash.Edge_traversal = $Matches.Edge_traversal;$obj = New-Object psobject -Property $Hash;$return += $obj;Break}
                  default {Break}
                }
                
                
              }
            }

        }
    

    return $return
}

$AllRules = Show-NetshFireWallrule
$AllRules
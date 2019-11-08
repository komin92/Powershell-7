$reboot_time = (get-eventlog System | where-object {$_.EventID -eq "6005"} | sort -desc TimeGenerated | Select-Object -First 1 -Property TimeGenerated).TimeGenerated.ToString("yyyy-MM-dd HH:mm:ss tt");
$day = Get-Date -Format "yyyy-MM-dd HH:mm:ss tt";
$ts = New-TimeSpan -Start $reboot_time -End $day;
$days_since_reboot = (New-TimeSpan -Start $reboot_time -End $day).Days;
$hours_since_reboot = (New-TimeSpan -Start $reboot_time -End $day).Hours;
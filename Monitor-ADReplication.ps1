$AlertTime = (get-date).AddHours(-6)
$FailedArr = @()
$RepStatus = Get-ADReplicationPartnerMetadata -Target * -Partition * | Select-Object Server, Partition, Partner, ConsecutiveReplicationFailures, LastReplicationSuccess, LastRepicationResult
foreach ($Report in $RepStatus) {
    $Partner = $Report.partner -split "CN="
    if ($report.LastReplicationSuccess -lt $AlertTime) {
        $FailedArr += "$($Report.Server) could not replicate with partner $($Partner[2]) for 6 hours. please investigate"
    }
}
if (!$FailedArr) { $FailedArr = "Healthy" }
$PDCEmulator = (Get-ADDomain).PDCEmulator
$events = Get-WinEvent -ComputerName $PDCEmulator -FilterHashtable @{
    LogName = 'Security'
    ID = 4625
}

$LogonType = @{
    '2' = 'Interactive'
    '3' = 'Network'
    '4' = 'Batch'
    '5' = 'Service'
    '7' = 'Unlock'
    '8' = 'Networkcleartext'
    '9' = 'NewCredentials'
    '10' = 'RemoteInteractive'
    '11' = 'CachedInteractive'
}

foreach ($event in $events) {
    [pscustomobject]@{
        TargetAccount = $event.properties.Value[5]
        LogonType = $LogonType["$($event.properties.Value[10])"]
        CallingComputer = $event.Properties.Value[13]
        IPAddress = $event.Properties.Value[19]
        TimeStamp = $event.TimeCreated
    }
}

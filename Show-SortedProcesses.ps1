Function Show-SortedProcesses {
    Get-Process | Sort -Unique -Property CPU -Descending | Format-Table -AutoSize
}
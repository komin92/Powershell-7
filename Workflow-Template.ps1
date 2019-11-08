Workflow Test-Workflow
{
    Parallel 
    {
        Copy-Item -Path "C:\localPath\item1" -Destination "\\NetworkPath"
        Copy-Item -Path "C:\localPath\item2" -Destination "\\NetworkPath"
        Copy-Item -Path "C:\localPath\item3" -Destination "\\NetworkPath"
        Copy-Item -Path "C:\localPath\item4" -Destination "\\NetworkPath"

    }
    Checkpoint-Workflow #in case of exception do not begin at start of workflow

    $ServiceName = "MyServiceExample"
    InlineScript {
        $Service = Get-Service -Name $Using:ServiceName    # requires the scope modifier to access ServiceName 
        $Service.Stop()    # using this method requires to be done inside inline script (no methods in workflows)
        $Service
    }



}
$url = "https://files.avast.com/iavs9x/avastclear.exe"
$output = "$PSScriptRoot/avastclear.exe"
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
$process = start-process $output -windowstyle Hidden -PassThru -Wait
$output = $process.ExitCode
Write-Output $output
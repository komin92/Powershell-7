$url = "https://files.avast.com/iavs9x/avastclear.exe"
$output = "$PSScriptRoot/avastclear.exe"
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
$args = @("Comma","Separated","Arguments")
Start-Process -Filepath $output -ArgumentList $args
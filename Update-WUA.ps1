$url = "http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/windowsupdateagent-7.6-x64.exe"
New-Item -Path 'c:\cw_automation' -ItemType Directory
$output = "c:\cw_automation\windowsupdateagent.exe"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
Start-Process -Wait -FilePath "c:\cw_automation\windowsupdateagent.exe" -ArgumentList "/S" -PassThru
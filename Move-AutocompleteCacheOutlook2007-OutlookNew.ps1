#In General, comments in code are for those of weak constitution and simple minds, but in case you fall into this description, they have been included. 
<#
This script is used to move Autocomplete Cache from Outlook 2007 
to Outlook 2010/2013/2016/2019
#>

#Go to user profile
#$profile = $env:APPDATA
Set-Location C:\Users\braeden.hopper\Documents\test
$curpath =  $pwd.Path

#See if outlook folder exists
$testpath = "$curpath" + "\microsoft\outlook"
$outlook_bool = Test-Path -Path $testpath

if ($outlook_bool) {
        Set-Location $testpath
        $pst_file_array = Get-ChildItem -Path . -Filter *.pst -File | Sort-Object LastWriteTime -Descending 
        $xml_file_array = Get-ChildItem -Path . -Filter *.xml -File | Sort-Object LastWriteTime -Descending
        
        $most_recent_pst = $pst_file_array[0]
        $most_recent_xml = $xml_file_array[0]

        Write-Host "`n The most recent pst file is" $most_recent_pst -ForegroundColor green -BackgroundColor black
        Write-Host "`n The most recent xml file is" $most_recent_xml -ForegroundColor green -BackgroundColor black

        $pst_path = "$pwd\" + "$most_recent_pst"
        $xml_path = "$pwd\" + "$most_recent_xml"

        Copy-Item -Path $pst_path -Destination $env:HOMEPATH
        Copy-Item -Path $xml_path -Destination $env:HOMEPATH

        #Now we need to kill outlook
        if($process=(get-process 'outlook' -ErrorAction SilentlyContinue))
            {
            Write-Host "`n Outlook is running so close it.." -ForegroundColor green -BackgroundColor black
            kill($process) -Force
            Write-Host "`n Outlook is stopped...Restarting in 5s " -ForegroundColor green -BackgroundColor black
        }
        #Sleep for 5 seconds to wait for outlook to close
        Start-Sleep -Seconds 1
        Write-Host "`n Restarting in 4s" -ForegroundColor green -BackgroundColor black
        Start-Sleep -Seconds 1
        Write-Host "`n Restarting in 3s" -ForegroundColor green -BackgroundColor black
        Start-Sleep -Seconds 1
        Write-Host "`n Restarting in 2s" -ForegroundColor green -BackgroundColor black
        Start-Sleep -Seconds 1
        Write-Host "`n Restarting in 1s" -ForegroundColor green -BackgroundColor black
        Start-Sleep -Seconds 1

        Write-Host "`n Importing nk2 files " -ForegroundColor green -BackgroundColor black
        #Now we can continue and run our nk2 import
        outlook.exe /importnk2

        #Now you can select the newly created Exchange profile when prompted
        Write-Host "`n done" -ForegroundColor green -BackgroundColor black
        Write-Host "
          _____           _                     _____ _______ 
         |  __ \         | |                   |_   _|__   __|
         | |__) |_ _ _ __| |_ _ __   ___ _ __    | |    | |
         |  ___/ _` | '__| __| '_ \ / _ \ '__|    | |    | |
         | |  | (_| | |  | |_| | | |  __/ |     _| |_   | |
         |_|   \__,_|_|   \__|_| |_|\___|_|    |_____|  |_|" -ForegroundColor green -BackgroundColor black
        
}


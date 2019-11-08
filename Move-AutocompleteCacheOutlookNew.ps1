#In General, comments in code are for those of weak constitution and simple minds, but in case you fall into this description, they have been included. 

<#
This script is used to move Autocomplete Cache from Outlook 2010/2013/2016/2019 
to Outlook 2010/2013/2016/2019
#>

#Set-Location $env:APPDATA\Local\Microsoft\Outlook\RoamCache
Set-Location C:\Users\braeden.hopper\Documents\test
$curpath =  $pwd.Path
#See if outlook folder exists
$testpath = "$curpath" + "\microsoft\outlook"
$outlook_bool = Test-Path -Path $testpath

if ($outlook_bool) {
        #Now we need to kill outlook
        if($process=(get-process 'outlook' -ErrorAction SilentlyContinue))
            {
            Write-Host "`n Outlook is running so close it.." -ForegroundColor green -BackgroundColor black
            kill($process) -Force
            Write-Host "`n Outlook is stopped...Proceeding to file rename " -ForegroundColor green -BackgroundColor black
        }
        Set-Location $testpath
        $most_recent_auto 
        $old_auto
        $counter = 0
        $dat_file_array = Get-ChildItem -Path . -Filter *.dat -File | Sort-Object LastWriteTime -Descending 
        $dat_file_array | ForEach-Object {
            if ($counter -eq 0){
                if ($_.Name -match '^Stream_Autocomplete'){
                    $most_recent_auto = $_.Name
                    $counter = 1
                    Write-Host "`n Most recent autocomplete profile is: " $most_recent_auto -ForegroundColor green -BackgroundColor black
                }
            }
            elseif ($counter -eq 1){
                if ($_.Name -match '^Stream_Autocomplete'){
                    $old_auto = $_.Name
                    $counter = 2
                    Write-Host "`n Second-Most recent autocomplete profile is: " $old_auto -ForegroundColor green -BackgroundColor black
                }
            }
            else {
                #skip
            }
        }
        
        #now rename the old file to the new profile name
        mv ".\$most_recent_auto" ".\renamed_new_profile.dat"
        Write-Host "`n Renamed new profile to 'renamed_new_profile'" -ForegroundColor green -BackgroundColor black
        Start-Sleep -Seconds 10
        mv ".\$old_auto" ".\$most_recent_auto"
        Write-Host "Finished renaming files. Old Autocomplete profile is now following the newest naming convention" -ForegroundColor green -BackgroundColor black
        Write-Host "
          _____           _                     _____ _______ 
         |  __ \         | |                   |_   _|__   __|
         | |__) |_ _ _ __| |_ _ __   ___ _ __    | |    | |
         |  ___/ _` | '__| __| '_ \ / _ \ '__|    | |    | |
         | |  | (_| | |  | |_| | | |  __/ |     _| |_   | |
         |_|   \__,_|_|   \__|_| |_|\___|_|    |_____|  |_|" -ForegroundColor green -BackgroundColor black                                                     
} 

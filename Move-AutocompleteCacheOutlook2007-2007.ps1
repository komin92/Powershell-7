#In General, comments in code are for those of weak constitution and simple minds, but in case you fall into this description, they have been included. 

<#
This script is used with Outlook 2007 to move AutoComplete cache 
to a new profile for the same mailbox on the same computer.
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
        $new_nk2
        $old_nk2
        $counter = 0
        $dat_file_array = Get-ChildItem -Path . -Filter *.nk2 -File | Sort-Object LastWriteTime -Descending 
        if ($dat_file_array.Length -gt 2) {
            Write-Error "ERROR! There should not be more than 2 nk2 files in this directory." -ForegroundColor red -BackgroundColor black
        }
        else {
            $new_nk2 = $dat_file_array[0].Name
            $old_nk2 = $dat_file_array[1].Name
            #now rename the old file to the new profile name
            mv ".\$new_nk2" ".\renamed_new_profile.nk2"
            Write-Host "`n Renamed new nk2 file to 'renamed_new_profile'" -ForegroundColor green -BackgroundColor black
            Start-Sleep -Seconds 10
            mv ".\$old_nk2" ".\$new_nk2"
            Write-Host "Finished renaming files. Old Autocomplete profile is now following the newest naming convention" -ForegroundColor green -BackgroundColor black
            Write-Host "
          _____           _                     _____ _______ 
         |  __ \         | |                   |_   _|__   __|
         | |__) |_ _ _ __| |_ _ __   ___ _ __    | |    | |
         |  ___/ _` | '__| __| '_ \ / _ \ '__|    | |    | |
         | |  | (_| | |  | |_| | | |  __/ |     _| |_   | |
         |_|   \__,_|_|   \__|_| |_|\___|_|    |_____|  |_|" -ForegroundColor green -BackgroundColor black
        }
} 
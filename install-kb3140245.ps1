Import-Module BitsTransfer
 
$arch=(Get-WmiObject -Class Win32_operatingsystem).Osarchitecture
 
If ($arch -eq "32-bit") {
    $kbUrl32 = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/04/windows6.1-kb3140245-x86_cdafb409afbe28db07e2254f40047774a0654f18.msu"
    $kb32 = "windows6.1-kb3140245-x86_cdafb409afbe28db07e2254f40047774a0654f18.msu"
    Start-BitsTransfer -source $kbUrl32
    wusa $kb32 /log:install.log
}
Else {
    $kbUrl64 = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/04/windows6.1-kb3140245-x64_5b067ffb69a94a6e5f9da89ce88c658e52a0dec0.msu"
    $kb64 = "windows6.1-kb3140245-x64_5b067ffb69a94a6e5f9da89ce88c658e52a0dec0.msu"
    Start-BitsTransfer -source $kbUrl64
    wusa $kb64 /log:install.log
}
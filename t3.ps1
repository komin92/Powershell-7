$appdata = $env:APPDATA 
$folder = $appdata + '\..\Local\cch\T3 Taxprep 2019\'
$up_folder = $folder +'\updatedt3.txt'
if (Test-Path 'C:\Program Files (x86)\CCH\T3 Taxprep 2019'){
    if (Test-Path $up_folder){
        cd $folder 
        date >> .\already_updatedt3.txt
        "ALREADY UPDATED" >> .\already_updatedt3.txt
        exit
    }
    else {
        cd $folder
        move .\User.Network.ini .\User.Network.old
        $env:USERNAME >> .\updatedt3.txt
        date >> .\updatedt3.txt
        exit
    }
}
else {
    exit
}
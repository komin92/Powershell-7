$service_names = @("CitrixCseEngine", "Citrix Encryption Service", "CritrixTelemetryService", "Citrix EUEM", "ctxProfile")
$printer_names = @("Xerox C70  Main Office B&W", "Xerox C70 Main Office Color", "Xerox Atalink B8045")
$citrix_flag = 0

"Checking Citrix" >> C:\Windows\Temp\cwprinter.txt
foreach ($serv in $service_names){
    If (Get-Service $serv -ErrorAction SilentlyContinue) {
        $serv + " found" >> C:\Windows\Temp\cwprinter.txt
        $citrix_flag = 1
    } 
    Else {
        $serv + " not found" >> C:\Windows\Temp\cwprinter.txt
    }
}

"Checking printers" >> C:\Windows\Temp\cwprinter.txt
$i = 0
foreach ($printer in $printer_names) { 
    $i >> C:\Windows\Temp\cwprinter.txt
    If (Get-Printer -Name $printer -ErrorAction SilentlyContinue){
        #printer mapped
    }
    Else {
        "Printer not mapped" >> C:\Windows\Temp\cwprinter.txt
        If($citrix_flag -eq 0){
            "Critrix Not Present - Adding printer: " + $printer >> C:\Windows\Temp\cwprinter.txt
            Add-Printer -ConnectionName \\AD02\$printer
        }
    }
    $i++
} 
"Exiting Script with printer flag " + $printer_flag >> C:\Windows\Temp\cwprinter.txt


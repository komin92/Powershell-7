Clear-Host
write-host "Your :" -ForegroundColor Cyan -BackgroundColor Black
write-host "Press 1 to A" -ForegroundColor Green  -BackgroundColor Black
write-host "Press 2 to B" -ForegroundColor Yellow -BackgroundColor Black
write-host "Press 3 to C" -ForegroundColor Red    -BackgroundColor Black
$input = read-host "`nEnter Your selection"

switch($input){
    1{}
    2{}
    3{}
    default{write-warning "Invalid option. Goodbye."}
}

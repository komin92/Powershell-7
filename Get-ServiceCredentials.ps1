Get-WmiObject win32_service | format-table name, status, state, exitcode, startname, startmode, pathname 
#dsquery user -inactive 90 > C:\Users\Default\inactive_users.txt
#Get-WmiObject win32_service | format-list *
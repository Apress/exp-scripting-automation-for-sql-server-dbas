# Return a list of running processes and then filter by the name of the process

$process = Get-Process | where {$_.ProcessName -like "*PowerShell*"}


# Print the filtered list of processes to the console

$process

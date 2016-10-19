# Populate a new variable with the details all SQL Server services
$service = Get-Service | where {$_.Name -LIKE "*SQL*" -AND $_.Status -eq "Stopped"}

# Start each service

foreach ($name in $service)
    {
    Start-Service $name 
    }

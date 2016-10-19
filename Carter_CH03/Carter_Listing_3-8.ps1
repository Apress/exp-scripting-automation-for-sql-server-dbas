# Return SQL Server services to a variable, if they are not running

$services = Get-Service | where{$_.Name -like "*SQL*" -and $_.Status -ne "Running" }

# If the variable is non-empty, write a list of services that are not running and force the scruipt to fail

IF ($services.Length -gt 0)
{
     write-warning "Warning! The following Services are not running"
     foreach ($service in $services)
     {
         write-warning $service.Name
     }
    write-error "Please check services and start as required" -EA stop
}

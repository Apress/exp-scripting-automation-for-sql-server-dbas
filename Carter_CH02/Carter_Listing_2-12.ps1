$Service = "SQLBrowser"
$ServiceDetails = get-service | where{$_.Name -eq $Service}

IF ($ServiceDetails.Status -eq "Running") 
        {$Service + " is  working"}
ELSEIF ($ServiceDetails.Status -eq "Stopped") 
        {$Service + " is not working. Please check the Event Log"}
ELSEIF ($Service -notin $ServiceDetails.Name) 
        {$Service + " is not installed"}
ELSE 
        {$Service + " is changing state"}

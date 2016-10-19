Import-Module sqlps

#Get a list of servers to patch

[array]$ServerInstances = invoke-sqlcmd -ServerInstance "ESASSMGMT1"  -Database "Inventory" -Query "SELECT S.ServerName, I.InstanceName 
FROM dbo.Server S
INNER JOIN dbo.Instance I
	ON S.ServerID = I.ServerID
WHERE S.SQLVersion = 'SQL Server 2014 RTM'"

foreach($ServerInstance in $ServerInstances)
{
   #Copy binaries to local server

   Copy-Item -Path "C:\Software Updates\SQLServer2014SP1-KB3058865-x64-ENU.exe" -Destination "\\$ServerInstance.ServerName\c$\" -Force

   #Establish a session to target server

   $session = new-pssession -computername $ServerInstance.InstanceName
   
   #Run setup

   invoke-command -session $session {C:\SQLServer2014SP1-KB3058865-x64-ENU.exe /iacceptsqlserverlicenseterms /instancename=$ServerInstance.InstanceName /UpdateEnabled=False /quiet}
   
   
   #Update inventory database

   invoke-sqlcmd -ServerInstance "ESASSMGMT1" -Database "Inventory" -Query "UPDATE S
   SET SQLVersion = 'SQL Server 2014 SP1'
   FROM dbo.Server S
   INNER JOIN dbo.instance I
       ON S.ServerID = I.ServerID
   WHERE I.InstanceName = '$ServerInstance.InstanceName'"
}

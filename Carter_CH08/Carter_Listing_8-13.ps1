Import-Module sqlps

Invoke-Sqlcmd -ServerInstance "ESASSMGMT1" -Query "
      EXEC sp_configure 'show advanced options', 1
                      GO
                      RECONFIGURE
                      EXEC sp_configure 'clr enabled', 1
                      GO
                      RECONFIGURE"

[Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices")

$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

$sqlConnectionString = "Data Source=ESASSMGMT1;Initial Catalog=master;Integrated Security=SSPI;"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

$integrationServices = New-Object $ISNamespace".IntegrationServices" $sqlConnection

$catalog = New-Object $ISNamespace".Catalog" ($integrationServices, "SSISDB", "Pa££w0rd")
$catalog.Create()

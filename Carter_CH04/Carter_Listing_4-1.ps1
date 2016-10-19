import-module sqlps

$Port = "6152"

[array]$Servers = "ESASSMgmt1", "ESProd1", "ESProd2"

foreach ($Server in $Servers)
{
    $Results = invoke-sqlcmd -ServerInstance "$Server" -User "sa" -Password "Pa$$w0rd" -Query "SELECT *
    FROM (
            SELECT 
            CASE
                    WHEN value_name = 'TcpPort' AND value_data <> ''
                            THEN value_data
                    WHEN value_name = 'TcpPort' AND value_data = ''
                            THEN (
                                    SELECT value_data 
                                    FROM sys.dm_server_registry 
                                    WHERE registry_key LIKE '%ipall' 
                                          AND value_name = 'TcpDynamicPorts' 
							      )
            END PortNumber
            FROM sys.dm_server_registry
            WHERE registry_key LIKE '%IPAll' ) a
    WHERE a.PortNumber IS NOT NULL ;"  

    IF ($Results.PortNumber -ne $Port)
        {
           "The default instace on " + $Server + " is incorrectly configured to listen on Port " + $Results.PortNumber
        }
    
}
"All other instances are correctly cofigured"

clear-host

import-module sqlps

[array]$Servers = "ESASSMgmt1", "ESProd1", "ESProd2"

foreach ($Server in $Servers)
{
    $databases = @(invoke-sqlcmd -serverinstance $server -Query "SELECT name 
                              FROM sys.databases 
                              WHERE database_id > 4 ;") | select-object -expand Name

    foreach ($database in $databases)
    {
        Invoke-Sqlcmd -serverinstance $server -Database $database -QueryTimeout 7200 -Query "
                
                
                DECLARE @SQL NVARCHAR(MAX)
                
                SET @SQL = 
                (
                       SELECT 'ALTER INDEX ' 
                                  + i.name 
                                  + ' ON ' + s.name 
                                  + '.' 
                                  + OBJECT_NAME(i.object_id) 
                                  + ' REBUILD ; '
                       FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,'DETAILED') ps
                       INNER JOIN sys.indexes i
                               ON ps.object_id = i.object_id
                                       AND ps.index_id = i.index_id
                       INNER JOIN sys.objects o
                               ON ps.object_id = o.object_id
                               INNER JOIN sys.schemas s
                                       ON o.schema_id = s.schema_id
                       WHERE index_level = 0
                               AND avg_fragmentation_in_percent > 25
                               FOR XML PATH('')
                ) ;

                EXEC(@SQL) ;" 
    }
    
}

import-module sqlps

[array]$Servers = "ESASSMgmt1", "ESProd1", "ESProd2"

foreach ($Server in $Servers)
{
    $databases = @(invoke-sqlcmd -serverinstance $server -Query "SELECT name 
                              FROM sys.databases 
                              WHERE database_id > 2 
	                            AND is_query_store_on = 1") | select-object -expand Name

    foreach ($database in $databases)
    {
        Invoke-Sqlcmd -serverinstance $server -Database $database -Query "SELECT TOP 5
	            @@SERVERNAME AS ServerName
                ,DB_NAME() AS DatabaseName
                ,qsqt.query_sql_text
	            ,qsp.query_plan
	            ,CAST(AVG(qsrs.avg_duration) AS NUMERIC(10,2)) Avg_Duration
	            ,CAST(AVG(qsrs.avg_cpu_time) AS NUMERIC(10,2)) Avg_CPU
	            ,CAST((AVG(qsrs.avg_cpu_time) / AVG(qsrs.avg_duration)) * 100 AS NUMERIC(5,2)) Avg_CPU_Percent
            FROM sys.query_store_query_text AS qsqt
	            JOIN sys.query_store_query AS qsq 
		            ON qsq.query_text_id = qsqt.query_text_id
	            JOIN sys.query_store_plan AS qsp 
		            ON qsp.query_id = qsq.query_id
	            JOIN sys.query_store_runtime_stats AS qsrs 
		            ON qsrs.plan_id = qsp.plan_id
            WHERE qsq.is_internal_query = 0
	            AND qsp.last_execution_time >= GETUTCDATE() - 7
            GROUP BY qsqt.query_sql_text
		            ,qsp.query_plan	
            ORDER BY AVG(qsrs.avg_cpu_time) ;" > C:\SQLResults.txt 
    }
    
}

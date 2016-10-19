clear-host

import-module sqlps


$databases = @(invoke-sqlcmd -Query "SELECT name 
                              FROM sys.databases 
                              WHERE database_id > 2 
	                            AND is_query_store_on = 1 ;") | select-object -expand Name

foreach ($database in $databases)
{
Invoke-Sqlcmd -Database $database -Query "DECLARE @SQL NVARCHAR(MAX)

SELECT @SQL = 
(
	SELECT 'EXEC sp_query_store_remove_query ' + CAST(qsq.query_id AS NVARCHAR(6)) + ';' AS [data()]
	FROM sys.query_store_query_text AS qsqt
	JOIN sys.query_store_query AS qsq 
		ON qsq.query_text_id = qsqt.query_text_id
	JOIN sys.query_store_plan AS qsp 
		ON qsp.query_id = qsq.query_id
	JOIN sys.query_store_runtime_stats AS qsrs 
		ON qsrs.plan_id = qsp.plan_id
	GROUP BY qsq.query_id
	HAVING SUM(qsrs.count_executions) = 1 
		AND MAX(qsrs.last_execution_time) < DATEADD (HH, -24, GETUTCDATE())
	ORDER BY qsq.query_id 
	FOR XML PATH('')
) ;
EXEC(@SQL) ;" }

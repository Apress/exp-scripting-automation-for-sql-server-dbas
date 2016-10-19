SELECT TOP 5
	qsqt.query_sql_text
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
ORDER BY AVG(qsrs.avg_cpu_time) ;

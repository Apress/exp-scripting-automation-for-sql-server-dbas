USE MDW
GO

SELECT
(
	SELECT TOP 1 log_size_mb     
	FROM snapshots.log_usage
	WHERE database_name = 'MDW'
	ORDER BY collection_time DESC
) 
	-
(
	SELECT TOP 1 log_size_mb
	FROM snapshots.log_usage
	WHERE database_name = 'MDW'
		AND collection_time > DATEADD(MONTH,-1,GETDATE())
	ORDER BY collection_time ASC
) AS LogGrowthInLstMonthMB ;

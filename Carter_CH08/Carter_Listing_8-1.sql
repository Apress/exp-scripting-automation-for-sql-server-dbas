USE MDW
GO

EXEC snapshots.rpt_top_query_stats 
	@instance_name = 'ESASSMGMT1'
	,@order_by_criteria = 'CPU'
	,@database_name = 'MDW' ;

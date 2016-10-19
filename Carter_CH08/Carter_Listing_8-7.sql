DECLARE @collection_set_id INT ;

SET @collection_set_id = (SELECT collection_set_id 
			  FROM msdb..syscollector_collection_sets
			  WHERE Name = 'Chapter8CollectionSet') ;

DECLARE @collector_type_uid UNIQUEIDENTIFIER ;

SET @collector_type_uid = (SELECT collector_type_uid
			   FROM msdb..syscollector_collector_types
			   WHERE name = 'Generic T-SQL Query Collector Type') ;

DECLARE @collection_item_id INT ;

EXEC msdb..sp_syscollector_create_collection_item 
    @name = 'Chapter8CollectorUnusedIndexes', 
    @parameters='<ns:TSQLQueryCollector xmlns:ns="DataCollectorType">
	<Query>
	    <Value>SELECT * 
			FROM sys.dm_db_index_usage_stats
			WHERE	(
						(
						user_seeks  &lt; 10
						AND user_scans  &lt; 10
						AND user_lookups  &lt; 10
						)
					OR 
						(
						last_user_seek  &lt; GETDATE() - 30 
						AND last_user_scan  &lt; GETDATE() - 30 
						AND last_user_lookup  &lt; GETDATE() - 30
						)
					)
					AND database_id > 4
            </Value>
	    <OutputTable>dm_db_index_usage_stats</OutputTable>
	</Query>
	</ns:TSQLQueryCollector>', 
    @collection_item_id = @collection_item_id OUTPUT, 
    @frequency=5, 
    @collection_set_id = @collection_set_id, 
    @collector_type_uid = @collector_type_uid ;

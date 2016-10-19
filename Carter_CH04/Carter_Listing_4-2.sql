SELECT 
		CAST((Clean / 
			(SELECT CAST(COUNT(*) AS FLOAT) 
			FROM sys.dm_os_buffer_descriptors b 
			WHERE page_type IN 
                           ('DATA_PAGE', 'INDEX_PAGE', 'TEXT_MIX_PAGE'))) * 100. AS DECIMAL(4,2)
			) AS Clean_Percentage
		, CAST((
			Dirty / 
			(SELECT CAST(COUNT(*) AS FLOAT) 
			FROM sys.dm_os_buffer_descriptors b 
			WHERE page_type IN 
                           ('DATA_PAGE', 'INDEX_PAGE', 'TEXT_MIX_PAGE'))) * 100. AS DECIMAL(4,2)
			) AS Dirty_Percentage
FROM
(
    SELECT 'Count' as is_modified
	    , [0] AS Clean
	    , [1] AS Dirty
    FROM
    (
     SELECT is_modified, 1 AS Page_Count
     FROM sys.dm_os_buffer_descriptors
     WHERE page_type IN ('DATA_PAGE', 'INDEX_PAGE', 'TEXT_MIX_PAGE')
         AND database_id > 4 ) SourceTable
     PIVOT 
         (
	  COUNT(Page_Count)
	  FOR is_modified IN ([0], [1])
	 ) AS PivotTable
) a ;

USE MDW
GO

SELECT
	 [statement]
	,COUNT(*) AS NumberOfPageSplits
FROM custom_snapshots.page_splits
GROUP BY [statement] ;

USE MDW
GO

CREATE PROCEDURE core.DisableLowUseIndexes
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)

	SET @SQL = (
	SELECT 'ALTER INDEX ' + i.name + ' ON ' + SCHEMA_NAME(t.schema_id) + '.' + OBJECT_NAME(i.object_id) + ' DISABLE ;'[data()]
	FROM custom_snapshots.dm_db_index_usage_stats ius
	INNER JOIN sys.indexes i
		ON ius.object_id = i.object_id
			AND ius.index_id = i.index_id
	INNER JOIN sys.tables t
		ON i.object_id = t.object_id
	WHERE i.type = 2
		AND i.is_disabled = 0
		FOR XML PATH('')
	)

	EXEC(@SQL)
END

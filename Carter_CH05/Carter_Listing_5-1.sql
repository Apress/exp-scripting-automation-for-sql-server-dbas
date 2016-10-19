DECLARE @SQL NVARCHAR(MAX) ;

DECLARE @SQLXML XML ;

CREATE TABLE #TEST

(

    ParentObject	NVARCHAR(16),

    [Object]		NVARCHAR(32),

    Field		NVARCHAR(32),

    VALUE		NVARCHAR(128)

) ;

SELECT @SQL = (

    SELECT 'INSERT INTO #TEST(ParentObject, [Object], Field, Value) EXEC(''DBCC PAGE ('

        + CAST(database_id AS NVARCHAR(3))

        + ','

        + CAST(file_id AS NVARCHAR(16))

        + ','

        + CAST(page_id AS NVARCHAR(32))

        + ',0) WITH TABLERESULTS''); ' AS [data()]

    FROM msdb.dbo.suspect_pages

    WHERE event_type NOT IN (4,5)

    FOR XML PATH('')

) ;

EXEC(@SQL) ;

CREATE TABLE #CorruptTables

(

    DatabaseName NVARCHAR(128),

    TableName NVARCHAR(128)

) ;

SELECT @SQL = (

    SELECT 'INSERT INTO #CorruptTables SELECT DISTINCT ''' + db_name(database_id) + ''' DatabaseName, t.Name TableName FROM '

        + DB_NAME(database_id)

        + '.sys.tables t INNER JOIN #TEST tt ON tt.VALUE = t.object_id AND tt.field = ''Metadata: ObjectId'' INNER JOIN #TEST tt2 ON tt2.Object = tt.Object WHERE (SELECT VALUE FROM #test WHERE field = ''bdbid'' AND object = (SELECT object FROM #test WHERE field = ''bpage'' AND VALUE = SUBSTRING(tt2.object,7,len(tt2.object)-6)	) ) = '

        + CAST(database_id AS NVARCHAR(4)) AS [data()]

    FROM msdb.dbo.suspect_pages

    WHERE event_type NOT IN (4,5)

    FOR XML PATH('')

) ;

EXEC(@SQL) ;

SELECT *

FROM #CorruptTables ;

DROP TABLE #test ;

DROP TABLE #CorruptTables ;

"USE " +  @[$Project::DatabaseName] + " GO
DECLARE @SQL NVARCHAR(MAX)
 
SET @SQL = (
SELECT 'DROP USER ' + QUOTENAME(name) + ' ; '
FROM sys.database_principals
WHERE type = 'S'
       AND authentication_type = 0
       AND principal_id > 4
FOR XML PATH('')
) ;
 
EXEC(@SQL)"

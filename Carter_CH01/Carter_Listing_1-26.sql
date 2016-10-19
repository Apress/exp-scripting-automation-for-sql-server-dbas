DECLARE @SQL NVARCHAR(MAX) ;

SELECT DISTINCT @SQL = 
(
    SELECT 'Kill ' + CAST(session_id AS NVARCHAR(4)) AS [data()]
    FROM sys.dm_exec_sessions
    WHERE session_id <> @@SPID
        AND is_user_process = 1
    FOR XML PATH('')
) ;

EXEC(@SQL) ;  

DECLARE @session_id INT ;

DECLARE C_Sessions CURSOR
FOR
    SELECT Session_id
    FROM sys.dm_exec_sessions
    WHERE session_id <> @@SPID
        AND is_user_process = 1 ;

OPEN C_Sessions ;

FETCH NEXT FROM C_Sessions
INTO @Session_id ;

DECLARE @SQL NVARCHAR(MAX) ;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'Kill ' + CAST(@Session_id AS NVARCHAR(4)) ;
    EXEC(@SQL) ;
    FETCH NEXT FROM C_Sessions
    INTO @Session_id ;
END

CLOSE C_Sessions ;

DEALLOCATE C_Sessions ;   

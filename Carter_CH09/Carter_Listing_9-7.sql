--Create a table to store log entries

CREATE TABLE #ErrorLog
(
LogDate		DATETIME,
ProcessInfo	NVARCHAR(128),
Text		NVARCHAR(MAX)
) ;

--Populate table with log entries

INSERT INTO #ErrorLog
EXEC('xp_readerrorlog') ;

--Declare variables

DECLARE @SQL NVARCHAR(MAX) ;
DECLARE @DBName NVARCHAR(128) ;
DECLARE @LogName NVARCHAR(128) ;
DECLARE @Subject	NVARCHAR(MAX) ;

--Find database name where error occured

SET @DBName = (
				SELECT TOP 1
						SUBSTRING(
							SUBSTRING(
								Text,
								35,
								LEN(Text)
							),
							1,
								CHARINDEX(
									'''',
									SUBSTRING(Text,
										35,
										LEN(Text)
									) 
								)-1
						) 
					FROM #ErrorLog
					WHERE Text LIKE 'The transaction log for database%'
					ORDER BY LogDate DESC
					FOR XML PATH('')
) ;

--Find name of log file that is full

SET @LogName = (
				SELECT name
				FROM sys.master_files
				WHERE type = 1
					AND database_id = DB_ID(@DBName)
) ;

--Kill any active queries, to allow clean up to take place

SET @SQL = (
				SELECT 'USE Master; KILL ' + CAST(s.session_id AS NVARCHAR(4)) + ' ; '
	FROM sys.dm_exec_requests r
		INNER JOIN sys.dm_exec_sessions s
			ON r.session_id = s.session_id
		INNER JOIN sys.dm_tran_active_transactions at
			ON r.transaction_id = at.transaction_id
	WHERE r.database_id = DB_ID(@DBName)
	) ;

	EXEC(@SQL) ;

--IF recovery model is SIMPLE

IF (SELECT recovery_model FROM sys.databases WHERE name = @DBName) = 3
BEGIN
		--Issue a CHECKPOINT
		SET @SQL = (
		SELECT 'USE ' + @DBName + ' ; CHECKPOINT'
	) ;

	EXEC(@SQL) ;

	--Shrink the transaction log

	SET @SQL = (
				SELECT 'USE ' + @DBName + ' ; DBCC SHRINKFILE (' + @LogName + ' , 1)'
	) ;

	EXEC(@SQL) ;

	--e-mail the DBA Team

	SET @Subject = (SELECT '9002 Errors on ' + @DBName + ' on Server ' + @@SERVERNAME)

	EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'ESASS Administrator',
    @recipients = 'DBATeam@ESASS.com',
    @body = 'A CHECKPOINT has been issued and the Log has been shrunk',
    @subject = @Subject ;
END

--If database in full recovery model

IF (SELECT recovery_model FROM sys.databases WHERE name = @DBName) = 1
BEGIN
	--If reuse delay is not because of replication or mirroring/availability groups

	IF (SELECT log_reuse_wait FROM sys.databases WHERE name = @DBName) NOT IN (5,6)
	BEGIN 
		--Backup transaction log

		SET @SQL = (
					SELECT 'BACKUP LOG ' 
					+ @DBName 
					+ ' TO  DISK = ''C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\' 
					+ @DBName 
					+ '.bak'' WITH NOFORMAT, NOINIT,  NAME = ''' 
					+ @DBName
					+ '-Full Database Backup'', SKIP ;'
		) ;

		EXEC(@SQL) ;

		--Shrink the transaction log

		SET @SQL =  (
					SELECT 'USE ' + @DBName + ' ; DBCC SHRINKFILE (' + @LogName + ' , 1)'
		) ;

		EXEC(@SQL) ;

		--e-mail the DBA Team

		SET @Subject = (SELECT '9002 Errors on ' + @DBName + ' on Server ' + @@SERVERNAME) ;

		EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'ESASS Administrator',
		@recipients = 'DBATeam@ESASS.com',
		@body = 'A Log Backup has been issued and the Log has been shrunk',
		@subject = @Subject ;
	END
	--If reuse delay is because of replication or mirroring/availability groups

	ELSE
	BEGIN
		--e-mail DBA Team
		SET @Subject = (SELECT '9002 Errors on ' + @DBName + ' on Server ' + @@SERVERNAME) ;

		EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'ESASS Administrator',
		@recipients = 'DBATeam@ESASS.com',
		@body = 'DBA intervention required - 9002 errors due to HA/DR issues',
		@subject = @Subject ;
	END
END

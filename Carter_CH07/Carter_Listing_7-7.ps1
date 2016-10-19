param(
[string] $InstanceName,
[string] $InstanceWorkload #The expected workload of the instance
)

$ServerInstance = $env:COMPUTERNAME + "\" + $InstanceName

IF ($InstanceWorkload -eq "Data Warehouse")
{
    Invoke-Sqlcmd -Server $ServerInstance -Query "--Configure Model
    
USE Model
GO
    
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = ON;
GO

ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8
    
USE [msdb]
GO

EXEC  msdb.dbo.sp_add_job @job_name='ConfigureNewDatabase', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name='[Uncategorized (Local)]', 
		@owner_login_name='ESPROD3\Pete'

GO


EXEC msdb.dbo.sp_add_jobstep @job_name='ConfigureNewDatabase', @step_name='ConfigureDatabase', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem='TSQL', 
		@command='DECLARE @DatabaseName AS NVARCHAR(128)
DECLARE @SQL AS NVARCHAR(MAX)
SET @DatabaseName = (
	SELECT TOP 1 name 
	FROM sys.databases 
	ORDER BY create_date DESC
	)

IF @DatabaseName IS NOT NULL
BEGIN
    SELECT @sql = ''ALTER DATABASE '' + @DatabaseName + '' MODIFY FILEGROUP [PRIMARY] AUTOGROW_ALL_FILES''
    EXEC(@SQL)
END', 
		@database_name='master', 
		@flags=0
GO

EXEC msdb.dbo.sp_add_jobserver @job_name='ConfigureNewDatabase', @server_name = @@SERVERNAME
GO

--Create the trigger

CREATE TRIGGER ConfigureNewDatabase
ON ALL SERVER
FOR CREATE_DATABASE
AS 
    EXEC msdb..sp_start_job 'ConfigureNewDatabase'   
GO"
}

IF ($InstanceWorkload -eq "OLTP")
{
     Invoke-Sqlcmd -Server $ServerInstance -Query "--Configure Model
     
USE Model
GO
    
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8

USE [msdb]
GO

EXEC  msdb.dbo.sp_add_job @job_name='ConfigureNewDatabase', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name='[Uncategorized (Local)]', 
		@owner_login_name='ESPROD3\Pete'

GO


EXEC msdb.dbo.sp_add_jobstep @job_name='ConfigureNewDatabase', @step_name='ConfigureDatabase', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem='TSQL', 
		@command='DECLARE @DatabaseName AS NVARCHAR(128)
DECLARE @SQL AS NVARCHAR(MAX)
SET @DatabaseName = (
	SELECT TOP 1 name 
	FROM sys.databases 
	ORDER BY create_date DESC
	)

IF @DatabaseName IS NOT NULL
BEGIN
    SELECT @sql = ''ALTER DATABASE '' + @DatabaseName + '' SET MIXED_PAGE_ALLOCATION ON''
    EXEC(@SQL)
END', 
		@database_name='master', 
		@flags=0
GO

EXEC msdb.dbo.sp_add_jobserver @job_name='ConfigureNewDatabase', @server_name = @@SERVERNAME
GO

--Create the trigger

CREATE TRIGGER ConfigureNewDatabase
ON ALL SERVER
FOR CREATE_DATABASE
AS 
    EXEC msdb..sp_start_job 'ConfigureNewDatabase'   
GO"
}

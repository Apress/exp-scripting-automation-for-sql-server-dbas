USE msdb
GO

EXEC  msdb.dbo.sp_add_job @job_name='DisableLowUseIndexes', 
		@enabled=1, 
		@category_name='[Uncategorized (Local)]', 
		@owner_login_name='ESASSMGMT1\SQLServiceAccount' ;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name='DisableLowUseIndexes', 
		@server_name = 'ESASSMGMT1'
GO

EXEC msdb.dbo.sp_add_jobstep @job_name='DisableLowUseIndexes', 
		@step_name='DisableLowUseIndexes', 
		@step_id=1, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem='TSQL', 
		@command='EXEC custom_snapshots.DisableLowUseIndexes', 
		@database_name='MDW', 
		@flags=0 ;
GO

EXEC msdb.dbo.sp_update_job @job_name='DisableLowUseIndexes', 
		@enabled=1, 
		@start_step_id=1, 
		@category_name='[Uncategorized (Local)]', 
		@owner_login_name='ESASSMGMT1\SQLServiceAccount' ;
GO

EXEC msdb.dbo.sp_add_jobschedule @job_name='DisableLowUseIndexes', 
		@name='DisableLowUseIndexes', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20160516, 
		@active_end_date=99991231, 
		@active_start_time=220000, 
		@active_end_time=235959 ;
GO

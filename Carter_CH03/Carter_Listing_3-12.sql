USE msdb
GO

EXEC msdb.dbo.sp_add_jobschedule 
		  @job_name = 'CheckServices'
		, @name = 'Daily'
		, @enabled = 1
		, @freq_type = 4
		, @freq_interval = 1
		, @freq_subday_type = 1
		, @freq_subday_interval = 0
		, @freq_relative_interval = 0
		, @freq_recurrence_factor = 1
		, @active_start_date = 20160101
		, @active_end_date = 99991231
		, @active_start_time = 0
		, @active_end_time = 235959 ;
GO

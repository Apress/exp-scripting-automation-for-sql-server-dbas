USE msdb
GO

EXEC  msdb.dbo.sp_add_job 
		  @job_name = 'CheckServices'
		, @enabled = 1
		, @notify_level_email = 2
		, @category_name = '[Uncategorized (Multi-Server)]'
		, @owner_login_name = 'sa'
		, @notify_email_operator_name = 'MSXOperator' ;
GO

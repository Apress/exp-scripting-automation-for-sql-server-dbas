USE msdb
GO

EXEC msdb.dbo.sp_add_jobserver 
		  @job_name = 'CheckServices'
		, @server_name = 'ESPROD1' ;
GO

EXEC msdb.dbo.sp_add_jobserver 
		  @job_name = 'CheckServices'
		, @server_name = 'ESPROD2' ;
GO

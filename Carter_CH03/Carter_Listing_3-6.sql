USE msdb
GO

EXEC msdb.dbo.sp_add_proxy 
	    @proxy_name = 'WinUserProxy'
	  , @credential_name = 'WinUserCredential'
	  , @enabled = 1 ;
GO

EXEC msdb.dbo.sp_grant_proxy_to_subsystem 
	    @proxy_name = 'WinUserProxy'
	  , @subsystem_name = 'PowerShell' ;
GO

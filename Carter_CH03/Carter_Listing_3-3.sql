USE Master
GO

EXEC xp_regwrite
  @rootkey = N'HKEY_LOCAL_MACHINE'
 ,@key = N'Software\Microsoft\Microsoft SQL Server\MSSQL13.MSSQLSERVER\SQLServerAgent'
  -- If you have a default instance, the instance name is MSSQLSERVER by default
 ,@value_name = N'AllowDownloadedJobsToMatchProxyName'
 ,@type = N'REG_DWORD'
 ,@value = 1 ;

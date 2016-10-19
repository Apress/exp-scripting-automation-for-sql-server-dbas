EXEC xp_regwrite
  @rootkey='HKEY_LOCAL_MACHINE'
  ,@key = N'Software\Microsoft\Microsoft SQL Server\MSSQL13.MSSQLSERVER\SQLServerAgent'
  -- If you have a default instance, the instance name is MSSQLSERVER by default
  ,@value_name='MsxEncryptChannelOptions'
  ,@type='REG_DWORD'
  ,@value= 0 ;

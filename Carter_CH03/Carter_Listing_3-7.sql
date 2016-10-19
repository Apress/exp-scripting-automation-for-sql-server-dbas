:connect ESASSMgmt1

USE MSDB
GO

EXEC msdb.dbo.sp_add_operator 
		  @name = 'MSXOperator2'
		, @enabled = 1
		, @email_address = 'SQLAdmin@ESASS.com' ;

EXEC sp_msx_enlist 
        @msx_server_name = 'ESASSMgmt1'
      , @location = 'NTAM - MGMT network block' ;

:connect ESProd1

USE MSDB
GO

sp_msx_enlist 
        @msx_server_name = 'ESASSMgmt1'
      , @location = 'NTAM - PROD network block' ;

:connect ESProd2

USE MSDB
GO

sp_msx_enlist 
        @msx_server_name = 'ESASSMgmt1'
      , @location = 'NTAM - PROD network block' ;

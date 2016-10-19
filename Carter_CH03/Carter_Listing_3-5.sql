USE master
GO

CREATE CREDENTIAL WinUserCredential 
	WITH IDENTITY = 'ESASS\WinServiceAccount'
	, SECRET = 'Pa$$w0rd'
GO

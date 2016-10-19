USE Inventory
GO

DECLARE @ServerId	INT ;

INSERT INTO dbo.Server (ServerName, ClusterFlag, WindowsVersion, SQLVersion, ServerCores, ServerRAM, VirtualFlag, Hypervisor, ApplicationOwner, ApplicationOwnerEMail)
VALUES ('ESPRODSQL14_001', 0, 'Windows Server 2012 SP1', 'SQL Server 2014 RTM', 4, 128, 0, NULL, NULL, NULL) ;

SET @ServerID = @@IDENTITY ;

INSERT INTO dbo.Instance (InstanceName, ServerID, Port, IPAddress, SQLServiceAccountID, AuthenticationMode, saAccountName, saAccountPassword, InstanceClassification, InstanceCores, InstanceRAM, SQLServerAgentAccountID)
VALUES ('SQL14INSTANCE1', @ServerId, 50001, '10.2.2.5', 1, 1, 'sa', 'Pa$$w0rd', 1, 2, 64, 1),
       ('SQL14INSTANCE2', @ServerId, 50002, '10.2.2.6', 1, 1, 'sa', 'Pa$$w0rd', 1, 2, 64, 1) ;

CREATE DATABASE Inventory
GO

USE Inventory
GO

--Create the ServiceAccount table

CREATE TABLE [dbo].[ServiceAccount]
(
    [ServiceAccountID] INT NOT NULL IDENTITY PRIMARY KEY, 
    [ServiceAccountName] NVARCHAR(128) NOT NULL UNIQUE,

) ;

GO

--Create the Server table

CREATE TABLE [dbo].[Server]
(
    [ServerID] INT NOT NULL IDENTITY PRIMARY KEY, 
    [ServerName] NVARCHAR(128) NOT NULL UNIQUE, 
    [ClusterFlag] BIT NOT NULL, 
    [WindowsVersion] NVARCHAR(64) NOT NULL, 
    [SQLVersion] NVARCHAR(64) NOT NULL, 
    [ServerCores] TINYINT NOT NULL, 
    [ServerRAM] BIGINT NOT NULL, 
    [VirtualFlag] BIT NOT NULL, 
    [Hypervisor] BIT NULL, 
    [ApplicationOwner] NVARCHAR(256) NULL, 
    [ApplicationOwnerEMail] NVARCHAR(512) NULL

) ;

GO

--Create the DRServer table

CREATE TABLE [dbo].[DRServer]
(
    [DRServerID] INT NOT NULL IDENTITY , 
    [ServerID] INT NOT NULL, 
    CONSTRAINT [FK_DRServer_ToServer] 
        FOREIGN KEY ([ServerID]) REFERENCES [Server]([ServerID]), 
    PRIMARY KEY ([DRServerID], [ServerID])
) ;

GO
--Create the DRInstance table

CREATE TABLE [dbo].[DRInstance]
(
    [DRInstanceID] INT NOT NULL IDENTITY PRIMARY KEY, 
    [DRInstanceName] NVARCHAR(128) NOT NULL UNIQUE, 
    [DRServerID] INT NOT NULL, 
	[ServerID] INT NOT NULL,
    [DRTechnology] NVARCHAR(128) NOT NULL, 
    [TargetRPO] TINYINT NOT NULL, 
    [TargetPTO] TINYINT NOT NULL, 
    CONSTRAINT [FK_DRInstance_ToDRServer] 
        FOREIGN KEY ([DRServerID], [ServerID]) REFERENCES [DRServer]([DRServerID],[ServerID])
) ;

GO

--Create the Instance table

CREATE TABLE [dbo].[Instance]
(
    [InstanceID] INT NOT NULL IDENTITY  PRIMARY KEY, 
    [InstanceName] NVARCHAR(128) NOT NULL UNIQUE, 
    [ServerID] INT NOT NULL, 
    [Port] NVARCHAR(8) NOT NULL, 
    [IPAddress] NVARCHAR(15) NOT NULL, 
    [SQLServiceAccountID] INT NOT NULL, 
    [AuthenticationMode] BIT NOT NULL, 
    [saAccountName] NVARCHAR(128) NULL, 
    [saAccountPassword] NVARCHAR(64) NULL, 
    [InstanceClassification] TINYINT NOT NULL, 
    [InstanceCores] TINYINT NOT NULL, 
    [InstanceRAM] BIGINT NOT NULL, 
    [SQLServerAgentAccountID] INT NOT NULL, 
    CONSTRAINT [FK_Instance_ToServer] 
        FOREIGN KEY ([ServerID]) REFERENCES [Server]([ServerID]), 
    CONSTRAINT [FK_Instance_SQL_ToServiceAccount] 
        FOREIGN KEY ([SQLServiceAccountID]) REFERENCES [ServiceAccount]([ServiceAccountID]), 
    CONSTRAINT [FK_Instance_Agent_ToServiceAccount] 
       FOREIGN KEY ([SQLServerAgentAccountID]) REFERENCES [ServiceAccount]([ServiceAccountID])
) ;
GO 

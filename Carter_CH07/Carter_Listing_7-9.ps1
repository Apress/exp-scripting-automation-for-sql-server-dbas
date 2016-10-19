param(
[string] $InstanceName,
[string] $SQLServiceAccount,
[string] $InstanceType,
[string] $VMFlag,
[string] $Hypervisor,
[string] $ApplicationOwner,
[string] $ApplicationOwnerEmail,
[string] $saAccount,
[string] $saAccountPassword
)

import-module sqlps

#Get Windows Version
[string]$WindowsVersion = Get-CimInstance Win32_OperatingSystem | Select-Object  caption 
$WindowsVersion = $WindowsVersion.substring(10,$WindowsVersion.Length-11)

#Get ServerName
$ServerName = $env:COMPUTERNAME

#Get SQL Version, LoginMode, InstanceCores, InstanceRAM, PortNumber

$ServerInstance = $env:COMPUTERNAME #+ "\" + $ServerInstance

$SQLVersion = invoke-sqlcmd -ServerInstance $ServerInstance -Query "SELECT SUBSTRING(@@VERSION,1,CHARINDEX(')',@@VERSION)) AS Version" | Select-Object -expand Version

$LoginMode = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database "Master" -Query "CREATE TABLE #LoginMode
(
Value	NVARCHAR(128),
Data	TINYINT
)
INSERT INTO #LoginMode
EXEC xp_instance_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode'
GO

SELECT Data
FROM #LoginMode" | Select-Object -expand Data

$InstanceCores = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query "SELECT  COUNT(*) AS Cores
FROM sys.dm_os_schedulers
WHERE status = 'VISIBLE ONLINE'" | Select-Object -expand Cores

$InstanceRAM = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query "SELECT value 
FROM sys.configurations
where name = 'max server memory (MB)'" | Select-Object -expand Value

$PortNumber = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query "
DECLARE       @Port   NVARCHAR(8)

CREATE TABLE #PortNumber
(
PortNumber	NVARCHAR(8)
)


EXEC   xp_instance_regread
@rootkey    = 'HKEY_LOCAL_MACHINE'
,@key        = 'Software\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Tcp\IpAll'
,@value_name = 'TcpPort'
,@value      = @Port OUTPUT

INSERT INTO #PortNumber   
SELECT @Port

  
EXEC   xp_instance_regread
@rootkey    = 'HKEY_LOCAL_MACHINE'
,@key        = 'Software\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Tcp\IpAll'
,@value_name = 'TcpDynamicPorts'
,@value      = @Port OUTPUT
  

INSERT INTO #PortNumber   
SELECT @Port

SELECT PortNumber
FROM #PortNumber
WHERE PortNumber IS NOT NULL

DROP TABLE #PortNumber" | Select-Object -expand PortNumber

foreach ($Version in $SQLVersion)
{
[string]$SQLVersionShred = $SQLVersion.Version 
}


foreach ($Mode in $LoginMode)
{
$LoginModeShred = $LoginMode.Data
}

foreach ($Core in $InstanceCores)
{
[string]$InstanceCoresShred = $InstanceCores.Cores
}

foreach ($RAM in $InstanceRAM)
{
[string]$InstanceRAMShred = $InstanceRAM.Value
}

foreach ($Port in $PortNumber)
{
[string]$PortNumberShred = $PortNumber.PortNumber
}

#Get Server Cores
[string]$NoOfCores = Get-WmiObject –class Win32_processor | SELECT NumberOfCores
$ServerCores = $NoOfCores.Substring($NoOfCores.IndexOf("=") + 1,$NoOfCores.Length-$NoOfCores.IndexOf("=")-2)

#Get Server RAM
$ServerRAMarray = Get-WmiObject -class Win32_physicalmemory | SELECT capacity 

$ServerRAM = ($ServerRAMarray.capacity | Measure-Object -Sum).sum

#Get IP Address
[string]$IPAddress = Get-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "IPv4" | SELECT IPAddress
$IPAddress = $IPAddress.Substring(12,$IPAddress.Length-13)


#Insert into Inventory database
Invoke-Sqlcmd -ServerInstance "ESPROD3" -Database "Inventory" -Query "BEGIN TRANSACTION
    BEGIN TRY    
	    DECLARE @ServerIdentityTbl TABLE(ID INT)
	    DECLARE @ServiceAccountIdentityTbl TABLE(ID INT)

        DECLARE @ServiceAccountIdentity INT
        DECLARE @ServerIdentity INT

	    MERGE ServiceAccount AS Target
        USING(SELECT '$($SQLServiceAccount)' AS SQLServiceAccount) AS Source
            ON (Target.ServiceAccountName = Source.SQLServiceAccount)
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (ServiceAccountName)
            VALUES (Source.SQLServiceAccount)
        OUTPUT inserted.ServiceAccountID INTO @ServiceAccountIdentityTbl(ID);
        
        SET @ServiceAccountIdentity = (SELECT ID FROM @ServiceAccountIdentityTbl)

        IF @ServiceAccountIdentity IS NULL
        BEGIN
            SET @ServiceAccountIdentity = (SELECT ServiceAccountID FROM ServiceAccount WHERE ServiceAccountName = '$($SQLServiceAccount)')
        END

        MERGE dbo.Server AS Target
        USING (SELECT '$($ServerName)' AS ServerName) AS Source
            ON (Target.ServerName = Source.ServerName)
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (ServerName, ClusterFlag, WindowsVersion, SQLVersion, ServerCores, ServerRAM, VirtualFlag, Hypervisor, ApplicationOwner, ApplicationOwnerEmail)
            VALUES('$($ServerName)',0,'$($WindowsVersion)','$($SQLVersion)','$($ServerCores)','$($ServerRAM)','$($VirtualFlag)','$($Hypervisor)','$($ApplicationOwner)','$($ApplicationOwnerEmail)')
        OUTPUT inserted.ServerID INTO @ServerIdentityTbl(ID);

	    SET @ServerIdentity = (SELECT ID FROM @ServerIdentityTbl)

        IF @ServerIdentity IS NULL
        BEGIN
            SET @ServerIdentity = (SELECT ServerID FROM dbo.Server WHERE ServerName = '$($ServerName)')
        END
        

	    INSERT INTO dbo.Instance(InstanceName, ServerID, Port, IPAddress, SQLServiceAccountID, AuthenticationMode, saAccountName, saAccountPassword, InstanceClassification, InstanceCores, InstanceRAM, SQLServerAgentAccountID)
	    VALUES('$($InstanceName)',@ServerIdentity,'$($Port)','$($IPAddress)',@ServiceAccountIdentity,'$($LoginMode)','$($saAccount)','$($saAccountPassword)','$($InstanceType)','$($InstanceCores)','$($InstanceRAMShred)',@ServiceAccountIdentity)
    
        COMMIT
    END TRY
    BEGIN CATCH
        THROW
        ROLLBACK
    END CATCH"

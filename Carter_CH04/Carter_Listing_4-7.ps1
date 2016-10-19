import-module sqlps

[array]$Servers = "ESASSMgmt1", "ESProd1", "ESProd2"

foreach ($Server in $Servers)
{
    invoke-sqlcmd -ServerInstance "$Server" -Query "IF 
        (
		    --Check if xp_cmdshell is enabled
		    SELECT value_in_use 
		    FROM sys.configurations
		    WHERE name = 'xp_cmdshell'
	    ) = 1
    BEGIN
	    --Turn on advanced options
	    EXEC sp_configure 'show advanced options', 1 ;
	    RECONFIGURE

	    --Turn off xp_cmdshell
	    EXEC sp_configure 'xp_cmdshell', 0 ;
	    RECONFIGURE

    END"  
}

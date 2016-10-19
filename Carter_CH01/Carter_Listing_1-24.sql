SELECT TOP 5
    CAST(p.query_plan AS XML)
    , CAST(p.query_plan AS XML).value('declare namespace 
            qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
                            (//qplan:Object/@Schema)[1]','nvarchar(128)') 
        + '.'
        + CAST(p.query_plan AS XML).value('declare namespace 
            qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
                            (//qplan:Object/@Table)[1]','nvarchar(128)') AS [Table]
    , CAST(p.query_plan AS XML).query('declare namespace 
            qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
                            //qplan:Object') AS TableDetails
    , rs.count_executions
    , rs.avg_duration
    , rs.avg_physical_io_reads
    , rs.avg_cpu_time
FROM sys.query_store_runtime_stats rs
INNER JOIN sys.query_store_plan p
        ON p.plan_id = rs.plan_id
WHERE CAST(p.query_plan AS XML).exist('declare namespace 
            qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
                            //qplan:RelOp[@LogicalOp="Index Scan"
                            or @LogicalOp="Clustered Index Scan"
                            or @LogicalOp="Table Scan"]') = 1
      AND CAST(p.query_plan AS XML).exist('declare namespace 
            qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
                            //qplan:Object[@Schema="[sys]"]') = 0
      AND CAST(p.query_plan AS XML).exist('declare namespace 
            qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
                            //qplan:Object[@Schema="[dbo]"]') = 0
ORDER BY rs.count_executions * rs.avg_duration DESC ;  

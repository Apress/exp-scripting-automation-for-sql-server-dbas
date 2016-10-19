SELECT
    CAST(query_plan AS XML).query('declare namespace 
            qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
                                 //qplan:ColumnReference') AS SQLStatement
FROM sys.query_store_plan ;  

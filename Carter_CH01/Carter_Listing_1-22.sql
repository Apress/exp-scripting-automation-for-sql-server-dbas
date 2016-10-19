SELECT
    plan_id
    ,nodes.query_plan.value('@Table[1]', 'nvarchar(128)') AS TableRef
    ,nodes.query_plan.value('@Column[1]', 'nvarchar(128)') AS ColumnRef
FROM
(
    SELECT plan_id, CAST(query_plan AS XML) query_plan_xml
    FROM sys.query_store_plan
) base
CROSS APPLY query_plan_xml.nodes('declare namespace 
            qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
                        //qplan:ColumnReference') as nodes(query_plan) ;  

SELECT
    plan_id
    ,nodes.query_plan.value('@Table[1]', 'nvarchar(128)') AS index1
    ,nodes.query_plan.value('@Column[1]', 'nvarchar(128)') AS index2
FROM
(
    SELECT plan_id, CAST(query_plan AS XML) query_plan_xml
    FROM sys.query_store_plan
) base
CROSS APPLY query_plan_xml.nodes('declare namespace 
            qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan"; //qplan:ColumnReference') as nodes(query_plan)
WHERE query_plan_xml.exist('declare namespace 
        qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
                //qplan:Object[@Schema="[sys]"]') = 0
AND query_plan_xml.exist('declare namespace 
        qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
              //qplan:Object[@Schema="[dbo]"]') = 0 ;  

SELECT 
shred.value('(/event/action[@name="database_name"]/value)[1]', 'nvarchar(128)')  AS database_name
,shred.value('(/event/data[@name="object_name"]/value)[1]', 'nvarchar(128)') AS [object_name]
,shred.value('(/event/data[@name="statement"]/value)[1]', 'nvarchar(max)') AS [statement]
,shred.value('(/event/action[@name="nt_username"]/value)[1]', 'nvarchar(128)') AS nt_username
FROM
(
    SELECT CAST(event_data AS XML) event_data
    FROM sys.fn_xe_file_target_read_file('C:\pagesplits\pagesplits*.xel', NULL , NULL, NULL) 
) base
CROSS APPLY event_data.nodes('/event') as vnode(shred) 
WHERE shred.value('(/event/@timestamp)[1]', 'datetime2(7)') > DATEADD(MINUTE,-30,SYSUTCDATETIME()) ;

SELECT s.session_id
       ,s.login_time
       ,s.login_name
       ,s.is_user_process
       ,[text]
FROM sys.dm_exec_sessions s
INNER JOIN sys.dm_exec_requests r
    ON r.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text(sql_handle) ;  

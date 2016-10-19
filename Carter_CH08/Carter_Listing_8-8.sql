CREATE EVENT SESSION PageSplits
ON SERVER
--Add the module_start event
ADD EVENT sqlserver.module_start(SET collect_statement=(1)
--Add actions to the module_start event
ACTION(sqlserver.database_name, sqlserver.nt_username)),
--Add the page_split event
ADD EVENT sqlserver.page_split()
--Add the event_file target
ADD TARGET package0.event_file(SET FILENAME='c:\PageSplits\PageSplits',max_file_size=(512))
WITH (MAX_MEMORY=4096 KB, 
		EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
		MAX_DISPATCH_LATENCY=30 SECONDS, 
		MAX_EVENT_SIZE=0 KB, 
		MEMORY_PARTITION_MODE=NONE,
		TRACK_CAUSALITY=ON, 
		STARTUP_STATE=ON) ;
GO

--Start the session
ALTER EVENT SESSION PageSplits
ON SERVER
STATE = START;

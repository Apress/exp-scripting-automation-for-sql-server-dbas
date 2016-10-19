USE MDW
GO

SET IDENTITY_INSERT core.source_info_internal ON

INSERT INTO core.source_info_internal (source_id, collection_set_uid,instance_name,days_until_expiration,operator)
VALUES (-1, NEWID(), 'ESASSMGMT1', 30, 'CustomProcess') ;

SET IDENTITY_INSERT core.source_info_internal OFF


SET IDENTITY_INSERT core.snapshot_timetable_internal ON

INSERT INTO core.snapshot_timetable_internal (snapshot_time_id,snapshot_time)
VALUES (-1, SYSUTCDATETIME()) ;

SET IDENTITY_INSERT core.snapshot_timetable_internal OFF


SET IDENTITY_INSERT core.snapshots_internal ON

INSERT INTO core.snapshots_internal (snapshot_id,snapshot_time_id,source_id,log_id)
VALUES (-1,-1, -1, -1) ;

SET IDENTITY_INSERT core.snapshots_internal OFF

CREATE TABLE custom_snapshots.page_splits
(
ID			INT		IDENTITY	PRIMARY KEY,
database_name		NVARCHAR(128),
object_name		NVARCHAR(128),
statement		NVARCHAR(128),
nt_username		NVARCHAR(MAX),
collectionTime		DATETIMEOFFSET(7),
snapshot_id		INT DEFAULT (-1)
) ;

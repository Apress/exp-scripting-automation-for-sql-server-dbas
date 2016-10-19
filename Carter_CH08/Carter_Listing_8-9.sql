USE MDW
GO

CREATE TABLE custom_snapshots.page_splits
(
ID			INT		IDENTITY	PRIMARY KEY,
database_name		NVARCHAR(128),
object_name		NVARCHAR(128),
statement		NVARCHAR(MAX),
nt_username		NVARCHAR(128),
collection_time		DATETIMEOFFSET(7)
) ;

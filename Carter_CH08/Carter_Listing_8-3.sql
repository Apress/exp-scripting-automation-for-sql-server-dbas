USE msdb;
GO

DECLARE @Collection_Set_ID INT

EXEC dbo.sp_syscollector_create_collection_set
    @name = 'Chapter8CollectionSet',
    @collection_mode = 0,
    @days_until_expiration = 90,
    @description = 'Collection set used for Chapter 8',
    @logging_level = 2,
    @schedule_name = 'CollectorSchedule_Every_30min' ,
    @collection_Set_ID = @collection_set_id OUTPUT ;

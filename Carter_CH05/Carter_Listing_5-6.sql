SELECT ServerName
FROM ##Servers ;

--The temporary table only needs to be dropped when you are simulating an inventory database

DROP TABLE ##Servers ;

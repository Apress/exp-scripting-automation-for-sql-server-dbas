Import-Module sqlps

sl SQLSERVER:\SQL\ESASSMgmt1\MASTERSERVER\DATABASES\ADVENTUREWORKS2016\TABLES

dir | where{$_.name -like "*DatabaseLog*"}

rename-item -LiteralPath dbo.DatabaseLog -NewName DatabaseLogPS

dir | where{$_.name -like "*DatabaseLog*"}

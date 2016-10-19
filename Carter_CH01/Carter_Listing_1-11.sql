SELECT
    SalesOrder.CustomerID
    ,SalesOrder.OrderDate
    ,SalesOrder.SalesOrderID
    ,LineItem.UnitPrice
    ,LineItem.OrderQty
    ,Product.Name
FROM Sales.SalesOrderHeader SalesOrder
INNER JOIN Sales.SalesOrderDetail LineItem
    ON SalesOrder.SalesOrderID = LineItem.SalesOrderID
    INNER JOIN Production.Product Product
        ON LineItem.ProductID = Product.ProductID
WHERE SalesOrder.CustomerID = 29825
    AND SalesOrder.OrderDate < '2012-01-01'
FOR XML RAW ('LineItem'), ELEMENTS, ROOT('SalesOrders') ;  

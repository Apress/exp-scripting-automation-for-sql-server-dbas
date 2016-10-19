SELECT
    CustomerID 'OrderHeader/CustID'
    ,OrderDate 'OrderHeader/OrderDate'
    ,SalesOrderID 'OrderHeader/SalesID'
    ,(
        SELECT
            SOD2.ProductID '@ProductID'
            ,P.Name '@Name'
            ,UnitPrice '@Price'
            ,OrderQty '@Qty'
        FROM Sales.SalesOrderDetail SOD2
        INNER JOIN Production.Product P
             ON SOD2.ProductID = P.ProductID
        WHERE SOD2.SalesOrderID = Base.SalesOrderID
        FOR XML PATH('Product'), TYPE
    ) 'OrderDetails'
FROM 
    (
        SELECT DISTINCT 
            SalesOrder.CustomerID
            ,SalesOrder.OrderDate
            ,SalesOrder.SalesOrderID
        FROM Sales.SalesOrderHeader SalesOrder
        INNER JOIN Sales.SalesOrderDetail LineItem
            ON SalesOrder.SalesOrderID = LineItem.SalesOrderID
        WHERE SalesOrder.CustomerID = 29825
            AND SalesOrder.OrderDate < '2012-01-01'
    ) Base
FOR XML PATH('Order'), ROOT ('SlesOrders') ;  

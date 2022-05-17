--1
/*
WITH CustomerOrders(CustomerID, SalesOrderID, Amount)
AS (
    SELECT soh.CustomerID, soh.SalesOrderID, COUNT(*) AS Amount FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    GROUP BY soh.CustomerID, soh.SalesOrderID
)
SELECT co.CustomerID, AVG(CAST(Amount AS FLOAT)) FROM CustomerOrders AS co
GROUP BY co.CustomerID
ORDER BY co.CustomerID
*/

--2
/*
WITH CustomerProducts(CustomerID, ProductID, Amout)
AS (
    SELECT soh.CustomerID, sod.ProductID, COUNT(*) AS Amount FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    GROUP BY soh.CustomerID, sod.ProductID
),
Customer (CustomerID, Amout)
AS (
    SELECT soh.CustomerID, COUNT(*) AS Amount FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    GROUP BY soh.CustomerID
)
SELECT cp.CustomerID, cp.ProductID, 1.0 * cp.Amout / c.Amout FROM CustomerProducts AS cp
JOIN Customer AS c 
ON cp.CustomerID = c.CustomerID
*/

--3
/*
WITH ProductSales(ProductID, SalesAmount)
AS (
    SELECT sod.ProductID, COUNT(*) AS SalesAmount FROM Sales.SalesOrderDetail AS sod
    GROUP BY sod.ProductID
),
ProductCustomers(ProductID, CustomersAmount)
AS (
    SELECT sod.ProductID, COUNT(DISTINCT soh.CustomerID) AS CustomersAmount FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    GROUP BY sod.ProductID
)
SELECT ps.ProductID, ps.SalesAmount, pc.CustomersAmount FROM ProductSales AS ps
JOIN ProductCustomers AS pc 
ON ps.ProductID = pc.ProductID
ORDER BY ps.SalesAmount - pc.CustomersAmount DESC
*/

--4
/*
WITH CustomerOrders(CustomerID, SalesOrderID, Money)
AS (
    SELECT soh.CustomerID, sod.SalesOrderID, SUM(sod.UnitPrice * sod.OrderQty) AS Money FROM Sales.SalesOrderDetail AS sod
    JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY soh.CustomerID, sod.SalesOrderID
)
SELECT co.CustomerID, MAX(co.Money) AS Max, MIN(co.Money) AS Min FROM CustomerOrders AS co
GROUP BY co.CustomerID
*/

--5
/*
WITH CustomerOrders(CustomerID, SalesOrderID, Amount)
AS (
    SELECT soh.CustomerID, sod.SalesOrderID, COUNT(*) AS Amount FROM Sales.SalesOrderDetail AS sod
    JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID  
    GROUP BY soh.CustomerID, sod.SalesOrderID
)
SELECT co.CustomerID FROM CustomerOrders AS co
GROUP BY co.CustomerID
HAVING COUNT(DISTINCT co.Amount) = COUNT(co.Amount)
*/

--6
WITH CustomerOrders(CustomerID, ProductID, Amount)
AS (
    SELECT soh.CustomerID, sod.ProductID, COUNT(*) AS Amount FROM Sales.SalesOrderDetail AS sod
    JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID  
    GROUP BY soh.CustomerID, sod.ProductID
)
SELECT co.CustomerID FROM CustomerOrders AS co
GROUP BY co.CustomerID
HAVING MIN(co.Amount) > 1
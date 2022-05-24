--1
SELECT 
    sod.SalesOrderID, 
    sod.ProductID,
    (sod.UnitPrice * sod.OrderQty) / SUM(sod.UnitPrice * sod.OrderQty) OVER (PARTITION BY sod.SalesOrderID) AS "Part"
FROM 
    Sales.SalesOrderDetail AS sod

--2
SELECT
    p.Name,
    p.ListPrice,
    p.ListPrice - MIN(p.ListPrice) OVER (PARTITION BY ProductSubcategoryID) AS "Diff"
FROM 
    Production.Product AS p

--3
SELECT 
    soh.SalesOrderID, 
    soh.CustomerID,
    soh.OrderDate,
    ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS "Row number"
FROM 
    Sales.SalesOrderHeader AS soh;

--4
WITH ProductSubcaregoryAVG(ProductID, Average)
AS (
    SELECT 
        p.ProductID,
        AVG(p.ListPrice) OVER (PARTITION BY ProductSubcategoryID) AS "Average"
    FROM 
        Production.Product AS p
)
SELECT
    p.Name,
    p.ProductSubcategoryID,
    p.ListPrice,
    pscAVG.Average
FROM 
    Production.Product AS p
JOIN
    ProductSubcaregoryAVG AS pscAVG ON pscAVG.ProductID = p.ProductID
WHERE p.ListPrice > pscAVG.Average;


WITH DateNumber(ProductID, Amount, DateNumber)
AS (
    SELECT 
        sod.ProductID,
        sod.OrderQty,
        ROW_NUMBER() OVER (
            PARTITION BY sod.ProductID 
        ORDER BY soh.OrderDate DESC)
    FROM Sales.SalesOrderDetail AS sod
    JOIN Sales.SalesOrderHeader AS soh ON soh.SalesOrderID = sod.SalesOrderID
)
SELECT p.ProductID, p.Name, AVG(dn.Amount) AS "Last 3 AVG"
FROM Production.Product AS p
JOIN DateNumber AS dn ON dn.ProductID = p.ProductID
WHERE dn.DateNumber <= 3
GROUP BY p.ProductID, p.Name
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

--extra 1
WITH CategoryCounter(CustomerID, Amount)
AS (
    SELECT soh.CustomerID, COUNT(DISTINCT psc.ProductCategoryID)
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product AS p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory AS psc ON psc.ProductSubcategoryID = p.ProductSubcategoryID
    GROUP BY soh.CustomerID
),
ProductCategoryCounter(CustomerID, ProductCategoryID, Amount)
AS (
    SELECT soh.CustomerID, psc.ProductCategoryID, COUNT(DISTINCT sod.ProductID)
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product AS p ON sod.ProductID = p.ProductID
    JOIN CategoryCounter AS cc ON cc.CustomerID = soh.CustomerID
    JOIN Production.ProductSubcategory AS psc ON psc.ProductSubcategoryID = p.ProductSubcategoryID
    WHERE cc.Amount > 1
    GROUP BY soh.CustomerID, psc.ProductCategoryID
)
SELECT 
    pcc.CustomerID, 
    pcc.ProductCategoryID, 
    pcc.Amount * 1.0 / (SUM(Amount) OVER (PARTITION BY pcc.CustomerID) - Amount)
FROM ProductCategoryCounter AS pcc
--1
/*
SELECT p.Name FROM Production.Product AS p
WHERE p.ProductID = (
    SELECT TOP 1 sod.ProductID FROM Sales.SalesOrderDetail AS sod
    GROUP BY sod.ProductID
    ORDER BY COUNT(*) DESC
)
*/

--2
/*
SELECT soh0.CustomerID FROM Sales.SalesOrderHeader AS soh0
WHERE soh0.SalesOrderID = (
    SELECT TOP 1 soh.SalesOrderID
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
    GROUP BY soh.SalesOrderID
    ORDER BY SUM(sod.UnitPrice * sod.OrderQty) DESC
)
*/

--3
/*
SELECT p.ProductID FROM Production.Product AS p
WHERE p.ProductID IN (
    SELECT sod.ProductID FROM Sales.SalesOrderDetail AS sod
    JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY sod.ProductID
    HAVING COUNT(distinct soh.CustomerID) = 1
)
*/

--4
/*SELECT p1.Name FROM Production.Product AS p1
WHERE p1.ListPrice > (
    SELECT AVG(p2.ListPrice) FROM Production.Product AS p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
    GROUP BY p2.ProductSubcategoryID
)
*/

--5
/*SELECT p.Name FROM Sales.SalesOrderDetail AS sod
JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product AS p ON p.ProductID = sod.ProductID
WHERE soh.CustomerID IN (
    SELECT soh1.CustomerID FROM Sales.SalesOrderDetail AS sod1
    JOIN Sales.SalesOrderHeader AS soh1 ON sod1.SalesOrderID = soh1.SalesOrderID
    JOIN Production.Product AS p1 ON sod1.ProductID = p1.ProductID
    WHERE p1.Color is not null
    GROUP BY soh1.CustomerID
    HAVING COUNT(DISTINCT p1.Color) = 1
)
GROUP BY p.Name
HAVING COUNT(DISTINCT soh.SalesPersonID) > 1
*/

--6
/*
SELECT DISTINCT SOD1.ProductID FROM Sales.SalesOrderHeader AS SOH1
JOIN Sales.SalesOrderDetail AS SOD1 ON SOH1.SalesOrderID = SOD1.SalesOrderID
WHERE EXISTS (
    SELECT SOH2.CustomerID FROM Sales.SalesOrderHeader AS SOH2
    JOIN Sales.SalesOrderDetail AS SOD2 ON SOH2.SalesOrderID = SOD2.SalesOrderID
    GROUP BY SOH2.CustomerID
    HAVING COUNT(DISTINCT soh2.SalesOrderID) = (
        SELECT TOP 1 COUNT(*) FROM Sales.SalesOrderHeader AS SOH3
        JOIN Sales.SalesOrderDetail AS SOD3 ON SOH3.SalesOrderID = SOD3.SalesOrderID
        WHERE SOH2.CustomerID = SOH3.CustomerID
        GROUP BY SOD3.ProductID
        ORDER BY COUNT(*) DESC
    )
)
*/

--7
/*
SELECT SOH2.CustomerID FROM Sales.SalesOrderHeader AS SOH2
JOIN Sales.SalesOrderDetail AS SOD2 ON SOH2.SalesOrderID = SOD2.SalesOrderID
GROUP BY SOH2.CustomerID
HAVING COUNT(DISTINCT soh2.SalesOrderID) = (
    SELECT TOP 1 COUNT(*) FROM Sales.SalesOrderHeader AS SOH3
    JOIN Sales.SalesOrderDetail AS SOD3 ON SOH3.SalesOrderID = SOD3.SalesOrderID
    WHERE SOH2.CustomerID = SOH3.CustomerID
    GROUP BY SOD3.ProductID
    ORDER BY COUNT(*) DESC
) 
*/

--8
/*
SELECT DISTINCT SOD1.ProductID FROM Sales.SalesOrderHeader AS SOH1
JOIN Sales.SalesOrderDetail AS SOD1 ON SOH1.SalesOrderID = SOD1.SalesOrderID
GROUP BY SOD1.ProductID
HAVING COUNT(DISTINCT SOH1.CustomerID) <= 3
*/

--11
/*
SELECT soh1.SalesOrderID FROM Sales.SalesOrderHeader AS soh1
JOIN Sales.SalesOrderDetail AS sod1 ON soh1.SalesOrderID = sod1.SalesOrderID 
GROUP BY soh1.SalesOrderID
HAVING COUNT(*) = (
    SELECT soh2.SalesOrderID FROM Sales.SalesOrderHeader AS soh2
    JOIN Sales.SalesOrderDetail AS sod2 ON soh2.SalesOrderID = sod2.SalesOrderID 
    WHERE soh1.SalesOrderID = soh2.SalesOrderID AND (
        SELECT COUNT(*) FROM Sales.SalesOrderHeader AS soh3
        JOIN Sales.SalesOrderDetail AS sod3 ON soh3.SalesOrderID = sod3.SalesOrderID 
        WHERE sod2.ProductId = sod3.ProductID
        GROUP BY soh3.CustomerID
    ) = 2
)
*/

--13
/*
SELECT ps1.ProductSubcategoryID FROM Production.ProductSubcategory AS ps1
JOIN Production.Product AS p1 ON p1.ProductSubcategoryID = ps1.ProductSubcategoryID
WHERE p1.ProductID = (
    SELECT p2.ProductID FROM Production.ProductSubcategory AS ps2
    JOIN Production.Product AS p2 ON p2.ProductSubcategoryID = ps2.ProductSubcategoryID
    JOIN Sales.SalesOrderDetail AS sod2 on sod2.ProductID = p2.ProductID
    WHERE p2.ProductID = p1.ProductID
    GROUP BY p2.ProductID
    HAVING COUNT(*) > 3
)
GROUP BY ps1.ProductSubcategoryID
HAVING COUNT(*) > 3
*/

SELECT soh1.CustomerID, soh1.SalesOrderID, COUNT(*) FROM Sales.SalesOrderHeader AS soh1
JOIN Sales.SalesOrderDetail AS sod1 ON soh1.SalesOrderID = sod1.SalesOrderID
GROUP BY soh1.CustomerID, soh1.SalesOrderID
ORDER BY COUNT(*) DESC
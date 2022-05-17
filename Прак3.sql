--1
SELECT p.Name, s.Name 
FROM Production.Product AS p
JOIN Production.ProductSubcategory AS s
ON p.ProductSubcategoryID = s.ProductSubcategoryID
WHERE p.Color = 'Red' AND p.ListPrice >= 100

--2
SELECT s1.Name, s2.Name 
FROM Production.ProductSubcategory AS s1
JOIN Production.ProductSubcategory AS s2
ON s1.ProductSubcategoryID=s2.ProductSubcategoryID
WHERE s1.Name = s2.Name AND s1.ProductSubcategoryID != s2.ProductSubcategoryID

--3
SELECT pc.Name, COUNT(*) AS 'Amount'
FROM Production.Product AS p
JOIN Production.ProductSubcategory AS psc
JOIN Production.ProductCategory AS pc
ON pc.ProductCategoryID = psc.ProductCategoryID
ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY pc.Name

--4
/*
Странная таска
*/

--5
SELECT TOP 3 psc.Name, COUNT(*) AS 'Amount'
FROM Production.Product AS p
JOIN Production.ProductSubcategory AS psc
ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY psc.Name
ORDER BY COUNT(*) DESC

--6
SELECT TOP 1 psc.Name, MAX(p.ListPrice) AS 'Price'
FROM Production.Product AS p
JOIN Production.ProductSubcategory AS psc
ON p.ProductSubcategoryID = psc.ProductSubcategoryID
WHERE p.Color = 'Red'
GROUP BY psc.Name
ORDER BY MAX(p.ListPrice) DESC

--7
SELECT v.Name, COUNT(*) AS 'Amount'
FROM Purchasing.ProductVendor AS pv
JOIN Purchasing.Vendor AS v
ON v.BusinessEntityID = pv.BusinessEntityID
GROUP BY v.Name

--8
SELECT p.Name, COUNT(*) AS 'Amount'
FROM Purchasing.ProductVendor AS pv
JOIN Production.Product AS p
ON pv.ProductID = p.ProductID
GROUP BY p.Name

--9
SELECT TOP 1 p.Name
FROM Production.Product AS p
JOIN Sales.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID
GROUP BY p.Name
ORDER BY COUNT(*) DESC

--10
SELECT TOP 1 pc.Name, COUNT(*)
FROM Sales.SalesOrderDetail AS sod
JOIN Production.ProductCategory AS pc
JOIN Production.Product AS p
JOIN Production.ProductSubcategory AS psc
ON psc.ProductSubcategoryID = p.ProductSubcategoryID
ON pc.ProductCategoryID = psc.ProductCategoryID
ON p.ProductID = sod.ProductID
GROUP BY pc.Name
ORDER BY COUNT(*) DESC

--11
SELECT pc.Name, COUNT(psc.Name) AS 'SubCategories' INTO t1
FROM Production.ProductSubcategory AS psc
JOIN Production.ProductCategory AS pc
ON pc.ProductCategoryID = psc.ProductCategoryID
GROUP BY pc.Name

SELECT pc.Name, COUNT(*) AS 'Products' INTO t2
FROM Production.Product AS p
JOIN Production.ProductSubcategory AS psc
JOIN Production.ProductCategory AS pc
ON pc.ProductCategoryID = psc.ProductCategoryID
ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY pc.Name

SELECT P.Name, R.*, G.* FROM Production.ProductCategory AS P, t1 AS R, t2 AS G
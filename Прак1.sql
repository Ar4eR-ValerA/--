--1
SELECT Name, Color, Size
FROM Production.Product

--2
SELECT Name, Color, Size
FROM Production.Product
WHERE ListPrice > 100

--3
SELECT Name, Color, Size
FROM Production.Product
WHERE ListPrice < 100 AND Color = 'Black'

--4
SELECT Name, Color, Size
FROM Production.Product
WHERE ListPrice < 100 AND Color = 'Black'
ORDER BY ListPrice

--5
SELECT TOP 3 Name, Size
FROM Production.Product
WHERE Color = 'Black'
ORDER BY ListPrice DESC

--6
SELECT Name, Color
FROM Production.Product
WHERE Color IS NOT NULL AND Size IS NOT NULL

--7
SELECT DISTINCT Color
FROM Production.Product
WHERE ListPrice >= 10 AND ListPrice <= 50

--8
SELECT Color
FROM Production.Product
Where Name LIKE 'L_N%'

--9
SELECT Name
FROM Production.Product
WHERE Name LIKE '[D, M]%' AND LEN(Name) > 3

--10
SELECT Name
FROM Production.Product
WHERE DATEPART(YEAR, SellStartDate) <= 2012

--11
SELECT Name
FROM Production.ProductSubcategory

--12
SELECT Name
FROM Production.ProductCategory

--13
SELECT FirstName
FROM Person.Person
WHERE Title = 'Mr.'


--14

SELECT FirstName
FROM Person.Person
WHERE Title IS NULL

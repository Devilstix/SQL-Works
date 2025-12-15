SELECT
	Name
    , Weight
FROM production_product
WHERE 
	Weight > 100;

SELECT
	productID, 
	name,
    ListPrice
FROM production_product
ORDER BY ListPrice DESC
LIMIT 10;

SELECT
	name
FROM person_countryregion
WHERE name LIKE 'C%';

SELECT
	DATE(MIN(OrderDate))
    , DATE(MAX(OrderDate))
from sales_salesorderheader;

SELECT
	Name
    , Weight
FROM production_product
WHERE 
	Weight IS NULL;
    
SELECT
    COUNT(BusinessEntityID)
    , JobTitle
FROM humanresources_employee
GROUP BY JoBTitle;

SELECT
	BusinessEntityID
    , BirthDate
FROM humanresources_employee
WHERE YEAR(BirthDate) >1980;

SELECT
	Name
FROM production_product
WHERE name LIKE '%Helmet%';

SELECT
	Name
    , listprice
FROM production_product
ORDER BY listprice DESC;

SELECT
	name,
	ROUND(listprice,2) AS vidutine_kaina
FROM production_product
GROUP BY name
HAVING vidutine_kaina > 0
ORDER BY vidutine_kaina DESC;

SELECT
	UPPER(Name)
    , listprice
FROM production_product
ORDER BY listprice DESC;

SELECT DISTINCT
	City,
	char_length(City) AS ilgis
FROM person_address
WHERE char_length(City) > 10;

SELECT DISTINCT
	City,
    COUNT(City) as gyventoju_skaicius
FROM person_address
GROUP BY city;
	
SELECT
	hre.BusinessEntityID
	,pp.firstname
    , pp. lastname
FROM humanresources_employee as hre
JOIN person_person pp ON hre.BusinessEntityID = pp.BusinessEntityID
WHERE pp. lastname LIKE '%son';

SELECT
	pp.BusinessEntityID
	, CONCAT(pp.firstname, ' ', pp.lastname)
    , pe.EmailAddress
    FROM person_person pp
    JOIN person_emailaddress pe ON pp.BusinessEntityID = pe.BusinessEntityID;
    
SELECT	
	pps.ProductSubcategoryID
   ,  pc.ProductCategoryID 
  ,  COUNT(*) 
  FROM production_product pp 
  JOIN production_productsubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
  JOIN production_productcategory pc ON pps.ProductCategoryID = pc.ProductCategoryID
  GROUP BY pc.ProductCategoryID;
  
  SELECT	
	pc.ProductCategoryID,
    pc.Name
	,COUNT(*) 
  FROM production_product pp 
  JOIN production_productsubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
  JOIN production_productcategory pc ON pps.ProductCategoryID = pc.ProductCategoryID
  GROUP BY pc.ProductCategoryID;
  
  -- 20.
  
  SELECT	
	pps.ProductSubcategoryID,
    pps.Name
	,COUNT(*) 
  FROM production_product pp 
  JOIN production_productsubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
  GROUP BY pps.ProductSubcategoryID;
  
  SELECT 
    psc.ProductSubcategoryID,
    psc.Name AS SubcategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM 
    production_product p
     JOIN Production_ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY 
    psc.ProductSubcategoryID, psc.Name
ORDER BY ProductCount DESC;
	

	
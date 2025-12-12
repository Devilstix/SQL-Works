-- 21. Naudodami JOIN, parodykite klientų vardus ir miestus.

SELECT
	CONCAT_WS( ' ', pp.FirstName, pp.MiddleName, pp.LastName) as 'Vardas, pavarde'
    , pa.city as Miestas
    FROM person_person pp
    JOIN person_businessentityaddress pbea ON pp.BusinessEntityID = pbea.BusinessEntityID
    JOIN person_address pa ON pbea.AddressID = pa.AddressID;
    
    
    SELECT 
    c.CustomerID,
    CONCAT_WS( ' ', pp.FirstName, pp.MiddleName, pp.LastName) as 'Vardas, pavarde'
    , pa.city as Miestas
FROM sales_customer c
JOIN person_businessentityaddress bea ON c.PersonID = bea.BusinessEntityID
JOIN person_person pp ON bea.BusinessEntityID = pp.BusinessEntityID
JOIN person_address pa ON bea.AddressID = pa.AddressID;

    
-- 22. Sujunkite produktų ir jų kategorijų lenteles, parodykite produktų pavadinimus ir
-- kategorijų pavadinimus.

SELECT
	pp.Name as Produktas
    , pc.Name as Kategorija
FROM production_product pp 
  JOIN production_productsubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
  JOIN production_productcategory pc ON pps.ProductCategoryID = pc.ProductCategoryID;
  
-- 23. Raskite 5 brangiausius produktus.

SELECT
	Name as Produktas
    , ListPrice AS Kaina
FROM production_product
ORDER BY ListPrice DESC
LIMIT 5;

-- 24. Naudokite CASE, kad pažymėtumėte produktus kaip 'Lengvas', 'Vidutinis', 'Sunkus'
-- pagal svorį.

SELECT
	Name
    , Weight
   , CASE 
		WHEN Weight > 148 THEN 'Sunkus'
        WHEN Weight  BETWEEN 13 AND 148 THEN 'Vidutinis'
        ELSE 'Lengvas'
        END AS 'Svorio kategorija'
FROM production_product
ORDER BY Weight DESC;

-- 25. Naudokite IF() funkciją produkto kainos analizei – ar viršija 500.

SELECT
	Name
    , ListPrice
    , IF (ListPrice > 500, 'Virsija' , 'Nevirsija') as 'Svorio virsijimas'
FROM production_product
ORDER BY ListPrice DESC;

-- 26. Raskite klientus, kurie turi daugiau nei vieną adresą (naudokite GROUP BY ir
-- HAVING).

    
SELECT 
    c.CustomerID,
    CONCAT_WS( ' ', pp.FirstName, pp.MiddleName, pp.LastName) as 'Vardas, pavarde'
    , COUNT(bea.AddressID) AS AddressCount
FROM sales_customer c
JOIN person_businessentityaddress bea ON c.PersonID = bea.BusinessEntityID
JOIN person_person pp ON bea.BusinessEntityID = pp.BusinessEntityID
GROUP BY 
    c.CustomerID
HAVING 
    COUNT(bea.AddressID) > 1;
    
-- 27. Sukurkite CTE, kuris grąžina visus produktus, kurių kaina viršija vidurkį.


WITH
	vidurkis AS ( 
		SELECT 
			AVG(ListPrice) AS 'kainos vidurkis'
		FROM production_product)
SELECT
	Name
    , ListPrice
FROM production_product pp
CROSS JOIN vidurkis
WHERE ListPrice > 'kainos vidurkis'
ORDER BY ListPrice DESC;

-- 28. Naudokite subquery, kad rastumėte produktus brangesnius už visų produktų
-- medianą.

SELECT
	Name
    , ListPrice
FROM production_product
WHERE ListPrice > 
	(SELECT
		MEDIAN(ListPrice) 
	FROM production_product);  
    
WITH ordered_prices AS (
  SELECT 
    ListPrice,
    ROW_NUMBER() OVER (ORDER BY ListPrice) AS row_num,
    COUNT(*) OVER () AS total_rows
  FROM production_product
  WHERE ListPrice > 0
),
median_calc AS (
  SELECT AVG(ListPrice) AS median_price
  FROM ordered_prices
  WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2))
)
SELECT 
  p.ProductID,
  p.Name,
  p.ListPrice
FROM production_product AS p
CROSS JOIN median_calc AS m
WHERE p.ListPrice > m.median_price
ORDER BY p.ListPrice DESC, p.ProductID;

-- Mokytojos
select * from production_product;
SELECT p1.*
FROM production_product p1
WHERE (
  SELECT COUNT(*) 
  FROM production_product p2
  WHERE p2.ListPrice < p1.ListPrice
) >= (
  SELECT COUNT(*) 
  FROM production_product
) / 2;
 
WITH ordered_prices AS (
  SELECT listprice,
         ROW_NUMBER() OVER (ORDER BY listprice) AS rn,
         COUNT(*) OVER () AS total
  FROM production_product
),
median_price AS (
  SELECT listprice
  FROM ordered_prices
  WHERE rn = FLOOR((total + 1)/2)
)
SELECT * 
FROM production_product
WHERE listprice > (SELECT listprice FROM median_price);
    
-- 29. Raskite šalis, kuriose gyvena daugiau nei 5 žmonės (pagal adresus).

SELECT
		COUNT(pa.AddressID) as Skaicius
		,cr.Name as Salis
FROM person_address pa
JOIN person_stateprovince st ON pa.StateProvinceID = st.StateProvinceID
JOIN person_countryregion cr ON st.CountryRegionCode = cr.CountryRegionCode
GROUP BY Salis
HAVING Skaicius > 5
ORDER BY Skaicius DESC;

-- 30. Apskaičiuokite bendrą visų užsakymų pardavimo sumą iš sales_salesorderheader.

SELECT
	SUM(TotalDue) AS Bendra_suma
FROM sales_salesorderheader;

-- 31. Raskite kiek klientų pateikė bent vieną užsakymą.

SELECT
	CustomerID
    , COUNT(SalesOrderID) AS Uzsakymu_skaicius
FROM sales_salesorderheader
GROUP BY CustomerID
ORDER BY Uzsakymu_skaicius DESC;

SELECT 
    COUNT(DISTINCT CustomerID) AS Klientai_su_bent_1
FROM sales_salesorderheader;

-- 32. Raskite kiekvieno kliento visų užsakymų sumą (vardas, pavardė, suma).

SELECT
	soh.CustomerID
    , CONCAT_WS(' ', pp.FirstName, pp.MiddleName, pp.LastName) AS 'Vardas, pavarde'
    , ROUND(SUM(soh.TotalDue),2) AS Bendra_suma
FROM sales_salesorderheader soh
JOIN sales_customer c ON soh.CustomerID = c.CustomerID
JOIN person_person pp ON c.PersonID = pp.BusinessEntityID
GROUP BY 
	soh.CustomerID, 'Vardas, pavarde'
ORDER BY Bendra_suma DESC;

-- 33. Apskaičiuokite kiek užsakymų buvo pateikta kiekvieną mėnesį.

SELECT
	MONTH(OrderDate) AS Menuo
    , COUNT(SalesOrderID) AS Uzsakymu_skaicius
FROM sales_salesorderheader
GROUP BY Menuo 
ORDER BY Uzsakymu_skaicius DESC;

-- 34. Išveskite 10 dažniausiai parduodamų produktų pagal kiekį.

SELECT
	pp.Name AS Produktas
	, COUNT(sod.ProductID) AS Uzsakymai
FROM sales_salesorderdetail sod
JOIN production_product pp ON sod.ProductID = pp.ProductID
GROUP BY Produktas
ORDER BY Uzsakymai DESC
LIMIT 10;

-- 35. Raskite visus klientus, kurių pirkimo suma viršija vidutinę visų klientų sumą. (su
-- subquery)

SELECT
	soh.CustomerID
    , CONCAT_WS(' ', pp.FirstName, pp.MiddleName, pp.LastName) AS 'Vardas, pavarde'
    , ROUND(SUM(soh.TotalDue),2) AS Bendra_suma
FROM sales_salesorderheader soh
JOIN sales_customer c ON soh.CustomerID = c.CustomerID
JOIN person_person pp ON c.PersonID = pp.BusinessEntityID
GROUP BY 
	soh.CustomerID, 'Vardas, pavarde'
HAVING Bendra_suma > (
	SELECT
		AVG(TotalDue)
	FROM sales_salesorderheader)
ORDER BY Bendra_suma DESC;

-- 36. Parodykite kiekvieno produkto pavadinimą ir jo bendrą pardavimų sumą (naudoti
-- JOIN su sales_salesorderdetail).

SELECT
	pp.Name AS Produktas
	, ROUND(SUM(sod.LineTotal), 2) AS Suma
FROM sales_salesorderdetail sod
JOIN production_product pp ON sod.ProductID = pp.ProductID
GROUP BY Produktas
ORDER BY Suma DESC;

-- 37. Naudokite CASE, kad parodytumėte, ar produktas yra 'Pigus', 'Vidutinės kainos', ar
-- 'Brangus' (pagal listprice).

SELECT
	ProductID
    , Name
    , ListPrice
    , CASE
		WHEN ListPrice > 2000 THEN 'Brangus'
        WHEN ListPrice BETWEEN 1000 AND 2000 THEN 'Vidutinės kainos'
        WHEN ListPrice = 0 THEN 'Nemokamas'
        ELSE 'Pigus'
        END AS 'Kainos kategorija'
FROM production_product
ORDER BY ListPrice DESC;

-- 38. Išveskite užsakymus, kurių pristatymo kaina didesnė nei 10 % nuo visos užsakymo
-- sumos (CASE ar IF su skaičiavimu).

WITH 
	visa_suma as (
		SELECT
			(soh.TotalDue * 0.1) AS '10%'
		FROM sales_salesorderheader soh)
SELECT
	soh.SalesOrderID
    , CASE
		WHEN (TotalDue * 0.1)  < poh.Freight THEN 'Brangus shippingas'
        END AS 'Shipping >10%'
FROM sales_salesorderheader soh
JOIN purchasing_purchaseorderheader poh ON soh.ShipMethodID = poh.ShipMethodID
ORDER BY poh.Freight;

SELECT 
    soh.SalesOrderID,
    soh.TotalDue,
    poh.Freight,
    CASE 
        WHEN poh.Freight > soh.TotalDue * 0.10 THEN 'Didesnė nei 10%' 
        ELSE 'Mažesnė arba lygi 10%' 
    END AS Shipping_Procentas
FROM sales_salesorderheader soh
JOIN purchasing_purchaseorderheader poh ON soh.ShipMethodID = poh.ShipMethodID
WHERE poh.Freight > soh.TotalDue * 0.10;

        
-- 39. Raskite klientus, kurie pateikė daugiau nei 5 užsakymus.

SELECT
	soh.CustomerID
   , CONCAT_WS( ' ', pp.FirstName, pp.MiddleName, pp.LastName) as 'Vardas, pavarde'
    , COUNT(soh.SalesOrderID) AS uzsakymu_kiekis
FROM sales_salesorderheader soh
JOIN sales_customer c ON soh.CustomerID = c.CustomerID
JOIN person_person pp ON c.PersonID = pp.BusinessEntityID
GROUP BY soh.CustomerID, 'Vardas, pavarde'
HAVING COUNT(soh.SalesOrderID) > 5
ORDER BY uzsakymu_kiekis DESC ;


-- 40. Parodykite visų produktų sąrašą ir pažymėkite, ar jie kada nors buvo parduoti (CASE
-- WHEN EXISTS (...) THEN 'Taip' ELSE 'Ne').

SELECT
	pp.ProductID
	,pp.Name
    , CASE 
		WHEN EXISTS (
            SELECT 1
            FROM sales_salesorderdetail sod
            WHERE sod.ProductID = pp.ProductID
        ) THEN 'Taip'
        ELSE 'Ne'
    END AS Buvo_Parduotas
FROM production_product pp
ORDER BY ProductID ASC;
		
-- 41. Apskaičiuokite pelną kiekvienam produktui (kaina - standarto kaina), parodykite tik
-- tuos, kurių pelnas > 0.

SELECT
ProductID
,Name
, ListPrice
, StandardCost
, (ListPrice - StandardCost) AS Pelnas
FROM production_product
WHERE (ListPrice - StandardCost)  > 0
ORDER BY Pelnas DESC;

-- 42. Parodykite klientus, kurie pirko prekes už daugiau nei 1000.

SELECT
	soh.CustomerID
    , CONCAT_WS(' ', pp.FirstName, pp.MiddleName, pp.LastName) AS 'Vardas, pavarde'
    , ROUND(SUM(soh.TotalDue),2) AS Bendra_suma
FROM sales_salesorderheader soh
JOIN sales_customer c ON soh.CustomerID = c.CustomerID
JOIN person_person pp ON c.PersonID = pp.BusinessEntityID
GROUP BY 
	soh.CustomerID, 'Vardas, pavarde'
HAVING Bendra_suma > 1000
ORDER BY Bendra_suma DESC;

-- MOKYTOJOS--
SELECT
    h.CustomerID,
    p.FirstName,
    p.LastName,
    SUM(h.TotalDue) AS suma
FROM sales_salesorderheader AS h
INNER JOIN person_person AS p
    ON h.CustomerID = p.BusinessEntityID
GROUP BY h.CustomerID, p.FirstName, p.LastName
HAVING SUM(h.TotalDue) > 1000
ORDER BY suma DESC, p.LastName ASC, p.FirstName ASC;

-- 43. Parodykite produktus, kurie yra brangesni nei bet kuris "Helmet" tipo produktas. (su
-- ANY ar subquery)

SELECT
	pp.ProductID
	,pp.Name
	, pp.ListPrice 
FROM production_product pp
WHERE pp.ListPrice > (
        SELECT MAX(pp.ListPrice)
        FROM production_product pp
        JOIN production_productsubcategory psc ON pp.ProductSubcategoryID = psc.ProductSubcategoryID
        WHERE psc.Name LIKE 'Helmets'
    )
ORDER BY pp.ListPrice DESC;

-- 44. Parodykite kiekvienos produktų subkategorijos pardavimo sumą.

SELECT
	psc.ProductSubcategoryID
    , psc.Name
    , ROUND(SUM(soh.TotalDue), 2) SUMA
FROM production_productsubcategory psc 
JOIN production_product pp ON psc.ProductSubcategoryID = pp.ProductSubcategoryID
LEFT JOIN sales_salesorderdetail sod ON pp.ProductID = sod.ProductID
LEFT JOIN sales_salesorderheader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY psc.ProductSubcategoryID, psc.Name
ORDER BY SUMA DESC, psc.Name ASC;

-- mokytojos--
SELECT
    sc.ProductSubcategoryID,
    sc.Name AS subcategory_name,
    SUM(d.LineTotal) AS total_sales
FROM sales_salesorderdetail AS d
INNER JOIN production_product AS p
    ON d.ProductID = p.ProductID
LEFT JOIN production_productsubcategory AS sc
    ON p.ProductSubcategoryID = sc.ProductSubcategoryID
GROUP BY sc.ProductSubcategoryID, sc.Name
ORDER BY total_sales DESC, sc.Name ASC;

-- 45. Parodykite tik tuos produktus, kurių buvo parduota daugiau nei 100 vienetų.

SELECT
	pp.Name AS Produktas
	, COUNT(sod.ProductID) AS Uzsakymai
FROM sales_salesorderdetail sod
JOIN production_product pp ON sod.ProductID = pp.ProductID
GROUP BY Produktas
HAVING Uzsakymai > 100
ORDER BY Uzsakymai DESC

-- MOKYTOJOS KODEL SKIRIASI DEL ORDERQTY
SELECT
    d.ProductID,
    p.Name,
    SUM(d.OrderQty) AS qty
FROM sales_salesorderdetail AS d
INNER JOIN production_product AS p
    ON d.ProductID = p.ProductID
GROUP BY d.ProductID, p.Name
HAVING SUM(d.OrderQty) > 100
ORDER BY qty DESC, d.ProductID ASC;

-- 46. Apskaičiuokite kiek produktų yra kiekvienoje kainos kategorijoje: <100, 100–500,
-- >500.

SELECT
	CASE
		WHEN ListPrice > 500 THEN '>500'
        WHEN ListPrice BETWEEN 100 AND 500 THEN '100–500'
        ELSE '<100'
        END AS Kainos_kategorija
	,COUNT(ListPrice) AS Produktu_skaicius
FROM production_product 
GROUP BY Kainos_kategorija
ORDER BY Produktu_skaicius DESC;

-- 47. Parodykite darbuotojus, kurie dirba daugiau nei metus, 5 metus ir daugiau nei 10
-- metų (skaičiuoti su DATEDIFF().

SELECT
	hre.BusinessEntityID
    , CONCAT_WS(' ', pp.FirstName, pp.MiddleName, pp.LastName) AS 'Vardas, pavarde'
    , hre.HireDate
    CASE
		WHEN DATEDIFF(DATE(2014-07-06),  hre.HireDate) > 3650 THEN '>10 METU'
        WHEN DATEDIFF(DATE(2014-07-06),  hre.HireDate) > 1825 THEN '>5 METAI'
        WHEN DATEDIFF(DATE(2014-07-06),  hre.HireDate) > 365 THEN '>1 year'
        ELSE '<=1 METAI'
	FROM humanresources_employee hre
    JOIN person_person pp
-- 48. Raskite, kurie produktai generavo didžiausią pardavimų pajamų sumą
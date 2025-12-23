-- ADV_Practice_Intermediate
-- Užduotys praktikai
-- 1. LEFT JOIN kartojimas
-- Išvesti produkto pavadinimą ir užsakymo numerį (SalesOrderID) visiems produktams.
-- Naudojamos lentelės:
-- Production_Product AS p
-- LEFT JOIN Sales_SalesOrderDetail AS sod

SELECT
	pp.Name,
	sod.SalesOrderID
FROM production_product pp
LEFT JOIN Sales_SalesOrderDetail sod ON pp.ProductID = sod.ProductID;

SELECT
	pp.Name,
	sod.SalesOrderID
FROM production_product pp
JOIN Sales_SalesOrderDetail sod ON pp.ProductID = sod.ProductID;

SELECT
	pp.Name,
	sod.SalesOrderID
FROM production_product pp
RIGHT JOIN Sales_SalesOrderDetail sod ON pp.ProductID = sod.ProductID;

-- 2. RIGHT JOIN kartojimas
-- Išvesti teritorijos pavadinimą ir BusinessEntityID. Rezultate turi būti visi pardavėjai, nesvarbu, ar
-- jie dirba toje teritorijoje.
-- Naudojamos lentelės:
-- Sales_SalesTerritory
-- Sales_SalesPerson


SELECT
	st.Name
    , sp.BusinessEntityID
FROM sales_salesterritory st
RIGHT JOIN sales_salesperson sp ON sp.TerritoryID = st.TerritoryID;

-- 3. JOIN kartojimas
-- Išvesti kontaktus, kurie nėra iš US ir gyvena miestuose, kurių pavadinimas prasideda „Pa“.
-- Išvesti stulpelius: AddressLine1, AddressLine2, City, PostalCode, CountryRegionCode.
-- Naudojamos lentelės:
-- Person_Address AS a
-- Person_StateProvince AS s

SELECT
	a.AddressLine1,
    a.AddressLine2,
    a.City,
	a.PostalCode,
    sp.CountryRegionCode
FROM person_address a
JOIN person_stateprovince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE CountryRegionCode NOT LIKE 'US'
	AND a.City LIKE 'Pa%';

-- 4. JOIN kartojimas su subquery arba CTE
-- Išvesti darbuotojų vardą ir pavardę (kartu) ir jų gyvenamą miestą.
-- Naudojamos lentelės:
-- Person_Person
-- HumanResources_Employee
-- Person_Address
-- Person_BusinessEntityAddress

SELECT
	CONCAT_WS(' ', pp.FirstName, pp.MiddleName, pp.LastName) AS Full_name
    , pa.City
FROM person_person pp
JOIN humanresources_employee hre ON pp.BusinessEntityID = hre.BusinessEntityID
LEFT JOIN person_businessentityaddress pba ON hre.BusinessEntityID = pba.BusinessEntityID
LEFT JOIN person_address pa ON pba.AddressID = pa.AddressID;

WITH EmployeeAddress AS (
    SELECT
       hre.BusinessEntityID,
        pa.City
    FROM humanresources_employee hre
    JOIN person_businessentityaddress bea ON hre.businessentityID = bea.businessentityID
    JOIN person_address pa ON bea.addressID = pa.addressID
)
SELECT
    CONCAT_WS(' ', pp.FirstName, pp.MiddleName, pp.LastName) AS Full_Name,
    ea.City
FROM EmployeeAddress ea
JOIN person_person pp ON ea.BusinessEntityID = pp.BusinessEntityID;


-- 5. UNION ALL kartojimas
-- Parašyti SQL užklausą, kuri pateiktų visų raudonos arba mėlynos spalvos produktų sąrašą.
-- Išvesti: pavadinimą, spalvą ir katalogo kainą (ListPrice).
-- Rūšiuoti pagal ListPrice.
-- Naudojama lentelė:
-- Production_Product

SELECT
	Name
    , Color
    , ListPrice
FROM production_product
WHERE Color LIKE 'Red'
UNION ALL 
SELECT
	Name
    , Color
    , ListPrice
FROM production_product
WHERE Color LIKE 'Blue'
ORDER BY ListPrice DESC;

SELECT 
	Name, 
	Color, 
	ListPrice
FROM production_product
WHERE Color IN ('Red', 'Blue')
ORDER BY ListPrice;

-- 6. CTE kartojimas
-- Rasti, kiek užsakymų per metus įvykdo kiekvienas pardavėjas.
-- Naudojamos lentelės:
-- Sales_SalesOrderHeader
-- Sales_SalesPerson

WITH
	sales_count AS (
		SELECT
			soh.SalesPersonID
             , YEAR(soh.OrderDate) AS OrderYear
            , COUNT(soh.SalesOrderID) AS OrderCount
		FROM sales_salesorderheader soh
        GROUP BY soh.SalesPersonID, YEAR(soh.OrderDate))
SELECT
	ssp.BusinessEntityID AS SalesPerson
    , sc.OrderYear
    , sc.OrderCount
  FROM  sales_salesperson ssp
  JOIN sales_count sc ON ssp.BusinessEntityID = sc.SalesPersonID
  ORDER BY sc.OrderCount DESC;
  

-- 7. Aritmetiniai skaičiavimai
-- Apskaičiuoti bendros metų pardavimų sumos (SalesYTD) padalijimą iš komisinių procentinės
-- dalies (CommissionPCT).
-- Išvesti SalesYTD, CommissionPCT ir apskaičiuotą reikšmę, suapvalintą iki artimiausio sveikojo
-- skaičiaus.Naudojama lentelė:
-- Sales_SalesPerson

SELECT
	ROUND(SalesYTD) AS SalesYTD
    , CommissionPct
    , ROUND(SalesYTD / CommissionPct) AS SalesYTD_div
FROM sales_salesperson 
ORDER BY SalesYTD_div DESC;

SELECT
	ROUND(SalesYTD) AS SalesYTD
    , CommissionPct
    , ROUND(SalesYTD  * CommissionPct) AS SalesYTD_div
FROM sales_salesperson 
ORDER BY SalesYTD_div DESC;


-- 8. STRING duomenų tipo manipuliavimas
-- Išvesti produktų pavadinimus, kurių kainos yra tarp 1000 ir 1220.
-- Pavadinimus išvesti trimis būdais: naudojant LOWER(), UPPER() ir LOWER(UPPER()).
-- Naudojama lentelė:
-- Production_Product

SELECT
	LOWER(Name) AS Low_name
    , UPPER(Name) AS Up_name
    , LOWER(UPPER(Name)) AS Lowup_name
FROM production_product
WHERE ListPrice BETWEEN 1000 AND 1220;

-- 9. Wildcards kartojimas
-- Iš Production_Product išrinkti ProductID ir pavadinimą produktų, kurių pavadinimas prasideda
-- „Lock %“.

SELECT
	ProductID
	, Name
FROM production_product
WHERE Name LIKE 'Lock %';

-- 10. CASE ir loginės sąlygos
-- Iš lentelės HumanResources_Employee parašyti SQL užklausą, kuri grąžintų darbuotojų ID ir
-- reikšmę, ar darbuotojas gauna pastovų atlyginimą (SalariedFlag) kaip TRUE arba FALSE.
-- Rezultatus surikiuoti taip:
-- – pirmiausia darbuotojai su pastoviu atlyginimu, mažėjančia ID tvarka;
-- – po jų kiti darbuotojai, didėjančia ID tvarka.
-- Naudoti CASE tiek stulpelio konvertavimui, tiek rikiavimui.

SELECT
	BusinessEntityID AS EmploeeID
    , CASE
		WHEN SalariedFlag = 1 THEN 'TRUE'
        ELSE 'FALSE'
        END AS Got_salery
FROM humanresources_employee;

-- 11. Window Functions kartojimas
-- Naudojamos lentelės: Sales_SalesPerson, Person_Person, Person_Address.
-- Parašyti SQL užklausą, kuri atrinktų asmenis, gyvenančius teritorijoje ir kurių SalesYTD ≠ 0.
-- Grąžinti: vardą, pavardę, eilučių numeraciją (Row Number), reitingą (Rank), glaustą reitingą
-- (Dense Rank), kvartilį (Quartile), SalesYTD ir PostalCode.
-- Rikiuoti pagal PostalCode.
-- Naudoti ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE().

SELECT
	pp.FirstName
    , pp.LastName
    , ROW_NUMBER() OVER 
		(ORDER BY a.PostalCode) AS RowNumber,
	RANK() OVER 
		(ORDER BY sp.SalesYTD DESC) AS SalesRank,
	DENSE_RANK() OVER 
		(ORDER BY sp.SalesYTD DESC) AS SalesDenseRank,
	NTILE(4) OVER 
		(ORDER BY sp.SalesYTD DESC) AS Quartile,
	sp.SalesYTD,
    a.PostalCode
FROM person_person pp
JOIN sales_salesperson ssp ON pp.BusinessEntityID = sspBusinessEntityID
JOIN person_address pa ON pp.AddressID = pa.AddressID


-- 12. Agregacijų kartojimas su Window Functions
-- Iš lentelės Sales_SalesOrderDetail apskaičiuoti suminį kiekį, vidurkį, užsakymų skaičių,
-- mažiausią ir didžiausią OrderQty kiekvienam SalesOrderID.
-- Atrinkti tik SalesOrderID: 43659 ir 43664.
-- Grąžinti: SalesOrderID, ProductID, OrderQty, suminį kiekį, vidurkį, užsakymų skaičių, minimalų
-- ir maksimalų kiekį.
-- Naudoti SUM(), AVG(), COUNT(), MIN(), MAX() su OVER (PARTITION BY SalesOrderID);

SELECT
    SalesOrderID,
    ProductID,
    OrderQty,
    SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS TotalQty,
    ROUND(AVG(OrderQty) OVER (PARTITION BY SalesOrderID)) AS AvgQty,
    COUNT(*) OVER (PARTITION BY SalesOrderID) AS OrderCount,
    MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS MinQty,
    MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS MaxQty
FROM Sales_SalesOrderDetail
WHERE SalesOrderID IN (43659, 43664)
ORDER BY SalesOrderID, ProductID;

-- 1. Klientų lojalumo analizė.
-- Scenarijus: Įmonės rinkodaros komanda 2014 m. birželio 30 d.siekia įvertinti klientų
-- lojalumą. Jūsų užduotis skirta įvertinti klientų elgseną laike. Reikia nustatyti, kurie klientai
-- pirmą kartą užsakė 2013 metais ir kiek vidutiniškai išleido tais metais, ir ar jie užsakė dar
-- kartą ir kiekvieno užsakymo sumą 2014 metais.

WITH first_order AS (
    SELECT 
        c.customerid
        , MIN(soh.orderdate) AS first_order_date                           							-- Surandame pirmą kliento užsakymo datą per visą istoriją
    FROM sales_salesorderheader soh
    JOIN sales_customer c ON soh.customerid = c.customerid
    GROUP BY c.customerid),
    
customers_2013 AS (
    SELECT																										
        c.customerid
		, p.firstname AS vardas
       , p.lastname AS pavarde
       , ROUND(AVG(soh.totaldue), 2) AS uzsakymo_vidurkis_2013				-- Apskaičiuojame jų 2013 m. užsakymų vidutinę sumą
    FROM sales_salesorderheader soh
    JOIN sales_customer c ON soh.customerid = c.customerid
    JOIN person_person p ON c.personid = p.businessentityid
    JOIN first_order fo ON fo.customerid = c.customerid
    WHERE YEAR(fo.first_order_date) = 2013													-- Atrenkame tik tuos klientus, kurių pirmas užsakymas = 2013 m.
    GROUP BY c.customerid, p.firstname, p.lastname)
    
SELECT																													-- Pateikiame galutinį rezultatą
    cu.customerid AS id
    , cu.vardas
    , cu.pavarde
    , cu.uzsakymo_vidurkis_2013
    , soh.salesorderid AS uzsakymoID
    , soh.orderdate AS uzsakymo_data
    , ROUND(soh.totaldue, 2) AS suma
    , DENSE_RANK() OVER 																					-- Priskiriame DENSE_RANK() pagal 2014 m. užsakymo datą
		(PARTITION BY cu.customerid ORDER BY soh.orderdate) AS ranking   
FROM customers_2013 cu
LEFT JOIN sales_salesorderheader soh 
    ON cu.customerid = soh.customerid 
   AND YEAR(soh.orderdate) = 2014																-- Surandame jų 2014 m. užsakymus
ORDER BY cu.customerid, ranking;

-- 2. Produktų pardavimų analizė pagal prekių kategorijas ir regionus
-- Užduotis: Parašykite užklausą, kuri apskaičiuoja bendrą produktų pardavimų sumą pagal prekių
-- kategorijas ir rodo rezultatus pagal regionus. 

SELECT 
    pc.Name AS kategorija
    ,st.Name AS regionas
    ,ROUND(SUM(sod.LineTotal), 2) AS bendra_suma
FROM sales_salesorderdetail sod
JOIN sales_salesorderheader soh 														-- Prijungiame salesorderheader
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN production_product p 																		-- Prijungiame product
    ON sod.ProductID = p.ProductID
JOIN production_productsubcategory psc 											-- Prijungiame productsubcategory 
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID			
JOIN production_productcategory pc 														-- Prijungiame productcategory
    ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN sales_salesterritory st 																	-- Prijungiame salesterritory
    ON soh.TerritoryID = st.TerritoryID
WHERE YEAR(soh.OrderDate) = 2013													-- Filtruojame tik 2013 metų pardavimus
GROUP BY pc.Name, st.Name
ORDER BY st.Name ASC, bendra_suma DESC;

-- 3. Pardavimų departamento darbuotojų našumas
-- Užduotis: Vadovybė nori įvertinti pardavimų darbuotojų efektyvumą pagal jų priskirtus
-- departamentus.

WITH employee_sales AS (																												-- Su CTE apskaiciuojam kiekvieno pardavimu darbuotojo bendra pardavimu suma
    SELECT
        sp.BusinessEntityID AS EmployeeID,                 
        p.FirstName AS vardas,                           
        p.LastName AS pavarde,                           
        d.DepartmentID,                                  
        d.Name AS departamentas,                           
        SUM(soh.TotalDue) AS darbuotojo_pardavimai      
    FROM sales_salesorderheader soh
    JOIN sales_salesperson sp                              																			-- Prijungiame sales_salesperson
        ON soh.SalesPersonID = sp.BusinessEntityID
    JOIN person_person p                                   																				-- Prijungiame person_person
        ON sp.BusinessEntityID = p.BusinessEntityID
    JOIN humanresources_employeedepartmenthistory edh   													 -- Prijungiame humanresources_employeepayhistory
        ON sp.BusinessEntityID = edh.BusinessEntityID
       AND edh.EndDate IS NULL                             																			-- Tik aktyvūs departamentai
    JOIN humanresources_department d                       																-- Prijungiame humanresources_department
        ON edh.DepartmentID = d.DepartmentID
    GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName, d.DepartmentID, d.Name)

SELECT
    EmployeeID AS id,                                     
    vardas,                                              
    pavarde,                                             
    departamentas,                                        
    ROUND(darbuotojo_pardavimai, 2) AS darbuotojo_pardavimai,  
    ROUND(AVG(darbuotojo_pardavimai) OVER (PARTITION BY DepartmentID), 2) 
		AS departamento_pard_vidurkis,                   																			 -- Departamento vidutinė pardavimų suma
    ROUND(
        darbuotojo_pardavimai /
        AVG(darbuotojo_pardavimai) OVER (PARTITION BY DepartmentID) * 100, 1) 
        AS santykinis_nasumas_proc,                        																		-- Apskaiciuojam santykini našuma procentais
    CASE                                                 																								-- Vertinimas tekstinis ar virsija vidurki
        WHEN darbuotojo_pardavimai >
             AVG(darbuotojo_pardavimai) OVER (PARTITION BY DepartmentID)
            THEN 'Viršija vidurkį'
        WHEN darbuotojo_pardavimai =
             AVG(darbuotojo_pardavimai) OVER (PARTITION BY DepartmentID)
            THEN 'Atitinka vidurkį'
        ELSE 'Nesiekia vidurkio'
    END AS vertinimas
FROM employee_sales
ORDER BY departamentas, darbuotojo_pardavimai DESC;      											



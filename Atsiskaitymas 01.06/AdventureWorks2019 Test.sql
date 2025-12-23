-- 1. Klientų lojalumo analizė.
-- Scenarijus: Įmonės rinkodaros komanda 2014 m. birželio 30 d.siekia įvertinti klientų
-- lojalumą. Jūsų užduotis skirta įvertinti klientų elgseną laike. Reikia nustatyti, kurie klientai
-- pirmą kartą užsakė 2013 metais ir kiek vidutiniškai išleido tais metais, ir ar jie užsakė dar
-- kartą ir kiekvieno užsakymo sumą 2014 metais.

WITH first_order AS (
    SELECT 
        c.customerid
        , MIN(soh.orderdate) AS first_order_date                           						-- Surandame pirmą kliento užsakymo datą per visą istoriją (naudojam CTE)
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
    JOIN person_person p ON c.personid = p.businessentityid						-- Prijungiam person_person (vardas, pavardė)
    JOIN first_order fo ON fo.customerid = c.customerid								-- Prijungiame pirmo užsakymo CTE
    WHERE YEAR(fo.first_order_date) = 2013												-- Atrenkame tik tuos klientus, kurių pirmas užsakymas = 2013 m.
    GROUP BY c.customerid, p.firstname, p.lastname)
    
SELECT																													-- Pateikiame galutinį rezultatą
    cu.customerid AS id
    , cu.vardas
    , cu.pavarde
    , cu.uzsakymo_vidurkis_2013
    , soh.salesorderid AS uzsakymoID
    , soh.orderdate AS uzsakymo_data
    , ROUND(soh.totaldue, 2) AS suma
    , DENSE_RANK() OVER 																					--  Užsakymo eilės numeris (pagal datą, 2014 m.)
		(PARTITION BY cu.customerid ORDER BY soh.orderdate) AS ranking   
FROM customers_2013 cu
LEFT JOIN sales_salesorderheader soh 
    ON cu.customerid = soh.customerid 
   AND YEAR(soh.orderdate) = 2014																 -- Tik 2014 m. užsakymai
ORDER BY cu.customerid, ranking;

-- 2. Produktų pardavimų analizė pagal prekių kategorijas ir regionus
-- Užduotis: Parašykite užklausą, kuri apskaičiuoja bendrą produktų pardavimų sumą pagal prekių
-- kategorijas ir rodo rezultatus pagal regionus. 

SELECT 
    pc.Name AS kategorija
    ,st.Name AS regionas
    ,ROUND(SUM(sod.LineTotal), 2) AS bendra_suma
FROM sales_salesorderdetail sod
JOIN sales_salesorderheader soh 														-- Prijungiame salesorderheader (gaunam bendra info)
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN production_product p 																		-- Prijungiame product (gaunam parduodamas prekes)
    ON sod.ProductID = p.ProductID
JOIN production_productsubcategory psc 											-- Prijungiame productsubcategory (gaunam subkategorijas)
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID			
JOIN production_productcategory pc 														-- Prijungiame productcategory (gaunam kategorijas)
    ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN sales_salesterritory st 																	-- Prijungiame salesterritory (gaunam regionus pardavimu)
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

-- 4. Pardavimų analize pagal laikotarpį ir produktų grupes
-- Užduotis: Parašykite užklausą, kuri apskaičiuoja bendrą pardavimų sumą per metus (2013)
-- pagal produktų grupes

SELECT 
    psc.Name AS prekes_grupe,
    SUM(sod.OrderQty) AS kiekis,
    ROUND(SUM(sod.LineTotal), 2) AS pardavimu_suma,															-- Pardavimų suma (LineTotal)
    ROUND(SUM(sod.LineTotal) / SUM(sod.OrderQty), 2) AS vidutine_pardavimo_kaina	-- Vidutinė pardavimo kaina = pardavimų suma / kiekis 
FROM sales_salesorderdetail sod
JOIN sales_salesorderheader soh																								-- Prijungiame sales_salesorderheader (gauname uzsakymo data)
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN production_product p																												-- Prijungiame production_product  (gaunam produktus)
    ON sod.ProductID = p.ProductID
JOIN production_productsubcategory psc																					-- Prijungiame production_productsubcategory (gauname subkategorija)
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
WHERE YEAR(soh.OrderDate) = 2013																							-- Filtruojame tik 2013 metus
GROUP BY psc.Name
ORDER BY vidutine_pardavimo_kaina DESC;


-- 5. Gamybos ir tiekimo grandinės efektyvumo analizė
-- Užduotis: Parašykite užklausą, kuri apskaičiuoja prekių tiekimo laiką pagal gamintoją

SELECT 
    v.Name AS tiekejas,
    p.Name AS produktas,
    ROUND(AVG(DATEDIFF(poh.ShipDate, poh.OrderDate))) AS vid_pristatymo_laikas  -- Vidutinis pristatymo laikas, apvalinam iki sveiko skaičiaus
FROM purchasing_purchaseorderdetail pod															
JOIN purchasing_purchaseorderheader poh																			-- Priungiam purchaseorderheader (čia yra OrderDate ir ShipDate)
    ON pod.PurchaseOrderID = poh.PurchaseOrderID															
JOIN production_product p																											-- Prijungiam production_product  (gauname prekes pavadinima)
    ON pod.ProductID = p.ProductID
JOIN purchasing_productvendor pv																							-- Prijungiam purchasing_productvendor (kad sujungtume prekrd ir tiekėjais)
    ON p.ProductID = pv.ProductID
JOIN purchasing_vendor v																											-- Prijungiam purchasing_vendor: tiekėjo informacija (pavadinimas, ID)
    ON pv.BusinessEntityID = v.BusinessEntityID
GROUP BY v.Name, p.Name
ORDER BY v.Name, p.Name;

-- 6. Pardavimų sezoniškumo analizė
-- Užduotis: Parašykite užklausą, kuri apskaičiuoja mėnesio pardavimus 2013 metais,
-- naudodamiesi SalesOrderHeader duomenimis. 

SELECT
    MONTH(soh.OrderDate) AS menuo,                    						 						 -- mėnesio numeris
    MONTHNAME(soh.OrderDate) AS menuo_pavadinimas,    							 -- mėnesio pavadinimas
    COUNT(*) AS pardavimu_kiekis,                    								 						 -- kiek užsakymų atlikta
    ROUND(SUM(soh.TotalDue), 2) AS pardavimu_suma    								 -- bendra pardavimų suma
FROM sales_salesorderheader soh
WHERE YEAR(soh.OrderDate) = 2013                     						 						 -- filtruojame 2013 metus
GROUP BY MONTH(soh.OrderDate), MONTHNAME(soh.OrderDate)
ORDER BY MONTH(soh.OrderDate) ASC;



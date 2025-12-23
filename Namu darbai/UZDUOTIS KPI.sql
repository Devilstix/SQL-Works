-- MySQL tasks AdventureWorks2019_KPI
-- 1. Apskaičiuok bendrą pardavimų sumą, atskirai online ir direct kanalams.

WITH kanalas AS(
	SELECT
    soh.SalesOrderID,
	CASE
		WHEN soh.OnlineOrderFlag =  1 THEN 'Online'
        ELSE 'Direct'
        END AS Tipas
	, ROUND(SUM(sod.LineTotal),2) AS Suma
FROM sales_salesorderheader soh
JOIN sales_salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY Tipas)

-- 2. Apskaičiuok vidutinę užsakymo vertę pagal pardavimo kanalą.

WITH order_revenue AS (
    SELECT
        soh.SalesOrderID,
        CASE
            WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
            ELSE 'Direct'
        END AS Channel,
        SUM(sod.LineTotal) AS OrderRevenue
    FROM sales_salesorderheader soh
    JOIN sales_salesorderdetail sod
        ON soh.SalesOrderID = sod.SalesOrderID
    GROUP BY soh.SalesOrderID, Channel
)
SELECT
    Channel,
    ROUND(AVG(OrderRevenue)) AS AvgOrderValue
FROM order_revenue
GROUP BY Channel
ORDER BY Channel;

-- 3. Apskaičiuok bendrą produktų pardavimo sumą (linetotal), suskirstytą pagal kanalą.

SELECT
    CASE
        WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
        ELSE 'Direct'
    END AS Channel,
    p.ProductID,
    p.Name AS ProductName,
   ROUND(SUM(sod.LineTotal),2) AS TotalSales
FROM sales_salesorderheader soh
JOIN sales_salesorderdetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN production_product p
    ON sod.ProductID = p.ProductID
GROUP BY Channel, p.ProductID, p.Name
ORDER BY Channel, TotalSales DESC;

-- 4. Rask 5 labiausiai parduodamus produktus kiekviename kanale pagal kiekį.

WITH product_qty AS (
    SELECT
        CASE
            WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
            ELSE 'Direct'
        END AS Channel,
        p.ProductID,
        p.Name AS ProductName,
        SUM(sod.OrderQty) AS TotalQty
    FROM sales_salesorderheader soh
    JOIN sales_salesorderdetail sod
        ON soh.SalesOrderID = sod.SalesOrderID
    JOIN production_product p
        ON sod.ProductID = p.ProductID
    GROUP BY Channel, p.ProductID, p.Name
),
ranked_products AS (
    SELECT
        Channel,
        ProductID,
        ProductName,
        TotalQty,
        ROW_NUMBER() OVER (
            PARTITION BY Channel
            ORDER BY TotalQty DESC
        ) AS rn
    FROM product_qty
)
SELECT
    Channel,
    ProductID,
    ProductName,
    TotalQty
FROM ranked_products
WHERE rn <= 5
ORDER BY Channel, TotalQty DESC;

	

-- 5. Rask klientus, kurie bent du kartus pirko online arba direct kanalu.

SELECT
	CASE 
		WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
        ELSE 'Direct'
        END AS Channel
        , soh.CustomerID
        , pp.FirstName
        , pp.LastName
        , COUNT(DISTINCT soh.SalesOrderID) AS OrdersCount
FROM sales_salesorderheader soh
JOIN sales_customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN person_person pp ON c.PersonID = pp.BusinessEntityID
GROUP BY Channel, soh.CustomerID, pp.FirstName, pp.LastName
HAVING COUNT(DISTINCT soh.SalesOrderID) >= 2
ORDER BY Channel, OrdersCount DESC;

-- 6. Naudojant CTE, rask tik online užsakymus, kurių suma viršija online užsakymų
-- vidurkį.

WITH
	online_orders AS (
		SELECT
			soh.SalesOrderID
			, SUM(sod.LineTotal) AS online_sum
		FROM sales_salesorderheader soh
        JOIN sales_salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID
        WHERE soh.OnlineOrderFlag = 1
		GROUP BY soh.SalesOrderID),
	online_avg AS (
		SELECT
			AVG(online_sum) AS AvgOnlineRevenue
		FROM online_orders)
SELECT
	o.SalesOrderID,
    o.online_sum
FROM online_orders o
CROSS JOIN online_avg a
WHERE o.online_sum > a.AvgOnlineRevenue
ORDER BY o.online_sum DESC;

-- 7. Rask visus produktus, kurie buvo bent kartą parduoti, ir apskaičiuok jų pelną
-- (listprice - standardcost).

SELECT 
	pp.ProductID
    , pp.Name
    , ROUND(pp.StandardCost, 2) kaina,
    ROUND(pp.ListPrice,2) savikaina,
    ROUND((pp.ListPrice - pp.StandardCost),2) AS ProfitPerUnit
FROM production_product pp
JOIN sales_salesorderdetail sod
    ON sod.ProductID = pp.ProductID
WHERE sod.OrderQty > 0
ORDER BY ProfitPerUnit DESC;

-- 8. Apskaičiuok kiekvieno mėnesio pardavimų sumą, atskirai pagal kanalą.


-- 9. Apskaičiuok vidutinį pristatymo laiką (shipdate - orderdate) tik direct kanalui.
-- 10. Apskaičiuok, kiek skirtingų produktų buvo parduota bent kartą kiekviename kanale.
-- 11. Apskaičiuok bendrą pardavimų sumą pagal pardavimo teritoriją.
-- (Naudoti JOIN tarp sales_salesorderheader ir sales_salesterritory)
-- 12. Apskaičiuok online ir direct pardavimų sumą kiekvienai teritorijai atskirai.
-- (Naudoti CASE su GROUP BY territory)
-- 13. Rask teritorijas, kuriose vidutinė online užsakymo vertė viršija direct.
-- (Naudoti subquery arba GROUP BY su CASE)
-- 14. Apskaičiuok vidutinį pristatymo laiką kiekvienoje teritorijoje (visiems
-- užsakymams).
-- (shipdate - orderdate)
-- 15. Rask 3 teritorijas, kuriose pristatymas trunka ilgiausiai (pagal vidurkį).
-- 16. Apskaičiuok kiekvienos teritorijos pardavimo kanalų pasiskirstymą (% online vs
-- direct).
-- (Skaičiuoti kanalų dalį iš visų užsakymų pagal teritoriją)
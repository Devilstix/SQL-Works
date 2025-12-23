
-- Temos: Query Optimization su AdventureWorks2019
-- Naudojamos lentelės: production_product, sales_salesorderdetail

-- =========================================
-- Užduotis 1:
-- Patikrink, ar lentelėje sales_salesorderdetail yra indeksas ant productid.
-- Jei ne – sukurk jį.
-- Tada parašyk užklausą, kuri atrenka visus parduotus kiekius produktui su productid = 800.
-- Patikrink EXPLAIN rezultatus.
-- =========================================

SHOW INDEXES FROM sales_salesorderdetail;

EXPLAIN
SELECT
	pp.ProductID
	, pp.Name
    , COUNT(soh.SalesOrderID) AS Count
FROM sales_salesorderdetail soh 
JOIN production_product pp ON pp.ProductID = soh.ProductID
WHERE pp.ProductID = 800;




SELECT
	pp.ProductID
	, pp.Name
    , COUNT(soh.SalesOrderID) AS Count
FROM production_product pp 
JOIN sales_salesorderdetail soh  ON pp.ProductID = soh.ProductID
WHERE pp.ProductID = 800;


-- =========================================
-- Užduotis 2:
-- Sukurk composite index ant sales_salesorderdetail (productid, orderqty).
-- Tada parašyk užklausą, kuri atrenka visus produktus, kurių užsakymo kiekis didesnis nei 5 ir productid = 800.
-- =========================================

CREATE INDEX product_orderqty ON sales_salesorderdetail (productid, orderqty);

EXPLAIN
SELECT 
	ProductID
    , OrderQty
FROM sales_salesorderdetail
WHERE OrderQty > 5 AND ProductID = 800;
	
-- =========================================
-- Užduotis 3:
-- Parašyk JOIN užklausą, kuri grąžina produkto pavadinimą, kiekį ir orderid.
-- JOIN tarp production_product ir sales_salesorderdetail.
-- Filtruok tik orderqty > 10.
-- Patikrink EXPLAIN.
-- =========================================

-- =========================================
-- Užduotis 4:
-- Parašyk blogą ir gerą WHERE pavyzdį:
-- a) Naudok funkciją: WHERE ROUND(orderqty, 0) = 10
-- b) Pataisyk, kad būtų galima naudoti indeksą
-- =========================================

-- =========================================
-- Užduotis 5:
-- Palygink šias dvi užklausas:
-- a) IN subquery: grąžina visų produktų pavadinimus, kurie yra parduoti
-- b) EXISTS versija – tą patį per EXISTS
-- Patikrink EXPLAIN ir palygink našumą.
-- =========================================

-- 1. Klientų lojalumo analizė.
-- Scenarijus: Įmonės rinkodaros komanda 2014 m. birželio 30 d.siekia įvertinti klientų
-- lojalumą. Jūsų užduotis skirta įvertinti klientų elgseną laike. Reikia nustatyti, kurie klientai
-- pirmą kartą užsakė 2013 metais ir kiek vidutiniškai išleido tais metais, ir ar jie užsakė dar
-- kartą ir kiekvieno užsakymo sumą 2014 metais.

WITH first_order AS (
    SELECT 
        c.customerid,
        MIN(soh.orderdate) AS first_order_date
    FROM sales_salesorderheader soh
    JOIN sales_customer c ON soh.customerid = c.customerid
    GROUP BY c.customerid),
customers_2013 AS (
    SELECT
        c.customerid,
        p.firstname AS vardas,
        p.lastname AS pavarde,
        ROUND(AVG(soh.totaldue), 2) AS uzsakymo_vidurkis_2013
    FROM sales_salesorderheader soh
    JOIN sales_customer c ON soh.customerid = c.customerid
    JOIN person_person p ON c.personid = p.businessentityid
    JOIN first_order fo ON fo.customerid = c.customerid
    WHERE YEAR(fo.first_order_date) = 2013
    GROUP BY c.customerid, p.firstname, p.lastname)
SELECT
    cu.customerid AS id,
    cu.vardas,
    cu.pavarde,
    cu.uzsakymo_vidurkis_2013,
    soh.salesorderid AS uzsakymoID,
    soh.orderdate AS uzsakymo_data,
    ROUND(soh.totaldue, 2) AS suma,
    DENSE_RANK() OVER 
		(PARTITION BY cu.customerid ORDER BY soh.orderdate) AS ranking
FROM customers_2013 cu
LEFT JOIN sales_salesorderheader soh 
    ON cu.customerid = soh.customerid 
   AND YEAR(soh.orderdate) = 2014
ORDER BY cu.customerid, ranking;



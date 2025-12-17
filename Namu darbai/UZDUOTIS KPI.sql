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

SELECT
	CASE
		WHEN soh.OnlineOrderFlag =  1 THEN 'Online'
        ELSE 'Direct'
        END AS Tipas
	, ROUND(SUM(sod.LineTotal),2) AS Suma
FROM sales_salesorderheader soh
JOIN sales_salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY Tipas
ORDER BY Suma DESC;
-- 3. Apskaičiuok bendrą produktų pardavimo sumą (linetotal), suskirstytą pagal kanalą.
-- 4. Rask 5 labiausiai parduodamus produktus kiekviename kanale pagal kiekį.
-- 5. Rask klientus, kurie bent du kartus pirko online arba direct kanalu.
-- 6. Naudojant CTE, rask tik online užsakymus, kurių suma viršija online užsakymų
-- vidurkį.
-- 7. Rask visus produktus, kurie buvo bent kartą parduoti, ir apskaičiuok jų pelną
-- (listprice - standardcost).
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
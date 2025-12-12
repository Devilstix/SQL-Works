-- ============================================================
-- 4. Suskaičiuoti, kiek kiekviena parduotuvė turi klientų
-- Sakila DB – aiškus paaiškinimas ir abu veikiančiai variantai
-- ============================================================

-- ------------------------------------------------------------
-- PAPRASTAS VARIANTAS 
-- ------------------------------------------------------------
-- Logika:
-- 1) Lentelėje customer yra store_id – tai reiškia,
--    kad kiekvienas klientas priklauso vienai parduotuvei.
-- 2) Todėl sprendimas vykdomas tiesiogiai iš customer,
--    nereikalingi JOIN.
-- ------------------------------------------------------------

SELECT 
    store_id,
    COUNT(*) AS customer_count
FROM customer
GROUP BY store_id;


-- ------------------------------------------------------------
-- IŠPLĖSTINIS VARIANTAS (VERSLO KONTEKSTAS)
-- ------------------------------------------------------------
-- Logika:
-- 1) Norime matyti ne tik parduotuvės ID, bet ir jos lokaciją.
-- 2) Parduotuvė turi address_id → city → country.
-- 3) Prijungiame customer, kad suskaičiuoti, kiek klientų priklauso.
-- ------------------------------------------------------------

SELECT 
    s.store_id,
    CONCAT(ci.city, ', ', co.country) AS store_location,
    COUNT(c.customer_id) AS customer_count
FROM store s
JOIN address a   ON s.address_id = a.address_id
JOIN city ci     ON a.city_id = ci.city_id
JOIN country co  ON ci.country_id = co.country_id
JOIN customer c  ON s.store_id = c.store_id
GROUP BY s.store_id, store_location
ORDER BY s.store_id;

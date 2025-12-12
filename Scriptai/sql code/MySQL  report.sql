-- =====================================================================================
--  INVENTORIAUS & PARDUOTUVIŲ PAJAMŲ ATASKAITA
-- Nesutvarkyta vs. Profesionaliai sutvarkyta versija
-- Sakila DB
-- =====================================================================================

USE sakila;

-- =====================================================================================
-- 1. RAW NESUTVARKYTA UŽKLAUSA
-- -------------------------------------------------------------------------------------
-- Verslo klausimas:
--   "Norim suprasti, kiek parduotuvės sugeneravo pajamų per laikotarpį."
-- Tai blogas pavyzdys:
--  - nėra granularity
--  - nėra formatavimo
--  - nėra grupavimo
--  - sunku skaityti
-- =====================================================================================

SELECT
    store.store_id,
    payment.payment_date,
    payment.amount,
    film.title,
    category.name
FROM payment
JOIN rental      ON payment.rental_id = rental.rental_id
JOIN inventory   ON rental.inventory_id = inventory.inventory_id
JOIN store       ON inventory.store_id = store.store_id
JOIN film        ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category    ON film_category.category_id = category.category_id
ORDER BY payment.payment_date
LIMIT 200;

-- =====================================================================================
-- PROBLEMA:
--   - Nesuagreguota
--   - Nenormalizuota granularity
--   - Neaiški verslo prasmė
--   - Negalima naudoti ataskaitoje
-- =====================================================================================



-- =====================================================================================
-- 2. TVARKINGA & PROFESIONALI ATASKAITA
-- -------------------------------------------------------------------------------------
-- VERSLO ATASKAITOS KLAUSIMAS:
--   "Kokios buvo parduotuvių pajamos per metus ir mėnesius pagal filmų kategorijas?"
--
-- Pagerinimai:
--    aiški granularity: YEAR + MONTH
--    KPI: SUM(amount), COUNT(payments)
--    pridėta dimensija: parduotuvė + kategorija
--    tvarkinga struktūra
--    išvalytas laikas iki mėnesio lygio
-- =====================================================================================

SELECT
    s.store_id,
    CONCAT(ci.city, ', ', co.country) AS store_location,
    DATE_FORMAT(p.payment_date, '%Y-%m') AS yearmonth,
    c.name AS category,
    SUM(p.amount) AS revenue,
    COUNT(*) AS transactions,
    ROUND(AVG(p.amount), 2) AS avg_payment
FROM payment p
JOIN rental r        ON p.rental_id = r.rental_id
JOIN inventory i     ON r.inventory_id = i.inventory_id
JOIN store s         ON i.store_id = s.store_id
JOIN address a       ON s.address_id = a.address_id
JOIN city ci         ON a.city_id = ci.city_id
JOIN country co      ON ci.country_id = co.country_id
JOIN film f          ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c      ON fc.category_id = c.category_id
GROUP BY
    s.store_id,
    store_location,
    yearmonth,
    category
ORDER BY
    s.store_id,
    yearmonth,
    category;


-- =====================================================================================
-- 3.  KPI IR SEGMENTAVIMAS
-- -------------------------------------------------------------------------------------
-- Papildomas analitinis sluoksnis:
--   kategorijos klasifikuojamos pagal revenue į HIGH/MID/LOW
--   (pagal bendrą vidurkį)
-- =====================================================================================

SELECT
    s.store_id,
    CONCAT(ci.city, ', ', co.country) AS store_location,
    DATE_FORMAT(p.payment_date, '%Y-%m') AS yearmonth,
    c.name AS category,
    SUM(p.amount) AS revenue,
    CASE
        WHEN SUM(p.amount) > (SELECT AVG(amount) * 150 FROM payment) 
            THEN 'HIGH PERFORMING'
        WHEN SUM(p.amount) < (SELECT AVG(amount) * 50 FROM payment)
            THEN 'LOW'
        ELSE 'AVERAGE'
    END AS performance_bucket
FROM payment p
JOIN rental r        ON p.rental_id = r.rental_id
JOIN inventory i     ON r.inventory_id = i.inventory_id
JOIN store s         ON i.store_id = s.store_id
JOIN address a       ON s.address_id = a.address_id
JOIN city ci         ON a.city_id = ci.city_id
JOIN country co      ON ci.country_id = co.country_id
JOIN film f          ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c      ON fc.category_id = c.category_id
GROUP BY
    s.store_id,
    store_location,
    yearmonth,
    category
ORDER BY
    yearmonth,
    store_id,
    category;

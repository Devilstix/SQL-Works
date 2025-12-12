-- =====================================================================================
-- SAKILA – MySQL FUNCTIONS + JOINS DEMO (BEGINNERS → ŠIEK TIEK ADVANCED)
-- Date, numeric, string ir control flow funkcijos su verslo pavyzdžiais
-- NAUDOJAMA: sakila DB
-- =====================================================================================

USE sakila;

-- =====================================================================================
-- BENDRA PASTABA APIE DATAS IR CURDATE()
-- -------------------------------------------------------------------------------------
-- Sakila yra DEMO duomenų bazė, kurios datos baigiasi apie 2006 metus.
-- Jei naudosime CURDATE() (šiandienos datą), pvz. 2025-11-26:
--
--   WHERE rental_date > DATE_SUB(CURDATE(), INTERVAL 90 DAY)
--
-- sąlyga VISADA bus FALSE, nes visos rental_date yra 2005–2006 metais.
-- Todėl statinėse bazėse (tokiose kaip Sakila) vietoje CURDATE()
-- naudojame „paskutinę datą duomenyse“, pvz.:
--
--   (SELECT MAX(rental_date) FROM rental)
--
-- ir su ja dirbame kaip su "dabar" šioje DB.
-- =====================================================================================



-- =====================================================================================
-- 1. DATE FUNKCIJOS + JOIN
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Kokios buvo pajamos per PASKUTINES 30 dienų (pagal duomenis) kiekvienoje parduotuvėje?"
--
-- Verslo prasmė:
--   - trumpalaikė parduotuvių veiklos analizė
--   - ar naujausiame periode kuri nors parduotuvė silpnesnė?
--
-- NAUDOJAMOS FUNKCIJOS:
--   - MAX(payment_date) – surasti „naujausią“ datą DB
--   - DATE_SUB()        – gauti datą prieš 30 dienų nuo naujausios
--   - DATE()            – dienos lygio grupavimui
-- =====================================================================================

SELECT
    s.store_id,
    CONCAT(ci.city, ', ', co.country) AS store_location,
    DATE(p.payment_date) AS payment_day,
    SUM(p.amount) AS daily_revenue
FROM payment p
JOIN rental r    ON p.rental_id  = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s     ON i.store_id   = s.store_id
JOIN address a   ON s.address_id = a.address_id
JOIN city ci     ON a.city_id    = ci.city_id
JOIN country co  ON ci.country_id = co.country_id
WHERE p.payment_date > (
    SELECT DATE_SUB(MAX(payment_date), INTERVAL 30 DAY)
    FROM payment
)
GROUP BY
    s.store_id,
    store_location,
    DATE(p.payment_date)
ORDER BY
    s.store_id,
    payment_day;



-- =====================================================================================
-- 2. DATE FUNKCIJOS + CONTROL FLOW: AKTYVŪS VS „AT RISK“ KLIENTAI
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Kuriuos klientus laikyti AKTYVIAIS (nuomavo naujausiame 90 d. periode),
--    o kurie yra rizikoje (nesinuomavo ilgiau nei 90 d.)?"
--
-- Verslo prasmė:
--   - klientų segmento analizė
--   - re-aktivacijos kampanijos
--
-- NAUDOJAMOS FUNKCIJOS:
--   - MAX(rental_date)
--   - DATE_SUB()
--   - CASE
-- =====================================================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    DATE(MAX(r.rental_date)) AS last_rental_date,
    CASE
        WHEN MAX(r.rental_date) IS NULL THEN 'NO RENTALS'
        WHEN MAX(r.rental_date) >= (
            SELECT DATE_SUB(MAX(rental_date), INTERVAL 90 DAY)
            FROM rental
        ) THEN 'ACTIVE (last 90 days window)'
        ELSE 'AT RISK (>90 days from last window start)'
    END AS activity_status
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    last_rental_date IS NULL,
    last_rental_date DESC;



-- =====================================================================================
-- 3. NUMERIC FUNKCIJOS: KATEGORIJŲ VIDUTINĖ KAINA VS BENDRAS VIDURKIS
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Kurios filmų kategorijos yra brangesnės už bendrą katalogo vidurkį?"
--
-- Verslo prasmė:
--   - kainodaros analizė
--   - „premium“ kategorijų identifikavimas
--
-- NAUDOJAMOS FUNKCIJOS:
--   - AVG()
--   - ROUND()
--   - subquery bendram vidurkiui  ;)
--   - CASE
-- =====================================================================================

SELECT
    c.name AS category_name,
    ROUND(AVG(f.rental_rate), 2) AS category_avg_rate,
    ROUND((SELECT AVG(rental_rate) FROM film), 2) AS global_avg_rate,
    CASE
        WHEN AVG(f.rental_rate) > (SELECT AVG(rental_rate) FROM film)
            THEN 'ABOVE AVERAGE PRICE'
        WHEN AVG(f.rental_rate) < (SELECT AVG(rental_rate) FROM film)
            THEN 'BELOW AVERAGE PRICE'
        ELSE 'AROUND AVERAGE'
    END AS price_position
FROM film f
JOIN film_category fc ON f.film_id     = fc.film_id
JOIN category c       ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY category_avg_rate DESC;



-- =====================================================================================
-- 4. NUMERIC + CONTROL FLOW: KLIENTŲ REVENUE SEGMENTAVIMAS
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Kaip suskirstyti klientus į pajamų segmentus: LOW / MEDIUM / HIGH?"
--
-- Verslo prasmė:
--   - lojalumo segmentai
--   - VIP klientų identifikavimas
--
-- NAUDOJAMOS FUNKCIJOS:
--   - SUM(amount)
--   - CASE
-- =====================================================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_revenue,
    CASE
        WHEN SUM(p.amount) < 50 THEN 'LOW VALUE'
        WHEN SUM(p.amount) BETWEEN 50 AND 150 THEN 'MEDIUM VALUE'
        ELSE 'HIGH VALUE'
    END AS revenue_segment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;



-- =====================================================================================
-- 5. STRING FUNKCIJOS: FILMŲ PAVADINIMŲ TRANSFORMACIJOS
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Kaip apdoroti filmų pavadinimus marketingo / ataskaitų tikslais?"
--
-- Verslo prasmė:
--   - pavadinimų valymas
--   - vienodinimas (UPPER/LOWER)
--   - ženkliukų nustatymas pagal pavadinimą
--
-- NAUDOJAMOS FUNKCIJOS:
--   - LOWER(), UPPER()
--   - REPLACE()
--   - LEFT()
--   - LENGTH()
--   - SUBSTRING()
-- =====================================================================================

-- 5.1. Paversti į didžiąsias ir mažąsias raides

SELECT
    film_id,
    title,
    LOWER(title) AS title_lower,
    UPPER(title) AS title_upper
FROM film
LIMIT 10;


-- 5.2. -- Pakeičiam žodį A i THE į  visų filmų description
 
   SELECT
    film_id,
    title,
    description AS original_description,
    REPLACE(description, 'A ', 'THE ') AS edited_description
FROM film
WHERE description LIKE 'A %'
LIMIT 15;




-- 5.3. Filmų aprašymų ilgis ir „preview“

SELECT
    film_id,
    title,
    LENGTH(description) AS description_length,
    SUBSTRING(description, 1, 50) AS preview_text
FROM film
ORDER BY description_length DESC
LIMIT 20;


-- 5.4. Ženkliukas pagal žodžius pavadinime (pvz. ACTION / LOVE)

SELECT
    film_id,
    title,
    CASE
        WHEN UPPER(title) LIKE '%ACTION%' THEN 'ACTION TAG'
        WHEN UPPER(title) LIKE '%LOVE%'   THEN 'ROMANCE TAG'
        ELSE 'OTHER'
    END AS title_tag
FROM film
LIMIT 50;



-- =====================================================================================
-- 6. STRING FUNKCIJOS: PILNAS KLIENTO VARDAS + MIESTAS
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Sugeneruoti pilną klientų vardą ir gyvenamąją vietą ataskaitoms/CRM."
--
-- Verslo prasmė:
--   - paruošti duomenis eksportui
--   - gražesni human-readable įrašai
--
-- NAUDOJAMOS FUNKCIJOS:
--   - CONCAT()
--   - CONCAT_WS()
-- =====================================================================================

SELECT
    c.customer_id,
    CONCAT_WS(' ', c.first_name, c.last_name) AS full_name,
    CONCAT(ci.city, ', ', co.country) AS city_country,
    c.email
FROM customer c
JOIN address a  ON c.address_id  = a.address_id
JOIN city ci    ON a.city_id     = ci.city_id
JOIN country co ON ci.country_id = co.country_id
ORDER BY full_name
LIMIT 50;



-- =====================================================================================
-- 7. CONTROL FLOW: FILMŲ KAINŲ SEGMENTAI (LOW / MID / HIGH)
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Kaip suskirstyti filmus į kainų segmentus pagal rental_rate?"
--
-- Verslo prasmė:
--   - kainodaros strategija
--   - katalogo struktūravimas
--
-- NAUDOJAMOS FUNKCIJOS:
--   - CASE
-- =====================================================================================

SELECT
    f.film_id,
    f.title,
    f.rental_rate,
    CASE
        WHEN f.rental_rate < 2.0 THEN 'LOW PRICE'
        WHEN f.rental_rate BETWEEN 2.0 AND 3.0 THEN 'MID PRICE'
        ELSE 'HIGH PRICE'
    END AS price_segment
FROM film f
ORDER BY f.rental_rate, f.title;




-- =====================================================================================
-- 8. DATE + CONTROL FLOW: KLIENTŲ GYVAVIMO CIKLAS (LIFECYCLE)
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Priskirti klientams statusą: NEW, ACTIVE, AT RISK, LOST."
--
-- Logika (pagal naujausią rental datą DB, ne pagal šiandieną):
--   - Naujausia data DB: (SELECT MAX(rental_date) FROM rental)
--   - NEW: pirmoji nuoma per paskutines 30 dienų nuo naujausios datos
--   - ACTIVE: bent viena nuoma per paskutines 90 dienų
--   - AT RISK: paskutinė nuoma 91–365 dienų senumo nuo naujausios datos
--   - LOST: > 365 dienų arba niekada nenuomavo
--
-- NAUDOJAMOS FUNKCIJOS:
--   - MIN(rental_date), MAX(rental_date)
--   - DATEDIFF()
--   - CASE
-- =====================================================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    MIN(r.rental_date) AS first_rental_date,
    MAX(r.rental_date) AS last_rental_date,
    CASE
        WHEN MAX(r.rental_date) IS NULL THEN 'NO RENTALS (PROSPECT)'
        WHEN DATEDIFF(
                 (SELECT MAX(rental_date) FROM rental),
                 MIN(r.rental_date)
             ) <= 30
             THEN 'NEW (first rental in last 30 days window)'
        WHEN DATEDIFF(
                 (SELECT MAX(rental_date) FROM rental),
                 MAX(r.rental_date)
             ) <= 90
             THEN 'ACTIVE'
        WHEN DATEDIFF(
                 (SELECT MAX(rental_date) FROM rental),
                 MAX(r.rental_date)
             ) BETWEEN 91 AND 365
             THEN 'AT RISK'
        ELSE 'LOST'
    END AS lifecycle_status
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY lifecycle_status, last_rental_date;



-- =====================================================================================
-- 9. DATE + NUMERIC: MĖNESINĖS PAJAMOS IR VIDUTINĖ ČEKIO VERTĖ
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Kokios yra mėnesinės pajamos ir vidutinė vieno mokėjimo suma?"
--
-- Verslo prasmė:
--   - sezoniškumo analizė
--   - ar keičiasi vidutinio čekio dydis
--
-- NAUDOJAMOS FUNKCIJOS:
--   - YEAR()
--   - MONTH()
--   - DATE_FORMAT()
--   - SUM(), AVG(), COUNT()
-- =====================================================================================

SELECT
    YEAR(p.payment_date) AS year,
    MONTH(p.payment_date) AS month,
    DATE_FORMAT(p.payment_date, '%m-%Y') AS yearmonth,
    SUM(p.amount) AS total_revenue,
    ROUND(AVG(p.amount), 2) AS avg_payment_amount,
    COUNT(*) AS payments_count
FROM payment p
GROUP BY
    YEAR(p.payment_date),
    MONTH(p.payment_date),
    yearmonth
ORDER BY year, month;



-- =====================================================================================
-- 10. STRING + CONTROL FLOW: FILMŲ PAVADINIMAI, PRASIDEDANTYS "THE"
-- -------------------------------------------------------------------------------------
-- VERSLO KLAUSIMAS:
--   "Kiek filmų aprašymų  prasideda 'A', ir kaip juos pažymėti?"
--
-- Verslo prasmė:
--   - pavadinimų standartizavimas
--   - filtravimas ataskaitose
--
-- NAUDOJAMOS FUNKCIJOS:
--   - UPPER()
--   - LEFT()
--   - CASE
-- =====================================================================================

SELECT
    f.film_id,
    f.title, description,
    CASE
        WHEN UPPER(LEFT(f.description, 2)) = 'A '
            THEN 'DESCRIPTION STARTS WITH A'
        ELSE 'OTHER'
    END AS title_group
FROM film f
ORDER BY title_group, f.title
LIMIT 50;


-- =====================================================================================



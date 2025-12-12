-- ============================================================
-- SELF JOIN SAKILA DB
-- Nuo paprastų iki sudėtingesnių, su verslo scenarijais
-- ============================================================

USE sakila;

-- ============================================================
-- 1. PAPRASTAS SELF JOIN: KLIENTŲ POROS TOJE PAČIOJE PARDUOTUVĖJE
-- ------------------------------------------------------------
-- Verslo scenarijus:
--   Norime rasti klientų PORAS, priklausančias tai pačiai parduotuvei.
--   Galima naudoti:
--   - rekomendacijoms (draugų / šeimos pasiūlymai)
--   - parduotuvės lojalumo analizei
--
-- Idėja:
--   customer savę jungiam per store_id.
--   Naudojame <, kad išvengtume dubliavimo (1-2 ir 2-1) ir savęs su savimi.
-- ============================================================
select * from customer;
SELECT
    c1.store_id,
    c1.customer_id AS customer1_id,
    CONCAT(c1.first_name, ' ', c1.last_name) AS customer1_name,
    c2.customer_id AS customer2_id,
    CONCAT(c2.first_name, ' ', c2.last_name) AS customer2_name
FROM customer AS c1
JOIN customer AS c2
    ON c1.store_id = c2.store_id
   AND c1.customer_id < c2.customer_id
ORDER BY c1.store_id, customer1_id, customer2_id;


-- ============================================================
-- 2. SELF JOIN PER MIESTĄ: KLIENTAI IŠ TO PATIES MIESTO
-- ------------------------------------------------------------
-- Verslo scenarijus:
--   Norime rasti klientus, gyvenančius tame pačiame mieste.
--   Galima naudoti:
--   - vietinėms akcijoms (city-based marketing)
--   - regioninei analitikai (miestų segmentavimas)
--
-- Idėja:
--   customer savę jungiam per tą patį city, bet city laikomas address+city.
--   c1 ir c2 – du skirtingi klientai, tas pats miestas.
-- ============================================================

SELECT
    ci.city,
    c1.customer_id AS customer1_id,
    CONCAT(c1.first_name, ' ', c1.last_name) AS customer1_name,
    c2.customer_id AS customer2_id,
    CONCAT(c2.first_name, ' ', c2.last_name) AS customer2_name
FROM customer AS c1
JOIN customer AS c2
    ON c1.customer_id < c2.customer_id                   -- skirtingi klientai
JOIN address AS a1 ON c1.address_id = a1.address_id
JOIN address AS a2 ON c2.address_id = a2.address_id
JOIN city AS ci1  ON a1.city_id = ci1.city_id
JOIN city AS ci2  ON a2.city_id = ci2.city_id
JOIN city AS ci   ON ci1.city_id = ci2.city_id           -- tas pats miestas
ORDER BY ci.city, customer1_id
LIMIT 50;


-- ============================================================
-- 3. SELF JOIN FILMŲ LENTELĖJE: PANAŠŪS FILMAI
-- ------------------------------------------------------------
-- Verslo scenarijus:
--   Norime surasti "panašių filmų" poras:
--   - tas pats reitingas (rating)
--   - panaši trukmė (length +/- 5 min)
--   Galima naudoti:
--   - rekomendacijų sistemoms
--   - katalogo optimizavimui (dvigubai panašūs titulai)
--
-- Idėja:
--   film savę jungiam ant panašių savybių.
-- ============================================================

SELECT
    f1.film_id      AS film1_id,
    f1.title        AS film1_title,
    f2.film_id      AS film2_id,
    f2.title        AS film2_title,
    f1.rating,
    f1.length       AS film1_length,
    f2.length       AS film2_length
FROM film AS f1
JOIN film AS f2
    ON f1.film_id < f2.film_id               -- poros be dublikatų
   AND f1.rating = f2.rating                 -- tas pats reitingas
   AND ABS(
         CAST(f1.length AS SIGNED) 
       - CAST(f2.length AS SIGNED)
       ) <= 5                                -- panaši trukmė (±5 min)
ORDER BY f1.rating, film1_id, film2_id
LIMIT 50;


-- ============================================================
-- 4. SELF JOIN NUOMOSE: "BINGE-WATCHING" ARBA KELIOS NUOMOS TĄ PAČIĄ DIENĄ
-- ------------------------------------------------------------
-- Verslo scenarijus:
--   Norime rasti klientus, kurie tą pačią dieną nuomojasi kelis filmus.
--   Galima naudoti:
--   - aktyvių klientų identifikavimui
--   - "binge-watching" elgsenai
--
-- Idėja:
--   rental savę jungiam per:
--   - tą patį customer_id
--   - tą pačią datą (DATE(rental_date))
--   - skirtingus rental_id
-- ============================================================

SELECT
    r1.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    DATE(r1.rental_date) AS rental_day,
    r1.rental_id AS rental1_id,
    r2.rental_id AS rental2_id
FROM rental AS r1
JOIN rental AS r2
    ON r1.customer_id = r2.customer_id
   AND r1.rental_id   < r2.rental_id
   AND DATE(r1.rental_date) = DATE(r2.rental_date)
JOIN customer AS c
    ON r1.customer_id = c.customer_id
ORDER BY r1.customer_id, rental_day, rental1_id, rental2_id
LIMIT 50;


-- ============================================================
-- 5. SELF JOIN NUOMOSE: GALIMI PERSIDENGIANTYS NUOMOS PERIODAI
-- ------------------------------------------------------------
-- Verslo scenarijus:
--   Kontrolė / anomalijos:
--   - ar klientas turi kelias aktyvias nuomas tuo pačiu metu?
--   - ar sistemoje nėra loginių klaidų su return_date?
--
-- Supaprastinta logika:
--   - tas pats customer_id
--   - r1.rental_date < r2.return_date
--   - r2.rental_date < r1.return_date
--   (periodai persidengia)
-- ------------------------------------------------------------
-- Pastaba:
--   Sakilos duomenys nėra ideali "periodų" bazė, bet pavyzdys
--   gerai parodo self join ant intervalų logikos.
-- ============================================================

SELECT
    r1.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    r1.rental_id   AS rental1_id,
    r1.rental_date AS rental1_start,
    r1.return_date AS rental1_end,
    r2.rental_id   AS rental2_id,
    r2.rental_date AS rental2_start,
    r2.return_date AS rental2_end
FROM rental AS r1
JOIN rental AS r2
    ON r1.customer_id = r2.customer_id
   AND r1.rental_id   < r2.rental_id
   AND r1.return_date IS NOT NULL
   AND r2.return_date IS NOT NULL
   AND r1.rental_date < r2.return_date   -- periodų persidengimo sąlygos
   AND r2.rental_date < r1.return_date
JOIN customer AS c
    ON r1.customer_id = c.customer_id
ORDER BY r1.customer_id, rental1_start, rental2_start;


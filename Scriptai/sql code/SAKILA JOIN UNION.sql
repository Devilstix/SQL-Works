-- ============================================================
-- SAKILA JOIN & UNION 
-- Beginners  SQL
-- ============================================================

USE sakila;

-- ============================================================
-- 1. INNER JOIN
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Kokie klientai atliko mokėjimus?
-- Šis JOIN parodo tik tuos, kurių duomenys sutampa abiejose lentelėse.
-- ============================================================

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    p.payment_id,
    p.amount
FROM customer c
JOIN payment p
    ON c.customer_id = p.customer_id
ORDER BY c.customer_id
LIMIT 200;


-- ============================================================
-- 2. LEFT JOIN
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Kokie klientai turi arba NETURI mokėjimų?
-- LEFT JOIN parodys VISUS klientus, o mokėjimų nebuvimas bus NULL.
-- ============================================================

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    p.payment_id,
    p.amount
FROM customer c
LEFT JOIN payment p
    ON c.customer_id = p.customer_id
ORDER BY c.customer_id;


-- ============================================================
-- 3. RIGHT JOIN
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Ar egzistuoja mokėjimų, kurių klientas nerandamas?
-- Sakiloje tokių duomenų nėra, todėl RIGHT JOIN elgiasi kaip INNER JOIN.
-- Naudojama tik demonstracijai.
-- ============================================================

SELECT 
    c.customer_id,
    c.first_name,
    p.payment_id,
    p.amount
FROM customer c
RIGHT JOIN payment p
    ON c.customer_id = p.customer_id
ORDER BY p.payment_id
LIMIT 200;


-- ============================================================
-- 4. FULL OUTER JOIN emuliacija (MySQL neturi FULL JOIN)
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Parodyti:
--   - klientus, turinčius mokėjimų (LEFT JOIN)
--   - mokėjimus, neturinčius klientų (RIGHT JOIN - teoriškai)
-- UNION apjungia abi puses.
-- ============================================================

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    p.payment_id,
    p.amount
FROM customer c
LEFT JOIN payment p 
    ON c.customer_id = p.customer_id

UNION

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    p.payment_id,
    p.amount
FROM customer c
RIGHT JOIN payment p 
    ON c.customer_id = p.customer_id;


-- ============================================================
-- 5. Kategorijos ir filmai: INNER JOIN (tik tie, kurie turi ryšį)
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Parodyti filmą ir jo kategoriją, tik jei kategorija yra.
-- ============================================================

SELECT 
    f.film_id,
    f.title,
    c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c       ON fc.category_id = c.category_id
ORDER BY f.title;


-- ============================================================
-- 6. Kategorijos ir filmai: LEFT JOIN (rodyti ir be kategorijos)
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Kurie filmai neturi kategorijų? (NULL reikšmės)
-- ============================================================

SELECT 
    f.film_id,
    f.title,
    c.name AS category
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c       ON fc.category_id = c.category_id
ORDER BY f.title;


-- ============================================================
-- 7. UNION
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Išvesti miestų ID iš klientų adresų ir parduotuvių adresų,
-- be pasikartojimų (unikalus sąrašas).
-- ============================================================

SELECT city_id
FROM address

UNION ALL

SELECT city_id
FROM store
JOIN address ON store.address_id = address.address_id;


-- ============================================================
-- 8. UNION ALL
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Tas pats kaip aukščiau, bet neišmetant dublikatų.
-- Šis variantas greitesnis, nes nedaro DISTINCT.
-- ============================================================

SELECT city_id
FROM address

UNION -- ALL

SELECT city_id
FROM store
JOIN address ON store.address_id = address.address_id;


-- ============================================================
-- 9. UNION vs UNION ALL 
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Išvesti visų darbuotojų ir klientų el. pašto adresų sąrašą.
-- ============================================================

-- be pasikartojimų:
SELECT email
FROM staff

UNION

SELECT email
FROM customer;

-- su pasikartojimais:
SELECT email
FROM staff

UNION ALL

SELECT email
FROM customer;


-- ============================================================
-- 10. LABAI AIŠKUS JOIN VS LEFT JOIN pavyzdys
-- ------------------------------------------------------------
-- Verslo klausimas:
-- Gauti filmus ir jų nuomos skaičių.
-- Su INNER JOIN matysime tik tuos, kurie buvo nuomoti.
-- Su LEFT JOIN matysime VISUS filmus.
-- ============================================================

-- Tik nuomoti filmai (INNER)
SELECT 
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS rentals
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rentals DESC;

-- Visi filmai (LEFT)
SELECT 
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS rentals
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rentals DESC;

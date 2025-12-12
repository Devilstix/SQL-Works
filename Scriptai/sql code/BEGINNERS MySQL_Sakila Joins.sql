-- ============================================
-- BEGINNERS JOIN DEMO – SAKILA DATABASE
-- JOIN pagrindai su verslo kontekstu
-- ============================================
USE sakila;

-- ============================================
-- 1. PAPRASTAS 2-TABLE JOIN
-- Verslo kontekstas:
-- "Norime pamatyti klientų adresus – kas yra mūsų
--  klientų bazė ir kur jie gyvena."
-- ============================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    a.postal_code,
    a.phone
FROM customer AS c
JOIN address AS a
    ON c.address_id = a.address_id
LIMIT 20;


-- ============================================
-- 2. 3-TABLE JOIN: KLIENTAI IR MIESTAI
-- Verslo kontekstas:
-- "Norime pasižiūrėti, kokiuose miestuose turime
--  daugiausiai klientų (lokalios rinkos analizė)."
-- ============================================

-- 2.1. Klientų sąrašas su miestu ir šalimi
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ci.city,
    co.country
FROM customer AS c
JOIN address AS a
    ON c.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id
JOIN country AS co
    ON ci.country_id = co.country_id
LIMIT 20;

-- 2.2. Klientų skaičius per miestą (kiek klientų turime kiekviename mieste)
SELECT
    ci.city,
    co.country,
    COUNT(*) AS customers_count
FROM customer AS c
JOIN address AS a
    ON c.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id
JOIN country AS co
    ON ci.country_id = co.country_id
GROUP BY ci.city, co.country
ORDER BY customers_count DESC
LIMIT 20;


-- ============================================
-- 3. JOIN SU PAYMENT: PAJAMOS PAGAL KLIENTĄ
-- Verslo kontekstas:
-- "Norime rasti, kurie klientai generuoja daugiausiai pajamų."
-- ============================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_revenue
FROM payment AS p
JOIN customer AS c
    ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================
-- 4. GRANDINĖ: PAYMENT -> RENTAL -> INVENTORY -> FILM
-- Verslo kontekstas:
-- "Norime suprasti, kurie filmai (produktai) generuoja daugiausiai pajamų."
-- ============================================

SELECT
    f.film_id,
    f.title,
    SUM(p.amount) AS film_revenue,
    COUNT(p.payment_id) AS rentals_count
FROM payment AS p
JOIN rental AS r
    ON p.rental_id = r.rental_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY film_revenue DESC
LIMIT 20;


-- ============================================
-- 5. GRANDINĖ: STORES (PARDUOTUVĖS) IR LOKACIJA
-- Verslo kontekstas:
-- "Norime palyginti parduotuvių rezultatus (store performance)."
-- ============================================

SELECT
    s.store_id,
    CONCAT(ci.city, ', ', co.country) AS store_location,
    SUM(p.amount) AS store_revenue,
    COUNT(p.payment_id) AS payments_count
FROM payment AS p
JOIN rental AS r
    ON p.rental_id = r.rental_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN store AS s
    ON i.store_id = s.store_id
JOIN address AS a
    ON s.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id
JOIN country AS co
    ON ci.country_id = co.country_id
GROUP BY s.store_id, store_location
ORDER BY store_revenue DESC;


-- ============================================
-- 6. MANY-TO-MANY PER JUNGIMO LENTELĘ (BRIDGE)
-- PAVYZDYS: FILM – CATEGORY
-- Verslo kontekstas:
-- "Norime pamatyti pajamas pagal filmų kategorijas (žanrus)."
-- ============================================

SELECT
    c.name AS category_name,
    SUM(p.amount) AS category_revenue,
    COUNT(DISTINCT f.film_id) AS films_in_category
FROM payment AS p
JOIN rental AS r
    ON p.rental_id = r.rental_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS c
    ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY category_revenue DESC;


-- ============================================
-- 7. MANY-TO-MANY: FILM – ACTOR
-- Verslo kontekstas:
-- "Norime pamatyti, kurie aktoriai žaidžia konkrečiame filme
--  (naudinga marketingui, žvaigždžių komunikacijai)."
-- ============================================

-- 7.1. Aktorių sąrašas vienam konkrečiam filmui (pvz. 'ACADEMY DINOSAUR')
SELECT
    f.title,
    a.actor_id,
    a.first_name,
    a.last_name
FROM film AS f
JOIN film_actor AS fa
    ON f.film_id = fa.film_id
JOIN actor AS a
    ON fa.actor_id = a.actor_id
WHERE f.title = 'ACADEMY DINOSAUR';


-- 7.2. Aktorių skaičius per filmą (kiek aktorių dalyvauja kiekviename filme)
SELECT
    f.film_id,
    f.title,
    COUNT(a.actor_id) AS actors_count
FROM film AS f
JOIN film_actor AS fa
    ON f.film_id = fa.film_id
JOIN actor AS a
    ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title
ORDER BY actors_count DESC, f.title
LIMIT 20;


-- ============================================
-- 8. LEFT JOIN PAGRINDAI
-- Verslo kontekstas:
-- "Norime pamatyti ir tuos objektus, kurie neturi susijusių įrašų."
-- ============================================

-- 8.1. Visi klientai ir jų paskutinė nuoma (jei yra)
-- LEFT JOIN – rodome visus klientus, net jei jie
-- dar nieko nenuomavo (potenciali klientų aktyvinimo kampanija).
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    MAX(r.rental_date) AS last_rental_date
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY last_rental_date IS NULL, last_rental_date DESC
LIMIT 30;


-- 8.2. Visos kategorijos ir filmų skaičius jose
-- LEFT JOIN – jei ateityje atsirastų kategorijų be filmų,
-- jos vis tiek būtų matomos, kad pastebėtume "tuščias" kategorijas.
SELECT
    c.category_id,
    c.name AS category_name,
    COUNT(f.film_id) AS films_count
FROM category AS c
LEFT JOIN film_category AS fc
    ON c.category_id = fc.category_id
LEFT JOIN film AS f
    ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name
ORDER BY films_count DESC, c.name;


-- ============================================
-- 9. LEFT JOIN: FILMAI BE NUOMŲ (SILPNI PRODUKTAI)
-- Verslo kontekstas:
-- "Norime identifikuoti filmus, kurie nesinuomojami –
--  gal juos reikia išimti iš katalogo arba pakeisti kainodarą."
-- ============================================

SELECT
    f.film_id,
    f.title,
    COUNT(p.payment_id) AS rentals_count
FROM film AS f
LEFT JOIN inventory AS i
    ON f.film_id = i.film_id
LEFT JOIN rental AS r
    ON i.inventory_id = r.inventory_id
LEFT JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title
HAVING rentals_count = 0
ORDER BY f.title
LIMIT 50;


-- ============================================
-- 10. JOIN SU DARBUOTOJAIS (STAFF PERFORMANCE)
-- Verslo kontekstas:
-- "Norime palyginti darbuotojų veiklą – kiek pajamų jie generuoja."
-- ============================================

SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    COUNT(DISTINCT r.rental_id) AS rentals_handled,
    SUM(p.amount) AS revenue_generated
FROM staff AS s
JOIN rental AS r
    ON s.staff_id = r.staff_id
JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY revenue_generated DESC;


-- ============================================
--  JOIN demonstruoja:
-- - 2-table ir 3-table INNER JOIN (customer–address–city)
-- - Grandines JOIN per kelias lenteles (payment–rental–inventory–film–store)
-- - Many-to-many per jungimo lentelę (film_category, film_actor)
-- - LEFT JOIN, kai norime matyti įrašus be atitikmenų
-- - Tipinius verslo klausimus:
--     * top klientai
--     * top filmai
--     * pajamos pagal kategoriją ir parduotuvę
--     * klientų aktyvumas
--     * darbuotojų performance
-- ============================================

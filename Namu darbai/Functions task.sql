-- MySQL functions Tasks
-- BONUS už gražų kodą ir gerą formatavimą, įvairius kodų variantus, kūrybiškumą
-- USE SAKILA:
-- Naudoti
-- 1. Raskite aktorių vardus, kurių pavardė prasideda raide „A“, ir pridėkite simbolių skaičių
-- prie kiekvieno jų vardo.

SELECT
	first_name AS Vardas
    , LENGTH(first_name) `Simboliu skaicius`
FROM actor
WHERE last_name LIKE 'A%';

-- 2. Apskaičiuokite kiekvieno kliento nuomos mokesčio vidurkį.

SELECT
	CONCAT(c.first_name, ' ', last_name) AS `Kliento vardas, pavarde`
    , ROUND(AVG(p.amount), 2) AS `Nuomos mokescio vidurkis`
FROM customer c 
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY `Kliento vardas, pavarde`, c.customer_id
ORDER BY `Nuomos mokescio vidurkis` DESC;

 
-- 3. Sugrupuokite nuomas pagal metus ir mėnesį bei parodykite jų skaičių.

SELECT
     DATE_FORMAT(rental_date, '%Y-%m') AS `Nuomos pradzia`
    , DATE_FORMAT(return_date, '%Y-%m') AS `Nuomos pabaiga`
    , COUNT(rental_id) AS `Nuomu skaicius`
FROM rental
GROUP BY `Nuomos pradzia`, `Nuomos pabaiga`
ORDER BY `Nuomu skaicius` DESC;

SELECT 
    YEAR(rental_date) AS Metai,
    MONTH(rental_date) AS menuo,
    COUNT(*) AS `Nuomu skaicius`
FROM rental
GROUP BY Metai, Menuo
ORDER BY Metai, Menuo;

SELECT
    payment_id,
    DATE(payment_date),
    amount
FROM payment
WHERE payment_date = (
    SELECT MAX(payment_date)
    FROM payment)
ORDER BY amount DESC;

-- 4. Parodykite klientų vardus su jų bendrais mokėjimais, apvalinant iki dviejų skaitmenų po
-- kablelio.

SELECT
	c.first_name AS `Klientu vardas`
    , ROUND(SUM(p.amount), 2)  AS Mokejimai
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name;

-- 5. Rodyti kiekvieną filmą, id, pavadinimo pirmus 2 žodžius ir ar jo trukmė ilgesnė nei
-- vidutinė (IF)

SELECT
	f.film_id AS `Filmo ID`
	,SUBSTRING_INDEX(f.title, ' ', 2) AS `Pirmi du zodziai`,
IF (f.length > (SELECT AVG(length) FROM film),
        'Ilgesnis už vidutinį',
        'Ne ilgesnis už vidutinį') AS `Trukmes tikslinimas`
FROM film f;

-- 6. Išveskite visas kategorijas ir skaičių filmų, priklausančių kiekvienai kategorijai, bendrą
-- pelną, vidutinį nuomos įkainį.

SELECT
	ca.name AS Kategorija
    , COUNT(fc.film_id) AS `Filmu skaicius`
    , SUM(p.amount) AS `Pelnas`
    , ROUND(AVG(f.rental_rate), 2) AS `Vidutinis ikainis`
FROM  category ca
JOIN film_category fc ON ca.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id 
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY ca.category_id, ca.name;


-- 7. Raskite visų nuomų, kurios įvyko darbo dienomis ir savaitgaliais, skaičių ir generuotas
-- sumas

SELECT
	IF(DAYOFWEEK(r.rental_date) BETWEEN 2 AND 6, 'Darbo diena', 'Savaitgalis') AS `Savaites diena`
    , COUNT(r.rental_id) AS `Nuomu skaicius`
    , SUM(p.amount) AS `Uzdarbis`
    FROM rental r
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY `Savaites diena`;
    
    SELECT
    CASE
        WHEN DAYOFWEEK(r.rental_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS rentals_count,
    SUM(p.amount) AS total_revenue
FROM rental AS r
JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY day_type;

SELECT 
    CASE 
        WHEN WEEKDAY(r.rental_date) <= 5 THEN 'Workdays'
        ELSE 'Weekend'
    END AS day_type,
    COUNT(r.rental_id) AS rental_count,
    SUM(p.amount) AS total_amount
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY day_type;
    
-- 8. Išveskite aktorius, kurių vardai yra ilgesni nei 6 simboliai.

SELECT
	 CONCAT_WS(' ', first_name, last_name) AS `Aktoriaus vardas, pavarde 6 simboliai varde`
	FROM actor
    WHERE LENGTH(first_name) > 6; 
    
-- 9. Išveskite filmų pavadinimus kartu su jų kategorijomis, sudarytą viename stulpelyje.

SELECT
	CONCAT(f.title, ' - ', ca.name) AS `Filmas - kategorija`
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ca ON fc.category_id = ca.category_id;

-- 10. Raskite aktoriaus pilną vardą ir kiek filmų jis (ji) suvaidino.

SELECT
	 CONCAT_WS(' ', first_name, last_name) AS `Aktoriaus vardas, pavarde`
     , COUNT(fa.film_id) AS `Suvaidintu filmu skaicius`
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY `Aktoriaus vardas, pavarde`;

-- 11. Parodykite nuomų, kurios buvo grąžintos vėluojant 3 dienas ar daugiau, skaičių.

SELECT
	r.rental_id AS `Nuomos ID`
	, DATEDIFF(r.return_date, r.rental_date) AS `Nuomos laikas`
    , f.rental_duration AS `Galimas nuomos laikas`
    , (DATEDIFF(r.return_date, r.rental_date) - CAST(f.rental_duration as SIGNED)) AS `Velavimo laikas`
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;


 SELECT COUNT(*) AS `Veluojanciu`
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE  r.return_date IS NOT NULL
    AND
  (DATEDIFF(r.return_date, r.rental_date) - CAST(f.rental_duration as SIGNED)) >= 3;
    
    SELECT COUNT(*) AS veluojanciu_nuomu_sk
FROM rental r
 JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE  r.return_date IS NOT NULL
  AND DATEDIFF(r.return_date, r.rental_date) > f.rental_duration + 3;
  
  

  
    
-- 12. Raskite visų filmų pavadinimų raidžių skaičių vidurkį.

SELECT
	AVG(CHAR_LENGTH(title))
FROM film;


SELECT ROUND(AVG(CHAR_LENGTH(REGEXP_REPLACE(title, '[^A-Za-z]', ''))),2) AS avg_letter_count
FROM film;


-- 13. Išveskite klientus, kurių vardai prasideda raide „M“, ir parodykite jų mokėjimų sumą.

SELECT
	c.first_name AS `Vardas`
	, SUM(p.amount) AS `Sumoketa suma`
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE c.first_name LIKE 'M%'
GROUP BY c.first_name
ORDER BY `Sumoketa suma` DESC;
    
-- 14. Apskaičiuokite, kokią pajamų dalį sudaro nuomos, kurios truko mažiau nei 5 dienas.

SELECT
	SUM(p.amount) AS `Pajamu dalis`
FROM payment p
JOIN rental r ON p.customer_id = r.customer_id
WHERE DATEDIFF(r.return_date, r.rental_date) <5;

SELECT 
    SUM(CASE 
            WHEN DATEDIFF(r.return_date, r.rental_date) < 5 
            THEN p.amount 
            ELSE 0 
        END) 
        / SUM(p.amount) AS `Pajamu dalis uz < 5 dienas`
FROM rental r
JOIN payment p ON p.rental_id = r.rental_id;


-- 15. Parodykite filmų trukmes, sugrupuotas pagal intervalus (pvz., 0-60 min, 61-120 min ir t.
-- t.).

SELECT
	CASE
		WHEN f.length BETWEEN 0 AND 60 THEN '0-60 min'
        WHEN f.length BETWEEN 61 AND 120 THEN '61-120 min'
        ELSE '120+'
	END AS `Filmu ilgis`
, COUNT(f.film_id) AS `Filmu skaicius`
FROM film f
GROUP BY 
	CASE
		WHEN f.length BETWEEN 0 AND 60 THEN '0-60 min'
        WHEN f.length BETWEEN 61 AND 120 THEN '61-120 min'
        ELSE '120+'
	END 
ORDER BY `Filmu skaicius`;
    
    
-- 16. Klientai su paskutine nuomos data ir jos mėnesiu

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS `Kliento vardas, pavarde`
    , MAX(r.rental_date) AS `Nuomos data`
    , MONTH(MAX(r.rental_date)) `Nuomos menuo`
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY `Kliento vardas, pavarde`;

-- 17. Kiek nuomų atliko kiekvienas klientas (vardas pavardė sujungti)

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS `Kliento vardas, pavarde`
    , COUNT(r.rental_id) AS `Nuomu skaicius`
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY `Kliento vardas, pavarde`
ORDER BY `Nuomu skaicius` DESC;

-- 18. Rodyti kiekvienos nuomos trukmę dienomis

SELECT
	rental_id AS `Nuomos ID`
	, CASE
    WHEN DATEDIFF(return_date, rental_date) IS NOT NULL THEN DATEDIFF(return_date, rental_date) 
    ELSE 'Negrazino'
    END AS `Nuomos laikas`
FROM rental
ORDER BY `Nuomos laikas`;

SELECT
    rental_id AS `Nuomos ID`,
    IFNULL(DATEDIFF(return_date, rental_date), 'Negrazino') AS `Nuomos laikas`
FROM rental;


-- 19. Priskirti klientui kategoriją pagal jų generuotas sumas (CASE)

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS `Kliento vardas, pavarde`
    , SUM(p.amount) AS `SUMA`
    , CASE
		WHEN SUM(p.amount) < 70 THEN 'NOOB'
        WHEN SUM(p.amount)  BETWEEN 70 AND 120 THEN 'VIDUTINIOKAS'
        ELSE 'BACHURAS'
        END AS `KATEGORIJA`
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY `Kliento vardas, pavarde`
ORDER BY `SUMA`;
	
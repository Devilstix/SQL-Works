-- USE SAKILA;
-- 1. Raskite filmus, kurių nuomos kaina didesnė už visų filmų vidurkį.*/

WITH
	filmu_vidurkis AS (
    SELECT 
		AVG(rental_rate) AS rental_avg
	FROM film)
SELECT
	f.title AS Pavadinimas
FROM film f
CROSS JOIN filmu_vidurkis
WHERE filmu_vidurkis.rental_avg < rental_rate;

-- 2. Raskite klientus, kurių vardas yra ilgesnis nei visų klientų vardų vidutinė trukmė.

WITH
	vardu_vidurkis AS (
    SELECT 
		AVG(char_length(first_name))AS vardo_ilgis
        FROM customer)
SELECT
	first_name
    , char_length(first_name)
FROM customer
CROSS JOIN vardu_vidurkis
WHERE vardu_vidurkis.vardo_ilgis < char_length(first_name);

-- 3. Raskite filmus, kurių trukmė ilgesnė nei vidutinė jų kalbos filmų trukmė.

WITH
	vidurkis AS (
    SELECT
		language_id
        , AVG(length) AS vidutinis_ilgis
	FROM film
    GROUP BY language_id)
SELECT
	f.title AS `Pavadinimas`
    , f.length AS `Filmo trukme`
FROM film f
JOIN vidurkis v ON f.language_id = v.language_id
WHERE f.length > v.vidutinis_ilgis
ORDER BY `Filmo trukme` DESC;
	
-- 4. Raskite klientus, kurie paskutinį kartą nuomojo filmą seniau nei vidutinė visų paskutinių
-- nuomų data.

WITH
	vidutine_trukme AS (
	SELECT
		r.customer_id
		, AVG(r.rental_date) AS vidutine_date
	FROM rental r
    GROUP BY r.customer_id)
SELECT 
	r.customer_id
	, CONCAT(c.first_name, ' ', c.last_name) AS `Kliento vardas, pavarde`
    , MAX(r.rental_date) AS `Paskutine nuoma`
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN vidutine_trukme vt ON r.customer_id = vt.customer_id
WHERE  vt.vidutine_date > MAX(r.rental_date)
GROUP BY r.customer_id, `Kliento vardas, pavarde` ;


WITH paskutines_nuomos AS (
    SELECT
        customer_id,
        MAX(rental_date) AS paskutine_nuoma
    FROM rental
    GROUP BY customer_id
),
vidutine_paskutine AS (
    SELECT AVG(paskutine_nuoma) AS vidutine_data
    FROM paskutines_nuomos
)
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS `Kliento vardas, pavarde`,
    pn.paskutine_nuoma
FROM customer c
JOIN paskutines_nuomos pn ON c.customer_id = pn.customer_id
CROSS JOIN vidutine_paskutine vp
WHERE pn.paskutine_nuoma < vp.vidutine_data
ORDER BY pn.paskutine_nuoma;

-- 5. Raskite filmus, kurių pavadinimo ilgis didesnis nei vidutinis pavadinimų ilgis.

WITH 
	vidutinis_ilgis_pavadinimo AS (
    SELECT 
		title
		, AVG(CHAR_LENGTH(title)) AS vidurkis
    FROM film
    GROUP BY title)
,
	pavadinimo_ilgis AS (
    SELECT
		title
        , CHAR_LENGTH(title) AS pavad_ilgis
	FROM film
    GROUP BY title)
SELECT
	f.title
	, pi.pavad_ilgis
FROM film f
JOIN vidutinis_ilgis_pavadinimo vip ON f.title = vip.title
JOIN pavadinimo_ilgis pi ON f.title = pi.title
WHERE pi.pavad_ilgis > vip.vidurkis;

WITH vidurkis AS (
    SELECT AVG(CHAR_LENGTH(title)) AS pavad_vidurkis
    FROM film
)
SELECT
    title,
    CHAR_LENGTH(title) AS pavadinimo_ilgis
FROM film
CROSS JOIN vidurkis v
WHERE CHAR_LENGTH(title) > v.pavad_vidurkis
ORDER BY pavadinimo_ilgis DESC;
    
        
    
-- 6. Naudojant CTE, raskite kiekvieno kliento bendrą nuomų skaičių, sumą ir priskirkite kategoriją:
-- 'Lojalus', 'Vidutinis', 'Naujokas'.
-- Naudoti Case.

WITH
	statistika AS(
    SELECT
		c.customer_id
		, CONCAT(c.first_name, ' ', c.last_name) AS kliento_vardas
        , COUNT(r.rental_id) AS nuomu_skaicius
        , SUM(p.amount) AS nuomu_suma
	FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY c.customer_id, kliento_vardas)
SELECT
	customer_id
    , kliento_vardas
    , nuomu_skaicius
    , nuomu_suma
	, CASE
			WHEN nuomu_skaicius >= 40 THEN 'Lojalus'
            WHEN nuomu_skaicius BETWEEN	20 AND 40 THEN 'Vidutinis'
            ELSE 'Naujokas'
		END AS 'Kategorija'
FROM statistika;
            

-- 7. Naudojant CTE, raskite kiekvieno filmo aprašymo ilgį simboliais ir pažymėkite, ar jis ilgas
-- (daugiau nei 30 simbolių). Naudoti IF.

WITH
	aprasymu_ilgiai AS (
    SELECT
		film_id AS filmo_id
        , title AS pavadinimas
        , CHAR_LENGTH(description) AS aprasymo_ilgis
	FROM film
    GROUP BY filmo_id, pavadinimas)
SELECT
	filmo_id
    , pavadinimas
    , aprasymo_ilgis
    , IF(aprasymo_ilgis > 30, 'Ilgas', 'Neilgas') AS ilgio_kategorija
FROM aprasymu_ilgiai;

-- 8 Naudodami CTE, suskaičiuokite, kiek klientų gyvena kiekviename mieste, ir pažymėkite, ar
-- klientų skaičius viršija ar ne 10. Case

WITH
	klientai AS (
		SELECT
			COUNT(c.customer_id) AS klientu_skaicius
            , ct.city AS miestas
		FROM customer c
        JOIN address a ON c.address_id = a.address_id
        JOIN city ct ON a.city_id = ct.city_id
        GROUP BY ct.city)
SELECT
	miestas
    , klientu_skaicius
    , CASE 
			WHEN klientu_skaicius > 10 THEN 'Virsija 10'
            ELSE 'Nevirsija 10'
            END AS 'Ar virsija 10'
FROM klientai
ORDER BY klientu_skaicius DESC;

	
-- 9. Naudojant CTE, raskite kiekvieno darbuotojo vidutinę nuomos sumą ir pažymėkite, ar ji
-- didesnė nei 3. IF.

WITH darbuotoju_vidurkis AS (
    SELECT 
        s.staff_id,
        CONCAT(s.first_name, ' ', s.last_name) AS vardas,
        AVG(p.amount) AS vidurkis
    FROM staff s
    JOIN payment p ON p.staff_id = s.staff_id
    GROUP BY s.staff_id, vardas
)
SELECT 
    staff_id
    , vardas
     , vidurkis
    , IF(vidurkis> 3, 'Didesnė nei 3', 'Nedidesnė nei 3') AS statusas
FROM darbuotoju_vidurkis
ORDER BY vidurkis DESC;

-- 10. Naudodami CTE, suskaičiuokite, kiek kartų kiekvienas filmas buvo išnuomotas ir priskirkite
-- populiarumo lygį. Case.

WITH
	statistika AS (
		SELECT
			f.film_id
            , COUNT(r.inventory_id) AS nuomu_skaicius
		FROM film f
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY f.film_id)
SELECT
	film_id
    , nuomu_skaicius
    , CASE
		WHEN nuomu_skaicius >25 THEN 'Populiarus'
        WHEN nuomu_skaicius BETWEEN 10 AND 25 THEN 'Vidutinis'
        ELSE 'Nepopuliarus'
        END AS 'Populiarumas'
	FROM statistika
    ORDER BY nuomu_skaicius DESC;
    
-- 11. Naudojant CTE, suskaičiuokite kiekvienos kategorijos filmų vidutinę trukmę ir klasifikuokite:
-- 'Trumpi', 'Vidutiniai', 'Ilgi'.

WITH
	statistika AS (
    SELECT 
		ca.name AS kategorija
        , ROUND(AVG(f.length), 2) AS trukmes_vidurkis
	FROM category ca
    JOIN film_category fc ON ca.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    GROUP BY ca.name)
SELECT
	kategorija
    ,  trukmes_vidurkis
    , CASE 
		WHEN  trukmes_vidurkis > 120 THEN 'Ilgi'
        WHEN  trukmes_vidurkis BETWEEN 110 AND 120 THEN 'Vidutiniai'
        ELSE 'Trumpi'
        END AS `Klasifikacija`
	FROM statistika  s
    ORDER BY trukmes_vidurkis DESC ;
    
-- 12. Naudodami CTE, suskaičiuokite, kiek kiekvienas klientas sumokėjo ir ar viršijo bendrą
-- vidurkį. Case.


-- Užduotims atlikti reikalingos šios sakila duomenų bazės lentos: rental, payment,
-- film_category,
-- film, actor, address.
-- USE SAKILA;

-- 1. Kiek skirtingų prekių buvo išnuomota?

SELECT 
	COUNT(DISTINCT inventory_id) AS 'Skirtingos prekes'
FROM rental;


-- 2. Top 5 klientai, kurie daugiausia kartų naudojosi nuomos paslaugomis.

SELECT
	c.customer_id
    , CONCAT(c.first_name, ' ', c.last_name) AS 'Kliento vardas, pavarde'
    , COUNT(rental_id) AS 'Nuomos daznumas'
FROM customer AS c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, 'Kliento vardas, pavarde'
ORDER BY  `Nuomos daznumas` DESC
LIMIT 5;

SELECT
	c.customer_id
    , CONCAT(c.first_name, ' ', c.last_name) AS 'Kliento vardas, pavarde'
    , COUNT(rental_id) AS 'Nuomos daznumas'
FROM customer AS c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, 'Kliento vardas, pavarde'
ORDER BY  COUNT(rental_id) DESC
LIMIT 5;


SELECT
	customer_id
    , COUNT(*) AS 'Nuomos daznumas'
FROM rental
GROUP BY customer_id
ORDER BY COUNT(*) DESC
LIMIT 5;


-- 3. Išrinkti nuomos id, kurių nuomos ir grąžinimo datos sutampa.
-- Rezultatas: nuomos id, nuomos data, grąžinimo data. Pateikti mažėjimo tvarka pagal
-- nuomos
-- id (reikalinga papildoma date() funkcija).

SELECT
	rental_id
    , DATE(rental_date) AS 'Nuomos startas'
    ,DATE(return_date) AS 'Grazinimo data'
FROM rental
WHERE  DATE(rental_date) = DATE(return_date)
ORDER BY rental_id DESC;
	
-- 4. Kuris klientas išleido daugiausia pinigų nuomos paslaugoms? Pateikti tik vieną
-- klientą ir
-- išleistą pinigų sumą.

SELECT
	customer_id,
    SUM(amount) AS 'Kliento islaidos'
FROM
	payment
GROUP BY
	customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;

-- 5. Kiek klientų aptarnavo kiekvienas darbuotojas, kiek nuomos paslaugų pardavė ir
-- už kokią
-- vertę?


SELECT 
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS 'Darbuotojo vardas'
    ,COUNT(DISTINCT r.customer_id) AS 'Aptarnauti klientai',
    COUNT(p.rental_id) AS rentals_sold,
    SUM(p.amount) AS total_value
FROM staff AS s
 JOIN rental AS r 
       ON s.rental_id = r.rental_id
 JOIN payment AS p
       ON  r.staff_id = p.staff_id
GROUP BY 
    s.staff_id;
    
SELECT 
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    COUNT(DISTINCT r.customer_id) AS customers_served,
    COUNT(r.rental_id) AS rentals_sold,
    SUM(p.amount) AS total_value
FROM staff AS s
 JOIN rental AS r 
       ON r.staff_id = s.staff_id
JOIN payment AS p
       ON p.rental_id = r.rental_id
GROUP BY 
    s.staff_id
ORDER BY 
s.staff_id;

SELECT
	staff_id,
    COUNT(DISTINCT customer_id) AS Customer_number,
    COUNT(rental_id) AS Rental_number,
    SUM(amount) AS Total_amount
FROM
	payment
GROUP BY staff_id;



-- 6. Į ekraną išvesti visus nuomos id, kurie prasideda '9', suskaičiuoti jų vertę, pateikti
-- nuo
-- mažiausio nuomos id.

SELECT
	r.rental_id
    , SUM(p.amount) AS 'Verte'
FROM rental r
LEFT JOIN payment AS p ON p.rental_id = r.rental_id
WHERE r.rental_id LIKE '9%'
GROUP BY r.rental_id
ORDER BY r.rental_id ASC;


-- 7. Kurios kategorijos filmų yra mažiausiai?

SELECT
	c.name AS 'Kategorija'
    , COUNT(fc.film_id) AS 'Filmai kategorijoje'
FROM category c
	JOIN film_category AS fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY 'Filmai kategorijoje' ASC;
 LIMIT 1;
 
 SELECT  
 category_id, 
 COUNT(category_id) AS kiekis
FROM film_category 
GROUP BY category_id
ORDER BY kiekis ASC
LIMIT 1;

SELECT
	c.name category,
    count(fc.film_id) total_movies
FROM film f
JOIN fi
lm_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
ORDER BY total_movies asc
LIMIT 1;

-- 8. Į ekraną išvesti filmų aprašymus, kurių reitingas 'R' ir aprašyme yra žodis 'MySQL'.

SELECT
	description AS 'Aprasymas'
    , rating
FROM film
WHERE rating = 'R' 
	AND description LIKE '%MySQL%';
    
-- 9. Surasti filmų id, kurių trukmė 46, 47, 48, 49, 50, 51 minutės.
-- Rezultatas: pateikiamas didėjančia tvarka pagal trukmę.

SELECT
	film_id
    , length
FROM film
WHERE length IN (46, 47, 48, 49, 50, 51)
ORDER BY length ASC;

-- 10. Į ekraną išvesti filmų pavadinimus, kurie prasideda raidė 'G' ir filmo trukmė
-- mažesnė nei 70
-- minučių.

SELECT
	title
    , length
FROM film
WHERE title LIKE 'G%'
	AND length < 70;
    
-- 11. Suskaičiuoti, kiek yra aktorių, kurių pirmoji vardo raidė yra 'A', o pirmoji pavardės
-- raidė 'W'.

SELECT
	COUNT(first_name) AS 'Aktoriai A W'
FROM actor
WHERE first_name LIKE 'A%'
	AND last_name LIKE 'W%';
    
-- 12. Suskaičiuoti kiek yra klientų, kurių pavardėje yra dvi O raidės ('OO').

SELECT
	COUNT(*) AS 'Klientu skaicius OO'
FROM customer
WHERE last_name LIKE '%oo%';

-- 13. Kiek rajonuose skirtingų adresų? Pateikti tuos rajonus, kurių adresų skaičius
-- didesnis arba
-- lygus 9.

SELECT 
	district
    , COUNT(address_id) AS 'Gatviu skaicius'
FROM address
GROUP BY district
HAVING  COUNT(address_id) >= 9;
	
-- 14. Į ekraną išvesti visus unikalius rajonų pavadinimus, kurie baigiasi raide 'D'.

SELECT DISTINCT
	district
FROM address
WHERE district LIKE '%D';

-- 15. Į ekraną išvesti adresus ir rajonus, kurių telefono numeris prasideda ir baigiasi
-- skaičiumi '9'.

SELECT 
	address
    , district
    ,phone
FROM address
WHERE phone LIKE '9%9';


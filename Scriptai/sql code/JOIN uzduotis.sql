-- Atlikti žemiau aprašytas užduotis iš sakila duomenų bazės.
-- USE SAKILA;
-- 1. Suskaičiuoti, kiek yra aktorių, kurių pavardės prasideda A ir B raidėmis.
-- Rezultatas: aktorių skaičius ir pavardės pirmąją raidę.

-- 2. Suskaičiuoti kiek filmų yra nusifilmavę aktoriai.
-- Rezultatas: filmų skaičius, aktoriaus vardas ir pavardė. Pateikti 10 aktorių,
-- nusifilmavusių
-- daugiausiai filmų (TOP 10).

SELECT 
	a.first_name
    , a.last_name
    , COUNT(fa.film_id) as film_count
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 10;

-- 3. Nustatyti kokia yra minimali, maksimali ir vidutinė kaina, sumokama už filmą.
-- Rezultatas: pateikti tik minimalią, maksimalią ir vidutinę kainas.

SELECT
	MIN(rental_rate) AS `MInimali kaina`
    , MAX(rental_rate) AS 'Maksimali kaina'
    , ROUND(AVG(rental_rate), 2) AS `Vidutine kaina`
FROM film;

-- 4. Suskaičiuoti, kiek kiekviena parduotuvė turi klientų.

SELECT
	s.store_id AS `Parduotuves ID`
    , COUNT(c.customer_id) AS `Klientu skaicius`
FROM store AS s
JOIN customer c ON s.store_id = c.store_id
GROUP BY s.store_id
ORDER BY `Klientu skaicius` DESC;

-- 5. Suskaičiuoti kiek yra kiekvieno žanro filmų.
-- Rezultatas: filmų skaičius ir žanro pavadinimą. Rezultatą surikiuoti pagal filmų
-- skaičių
-- mažėjimo tvarka.

SELECT
	COUNT(fc.film_id) AS `Filmu skaicius`
    , c.name AS `Kategorijos pavadinimas`
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY `Kategorijos pavadinimas`
ORDER BY `Filmu skaicius` DESC;

SELECT
	COUNT(fc.film_id) AS `Filmu skaicius`
    , c.name AS `Kategorijos pavadinimas`
FROM film_category fc
JOIN category c ON c.category_id = fc.category_id
GROUP BY `Kategorijos pavadinimas`
ORDER BY `Filmu skaicius` DESC;


-- 6. Sužinoti, kuriame filme vaidino daugiausiai aktorių.
-- Rezultatas: filmo pavadinimas ir aktorių skaičius.

SELECT
	f.title AS `Filmo pavadinimas`
    , COUNT(fa.actor_id) AS `Aktoriu skaicius`
FROM film f 
JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY `Filmo pavadinimas`
ORDER BY `Aktoriu skaicius` DESC
LIMIT 1;


-- 7. Pateikti filmus ir juose vaidinusius aktorius.
-- Rezultatas: filmo pavadinimas, aktoriaus vardas ir pavardė. Rezultate turi būti rodomi
-- tik
-- filmai, kurių identifikatoriaus (film_id) reikšmė yra nuo 1 iki 2. Duomenys rūšiuojami
-- pagal
-- filmo pavadinimą, aktoriaus vardą ir pavardę didėjančia tvarka.

SELECT
	f.title AS `Filmo pavadinimas`
    , CONCAT(a.first_name, ' ', a.last_name) AS `Aktoriaus vardas, pavarde`
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.film_id IN (1, 2)
ORDER BY f.title ASC, `Aktoriaus vardas, pavarde` ASC;


-- 8. Suskaičiuoti, kiek filmų yra nusifilmavęs kiekvienas aktorius.
-- Rezultatas: filmų skaičius, aktoriaus vardas, pavardė. Rezultatą surikiuoti pagal filmų
-- skaičių
-- mažėjančia tvarka ir pagal aktoriaus vardą didėjančia tvarka.

SELECT
	COUNT(fa.film_id) AS `Filmu skaicius`
    ,  CONCAT(a.first_name, ' ', a.last_name) AS `Aktoriaus vardas, pavarde`
FROM film_actor fa
JOIN actor a ON  fa.actor_id = a.actor_id
GROUP BY `Aktoriaus vardas, pavarde`
ORDER BY `Filmu skaicius` DESC, `Aktoriaus vardas, pavarde` ASC;

-- 9. Suskaičiuoti kiek miestų prasideda A, B, C ir D raidėmis.
-- Rezultatas: miestų skaičius ir miesto pavadinimo pirmoji raidė.

SELECT
	COUNT(*) AS `Miestu skaicius`
	, LEFT(city, 1) AS `Miesto pirma raide`
FROM city
WHERE LEFT(city, 1) IN ('A', 'B', 'C', 'D')
GROUP BY LEFT(city, 1)
ORDER BY `Miesto pirma raide`;

-- 10. Suskaičiuoti, kiek kiekvienas klientas yra sumokėjęs pinigų už filmų
-- nuomą.Rezultatas: kliento vardas, pavardė, adresas, apygarda (district) ir sumokėta
-- pinigų suma. Turi
-- būti pateikiami tik tie klientai, kurie yra sumokėję 170 ar didesnę pinigų sumą.


SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS `Kliento vardas, pavarde`,
    a.address AS `Adresas`
    ,a.district AS `Rajonas`
    ,SUM(p.amount) AS `Sumoketa suma`
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY `Kliento vardas, pavarde`, `Adresas`, `Rajonas`
HAVING `Sumoketa suma` >= 170
ORDER BY `Sumoketa suma` DESC;

-- 11. Suskaičiuoti, kiek pinigų už filmus yra sumokėję kiekvienos apygardos klientai
-- kartu.
-- Rezultatas: apygardą (district) ir išleista pinigų suma. Pateikti tik tas apygardas,
-- kurios yra
-- išleidusios daugiau nei 700 pinigų. Duomenis surūšiuoti pagal apygardą didėjančia
-- tvarka.

SELECT
	a.district AS `Apygarda`
    ,  SUM(p.amount) AS `Sumoketa suma`
FROM address a
JOIN customer c ON a.address_id = c.address_id
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY `Apygarda`
HAVING `Sumoketa suma` > 700
ORDER BY `Apygarda` ASC;

-- 12. Suskaičiuoti, kiek filmų nusifilmavo kiekvienas aktorius priklausomai nuo filmo
-- žanro
-- (kategorijos).
-- Rezultatas: filmų skaičius, aktoriaus vardas ir pavardė, filmo žanras (kategorija).
-- Rezultatą
-- surūšiuoti pagal aktoriaus vardą, pavardę, filmo žanrą didėjančia tvarka.

SELECT
		COUNT(*) AS `Filmu skaicius`
        , CONCAT(a.first_name, ' ', a.last_name) AS `Aktoriaus vardas, pavarde`
        , c.name AS `Kategorijos pavadinimas`
FROM film_actor fa
JOIN actor a ON a.actor_id = fa.actor_id
JOIN film_category fc ON fc.film_id = fa.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY `Aktoriaus vardas, pavarde`, `Kategorijos pavadinimas`
ORDER BY `Aktoriaus vardas, pavarde` ASC, c.name ASC;


-- 13. Suskaičiuoti kiek filmų savo filmo aprašyme turi žodį „drama“. (Kiek kartų žodis
-- pasikartoja
-- nėra svarbu).Rezultatas: tik filmų skaičius ir filmo žanras. Pateikti tik tuos filmų žanrus, kurie turi 7
-- ir
-- daugiau filmų, kuriuose yra žodis „drama“ (filmo aprašymui naudoti lauką iš lentos
-- film_text).

SELECT
	COUNT(ft.film_id) AS `Filmu skaicius`
    , c.name AS `Filmo zanras`
FROM film_text ft 
JOIN film_category fc ON ft.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE ft.description LIKE '% drama %' OR ft.description like '% drama' OR ft.description like 'drama %'
GROUP BY `Filmo zanras`
HAVING  COUNT(ft.film_id) >= 7
ORDER BY `Filmu skaicius` DESC;


    
-- 14. Suskaičiuoti kiek klientų yra kiekvienoje šalyje.
-- Rezultatas: klientų skaičius ir šalis. Duomenis surikiuoti pagal klientų skaičių
-- mažėjančia
-- tvarka. Pateikti tik 5 šalis, turinčias daugiausiai klientų.

SELECT
	co.country AS Šalis
    , COUNT(c.customer_id) AS `Klient skaicius`
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id
GROUP BY co.country
ORDER BY `Klientu skaicius` DESC
LIMIT 5;


-- 15. Suskaičiuoti kiekvienoje parduotuvėje bendrai visų klientų sumokėtą sumą.
-- Rezultatas: parduotuvės identifikatorius (store_id), parduotuvės adresas, miestas ir
-- šalis, SUMA

SELECT
	s.store_id 
    , a.address AS Adresas
    , ct.city AS Miestas
    , co.country AS Salis
	, SUM(p.amount) `Klientu sumoketa suma`
FROM store s
JOIN customer c ON s.store_id = c.store_id
JOIN payment p ON c.customer_id = p.customer_id
JOIN address a ON s.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id
GROUP BY 
	s.store_id 
    , a.address 
    , ct.city 
    , co.country;
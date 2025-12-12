USE SAKILA;
-- 1. Raskite, kuriame filme vaidino daugiausia aktorių. Rezultatas: Filmo pavadinimas ir aktorių
-- skaičius.

SELECT
	f.title
    , COUNT(fa.actor_id) AS `Aktoriu skaicius`
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY`Aktoriu skaicius` DESC
LIMIT 1;

-- 2. Kiek kartų filmas „Academy Dinosaur“ buvo išnuomotas parduotuvėje, kurios ID yra 1?
-- Rezultatas: Išnuomotų filmų skaičius.

SELECT
	COUNT(r.rental_id) AS `Nuomu skaicius`
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Academy Dinosaur'
	AND i.store_id = 1;
    

-- 3. Išvardinkite trijų populiariausių filmų pavadinimus. Rezultatas: Filmo pavadinimas, nuomos
-- kartai.

SELECT
	f.title
    , COUNT(r.rental_id) AS `Nuomu skaicius`
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY `Nuomu skaicius` DESC
LIMIT 3;


-- 4. Suskaičiuokite, kiek filmų yra nusifilmavę aktoriai. Rezultatas: Filmų skaičius, aktoriaus
-- vardas ir pavardė. Papildoma sąlyga: Pateikite 10 aktorių, nusifilmavusių daugiausiai filmų (Top
-- 10).

SELECT
	COUNT(fa.film_id) AS `Filmu skaicius`
    , CONCAT(a.first_name, ' ', a.last_name) AS Aktorius
FROM film_actor fa
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY Aktorius
ORDER BY `Filmu skaicius` DESC;

SELECT
	COUNT(fa.film_id) AS `Filmu skaicius`
    , CONCAT(a.first_name, ' ', a.last_name) AS Aktorius
FROM film_actor fa
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY Aktorius
ORDER BY `Filmu skaicius` DESC
LIMIT 10;

-- 5. Suskaičiuokite, kiek yra kiekvieno žanro filmų ir kokia yra vidutinė kiekvieno žanro filmo
-- trukmė. Rezultatas: Filmų skaičius ir žanro pavadinimas. Papildoma sąlyga: Rezultatus
-- išrikiuokite pagal vidutinę filmo trukmę mažėjimo tvarka.

SELECT
	COUNT(fc.film_id) AS `Filmu skaicius`
    , c.name AS Zanras
    , ROUND(AVG(f.length), 2) `Vidutine filmo trukme`
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY Zanras
ORDER BY `Vidutine filmo trukme` DESC;


-- 6. Pateikite filmus, kurių film_id reikšmė yra nuo 1 iki 5, ir juose vaidinusius aktorius. Rezultatas:
-- Filmo pavadinimas, aktoriaus vardas ir pavardė. Papildoma sąlyga: Rezultatus išrikiuokite pagal
-- filmo pavadinimą didėjimo tvarka ir pagal aktoriaus vardą bei pavardę mažėjimo tvarka.

SELECT
	f.title AS Pavadinimas
    , CONCAT(a.first_name, ' ', a.last_name) AS `Aktoriaus vardas, pavarde`
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.film_id BETWEEN 1 AND 5
ORDER BY f.title ASC
	, `Aktoriaus vardas, pavarde` DESC;

-- 7. Suskaičiuokite, kiek kiekvienas klientas yra sumokėjęs už filmų nuomą. Rezultatas: Kliento
-- vardas, pavardė, adresas ir sumokėta suma. Papildoma sąlyga: Pateikite tik tuos klientus, kurie
-- yra sumokėję 170 ar didesnę sumą.

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS `Kliento vardas, pavarde`
    , a.address AS Adresas
    , SUM(p.amount) `Sumoketa suma`
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY `Kliento vardas, pavarde`, Adresas
HAVING `Sumoketa suma` >= 170
ORDER BY `Sumoketa suma` DESC;

-- 8. Raskite, kiek filmų nusifilmavo kiekvienas aktorius, priklausomai nuo filmo žanro. Rezultatas:
-- Filmų skaičius, aktoriaus vardas ir pavardė, filmo žanras. Papildoma sąlyga: Rezultatus
-- išrikiuokite pagal aktoriaus vardą, pavardę ir filmo žanrą didėjimo tvarka.

SELECT
	CONCAT(a.first_name, ' ', a.last_name) AS `Aktoriaus vardas, pavarde`
    , c.name AS Zanras
    , COUNT(fc.film_id) AS `Filmu skaicius`
FROM film_category fc
JOIN film_actor fa ON fc.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY 
	`Aktoriaus vardas, pavarde`
    , Zanras
ORDER BY 
	`Aktoriaus vardas, pavarde`
    , Zanras;
    
-- 9. Suskaičiuokite, kiek klientų yra kiekvienoje šalyje. Rezultatas: Šalis ir klientų skaičius.
-- Papildoma sąlyga: Rezultatus išrikiuokite pagal klientų skaičių mažėjimo tvarka. Pateikite tik 5
-- šalis, turinčias daugiausiai klientų.

SELECT
	co.country AS Šalis
    , COUNT(c.customer_id) `Klientų skaičius`
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id
GROUP BY Šalis
ORDER BY `Klientų skaičius` DESC
LIMIT 5;

-- 10. Kuris filmas atnešė didžiausias pajamas? Rezultatas: Filmo pavadinimas ir pajamos.

SELECT
	f.title AS Pavadinimas
    , SUM(p.amount) AS Pajamos
FROM payment p
JOIN rental r ON p.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, Pavadinimas
ORDER BY Pajamos DESC
LIMIT 1;

SELECT 
    f.title AS Pavadinimas
    ,SUM(p.amount) AS Pajamos
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title
ORDER BY Pajamos DESC
LIMIT 1;

-- 11. Kiek kartų buvo nuomojamasi kiekvienoje šalyje? Rezultatas: Šalies pavadinimas, nuomos
-- kartai. Papildoma sąlyga: Išvardinkite tik tas šalis, kuriose buvo nuomojamasi bent kartą.
-- Rezultatus išrikiuokite pagal nuomos kartus mažėjimo tvarka.

SELECT
	co.country AS Šalis
    , COUNT(r.rental_id) AS `Nuomų skaičius`
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id 
JOIN country co ON ct.country_id = co.country_id
GROUP BY Šalis
HAVING `Nuomų skaičius` >= 1
ORDER BY `Nuomų skaičius` DESC;


-- 12. Kiek kartų kiekviena filmo kategorija buvo išnuomota? Rezultatas: Kategorijos pavadinimas,
-- nuomos kartai. Papildoma sąlyga: Rezultatus išrikiuokite pagal nuomos kartus mažėjimo tvarka.

SELECT
	ca.name AS `Kategorijos pavadinimas`
    , COUNT(r.rental_id) AS `Nuomu skaičius`
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category ca ON fc.category_id = ca.category_id
GROUP BY ca.name
ORDER BY `Nuomu skaičius` DESC;

-- 13. Raskite kiekvienoje parduotuvėje bendrai visų klientų sumokėtą sumą. Rezultatas:
-- Parduotuvės ID, adresas, miestas, šalis ir pajamos.

SELECT
	c.store_id AS `Parduotuvės ID`
    , a.address AS Adresas
    , co.country AS Šalis
    , SUM(p.amount) AS Pajamos
FROM customer c
JOIN store s ON c.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY `Parduotuvės ID`, Adresas, Šalis
ORDER BY Pajamos DESC;

-- 14. Išvardinkite lankytojus, kurie nuomavosi „sci-fi“ žanro filmus daugiau nei du kartus.
-- Rezultatas: Lankytojo vardas, pavardė, nuomos kartai. Papildoma sąlyga: Rezultatus išrikiuokite
-- pagal nuomos kartus didėjimo tvarka.

SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS `Kliento vardas, pavarde`
    , COUNT(r.rental_id) AS `Nuomos skaicius`
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category ca ON fc.category_id = ca.category_id
WHERE ca.name = 'Sci-Fi'
GROUP BY `Kliento vardas, pavarde`
HAVING COUNT(r.rental_id) > 2
ORDER BY `Nuomos skaicius` ASC;

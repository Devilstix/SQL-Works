-- Atlikti žemiau aprašytas užduotis iš sakila duomenų bazės film lentelės.
-- USE SAKILA;
-- SELECT * FROM FILM;
-- 1. Susumuoti filmų nuomos trukmes.

SELECT
	SUM(rental_duration) AS 'Bendra trukmė'
FROM film;

-- 2. Suskaičiuoti, kiek yra skirtingu rating reikšmių.

SELECT 
	COUNT(DISTINCT rating) AS 'Skirtingos rating reikšmės'
FROM film;

-- 3. Išrinkti unikalias rating reikšmes.

SELECT DISTINCT
	rating
FROM film;

-- 4. Susumuoti filmų nuomos trukmes pagal rating dimensiją.

SELECT 
	rating
    , SUM(length)
FROM film
GROUP BY rating;


-- 5. Pateikti trumpiausią ir ilgiausią nuomos trukmes.

SELECT 
	MIN(rental_duration) AS 'Trumpiausia nuoma'
    , MAX(rental_duration) AS 'Ilgiausia nuoma'
FROM film;

-- 6. Išrinkti visus filmus, kurių nuomos trukmė didesnė arba lygi 6.

SELECT
	film_id
    , title
    , description
FROM film
WHERE rental_duration >= 6;

-- Rezultatas: film_id, title, description.

-- 7. Kiek yra tokių filmų, kurių nuomos trukmė didesnė arba lygi 6?

SELECT
	COUNT(title) AS 'Filmu skaicius'
FROM film
WHERE rental_duration >= 6;


-- 8. Suskaičiuoti vidutinę nuomos trukmę, pagal dimensijas rating ir special_features.

SELECT
	rating
    , special_features
	, AVG(rental_duration) AS 'Vidutine nuomos trukme'
FROM film
GROUP BY rating, special_features;
    

-- 9. Susumuoti replacement_cost pagal dimensiją special_features ir rezultatą pateikti
-- mažėjimo tvarka.

SELECT
	SUM(replacement_cost) AS 'Pakeitimo kaina'
	, special_features
FROM film
GROUP BY 
	special_features
ORDER BY 
	'Pakeitimo kaina' DESC;
    
-- 10. Išrinkti filmus, kurių pavadinimai prasideda raide 'U'.
-- Rezultatas: film_id, title, description, rating.

SELECT
	film_id
    , title
    , description
    , rating
FROM film
WHERE title LIKE 'U%';

-- 11. Išrinkti filmus, kur special_features turi reikšmę 'Deleted Scenes'.
-- Rezultatas: title, special_features.

SELECT
	title
    , special_features
FROM film
WHERE special_features LIKE '%Deleted Scenes%';

-- 12. Išrinkti filmus, kai nuomos trukmė yra 3 ir reitingas NC-17.
-- Rezultatas film_id, rental_duration, rating.

SELECT
	film_id
    , rental_duration
    , rating
FROM film
WHERE rental_duration = 3
	AND rating LIKE 'NC-17';
    
-- 13. Išrinkti filmus, kai nuomos trukmė yra 4 arba 5, ir pavadinimas prasideda raide
-- 'V'.
-- Rezultatas: title, rental_duration

SELECT
	title
    , rental_duration
FROM film
WHERE 
	rental_duration IN(4,5)
    AND title LIKE 'V%';
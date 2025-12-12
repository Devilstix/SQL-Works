-- INNER JOIN su SUM funkcija
-- Suraskime kiekvienos filmų kategorijos bendrą užsakymų sumą:
SELECT c.name AS category, SUM(p.amount) AS total_sales
FROM payment p
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film_category fc ON i.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales DESC;

select sum(amount) from payment; -- duomenų verifikavimui, patikriname sumą 67406.56

-- LEFT JOIN su COUNT funkcija
-- Rodykime kiekvieną filmų kategoriją su filmų skaičiumi (įskaitant kategorijas, kurios neturi filmų)
SELECT c.name AS category, COUNT(i.film_id) AS film_count
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN inventory i ON fc.film_id = i.film_id
GROUP BY c.name;

-- INNER JOIN su WHERE ir matematiniu operatoriumi
-- Suraskime filmų sąrašą, kurių trukmė yra ilgesnė nei 120 minučių ir kurie priklauso „Action“ kategorijai.
SELECT f.title, f.length, c.name AS category
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE f.length > 120 AND c.name = 'Action';

-- LEFT JOIN su NULL reikšmėmis
-- Suraskime filmus, kurie neturi priskirtos kategorijos
SELECT f.title, fc.category_id
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id IS  NULL;

SELECT c.customer_id, c.first_name, c.last_name, Round(AVG(p.amount), 2) AS avg_payment
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING avg(p.amount) >=5 ; 



-- Union
SELECT first_name, last_name, 'Employee' AS role
FROM staff
UNION
SELECT first_name, last_name, 'Customer' AS role
FROM customer;
-- Union All
SELECT first_name, last_name
FROM staff
UNION ALL
SELECT first_name, last_name
FROM customer;

--  INNER JOIN su matematine operacija ON sąlygoje - Suraskime filmus, kurių identifikatorius (film_id) yra vienu numeriu mažesnis už kategorijų lentelėje nurodytą filmą (film_category.film_id)
/*Paaiškinimas:
•	Pirma lentelė f1 sujungiama su lentelės film_category įrašais, kur film_id iš lentelės film yra lygus vienetu daugiau nei film_category.film_id.
•	Po to prijungiame kitą film įrašą f2, kad sužinotume kitą susijusį filmą.
*/

SELECT f1.title AS film_1, f2.title AS film_2
FROM film f1
INNER JOIN film_category fc ON f1.film_id = fc.film_id - 1
INNER JOIN film f2 ON fc.film_id = f2.film_id;

-- SELF JOIN su skirtingais ID (naudojant !=) Suraskime visus aktorius, kurie yra susiję su bent vienu kitu aktoriumi tame pačiame filme, bet ne pats su savimi.
/*
•	Atliekame SELF JOIN lentelėje film_actor, kad surastume visus aktorius, kurie kartu pasirodė tame pačiame filme.
•	Sąlyga fa1.actor_id != fa2.actor_id užtikrina, kad aktorius nesusijungia pats su savimi.
•	Sujungiame aktorių informaciją iš actor lentelės.*/

SELECT a1.first_name AS actor_1, a1.last_name AS actor_1_last,
       a2.first_name AS actor_2, a2.last_name AS actor_2_last, fa1.film_id
FROM film_actor fa1
INNER JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id != fa2.actor_id
INNER JOIN actor a1 ON fa1.actor_id = a1.actor_id
INNER JOIN actor a2 ON fa2.actor_id = a2.actor_id;
-- <>  !=

-- LEFT JOIN su > operatoriumi: Suraskime visus filmus ir jų inventorių, tačiau rodome tik tuos inventoriaus įrašus, kurių inventory_id yra didesnis už atitinkamą film_id.
-- 	Naudojant LEFT JOIN, gauname visus filmus. Tik tie inventoriaus įrašai, kurių inventory_id yra didesnis už atitinkamą film_id, yra sujungiami.
SELECT f.title, i.inventory_id
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id AND i.inventory_id > f.film_id;

-- INNER JOIN su < operatoriumi: Suraskime visus filmus ir jų nuomos įrašus, kur rental_id yra mažesnis už atitinkamą inventory_id.
SELECT f.title, r.rental_id, i.inventory_id
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id AND r.rental_id < i.inventory_id;

-- SELF JOIN su + operatoriumi (pažangus scenarijus). Suraskime visus filmus, kurių trukmė (length) yra 10 minučių ilgesnė už kito filmo trukmę.
SELECT 
    f1.title AS longer_film,
    f2.title AS shorter_film,
    f1.length AS length_1,
    f2.length AS length_2
FROM
    film f1
        INNER JOIN
    film f2 ON f1.length = f2.length + 10;

-- SELF JOIN kaip analizės priemonė: Naudokite SELF JOIN, jei reikia lyginti įrašus toje pačioje lentelėje pagal matematiką ar nelygybes.


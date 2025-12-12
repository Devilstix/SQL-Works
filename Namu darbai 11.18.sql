-- SQL SAKILA Užduotys


/* ==================== TOPIC: SELECT ==================== */

-- ID 1 | Topic: SELECT
-- LT: Pasirinkite visus filmo lentelės stulpelius ir eilutes.
-- EN: Select all columns and rows from the film table.

-- SELECT 
-- 	*
--  FROM film;






-- ID 2 | Topic: SELECT
-- LT: Iš filmo lentelės pasirinkite tik pavadinimo ir aprašymo stulpelius.
-- EN: Select only the title and description columns from the film table.

-- SELECT 
-- 	title,
--     description
-- FROM film;





-- ID 3 | Topic: SELECT
-- LT: Nuskaitykite klientų vardą, pavardę ir el. pašto adresą.
-- EN: Display customers name, last name and email.

-- SELECT 
-- 	first_name
--     ,last_name
--     ,email
-- FROM customer;

-- ID 4 | Topic: SELECT
-- LT: Nuskaitykite darbuotojo vartotojo vardą ir slaptažodį.
-- EN: Show employee username and password.

-- SELECT 
-- 	username
--     , password
-- FROM staff;

-- ID 5 | Topic: SELECT
-- LT: Nuskaitykite visas kategorijas.
-- EN: Show all categories.

-- SELECT 
-- 	name AS Categories
-- FROM 
-- 	category;


/* ==================== TOPIC: ORDER BY ==================== */

-- ID 6 | Topic: ORDER BY
-- LT: Iš filmo lentelės pasirinkite tik pavadinimo ir nuomos mokesčio stulpelius, ir surūšiuokite rezultatus nuo mažiausio iki didžiausio.
-- EN: Select only the title and rental rate columns from the film table, and order the results from lowest to highest.

-- -- SELECT 
 	-- title,
-- 	rental_rate
-- FROM 		
-- 	film
-- ORDER BY rental_rate ASC;



-- ID 7 | Topic: ORDER BY
-- LT: Gaukite klientų sąrašą ir surūšiuokite juos abėcėlės tvarka pagal jų pavardes. Į rezultatą įtraukite šiuos stulpelius: customer_id, first_name, last_name.
-- EN: Retrieve the list of customers and sort them in alphabetical order by their last name. Include the following columns in the result: customer_id, first_name, last_name.

-- SELECT 
-- 	customer_id,
-- 	first_name,
--     last_name
-- FROM customer
-- ORDER BY last_name ASC;



-- ID 8 | Topic: ORDER BY
-- LT: Gaukite filmų sąrašą ir surūšiuokite juos mažėjančia tvarka pagal jų nuomos trukmę. Rezultate rodykite filmo_id, pavadinimą ir nuomos trukmę.
-- EN: Retrieve the list of films and sort them in descending order based on their rental duration. Display the film_id, title, and rental_duration in the result.

-- SELECT
-- 	film_id
--     , title
--     , rental_duration
-- FROM 
-- 	film
-- ORDER BY 
-- 	rental_duration DESC;


-- ID 9 | Topic: ORDER BY
-- LT: Gaukite klientų sąrašą ir surūšiuokite juos pirmiausia pagal jų pavardes didėjančia tvarka, ir tada pagal vardą mažėjančia tvarka.
-- EN: Retrieve the list of customers and sort them first by their last name in ascending order, and then by their first name in descending order. Include the customer_id, first_name, and last_name columns in the result.

-- SELECT 
-- 	customer_id
--     , first_name
--     , last_name
-- FROM 
-- customer
-- ORDER BY 
-- 	last_name ASC
-- 	,first_name DESC;

-- ID 10 | Topic: ORDER BY
-- LT: Gaukite filmų sąrašą ir surūšiuokite juos pirmiausia pagal išleidimo metus mažėjančia tvarka, ir tada pagal jų pavadinimą didėjančia tvarka. Rezultate rodykite filmo_id, pavadinimą ir išleidimo_metus.
-- EN: Retrieve the list of films and sort them first by their release year in descending order, and then by their title in ascending order. Display the film_id, title, and release_year in the result.

-- SELECT 
-- 	film_id
--     , title
--     , release_year
-- FROM film
-- ORDER BY 
-- 	release_year DESC
--     , title ASC;

/* ==================== TOPIC: LIMIT ==================== */

-- ID 11 | Topic: LIMIT
-- LT: Iš filmų lentelės pasirinkite pirmuosius 10 filmų, surūšiuotų pagal filmo ID.
-- EN: Select the first 10 films from the film table, ordered by film ID.

-- SELECT *
-- 	FROM film
-- ORDER BY film_id ASC
-- LIMIT 10;





-- ID 12 | Topic: LIMIT
-- LT: Gaukite 5 daugiausiai pajamų surinkusius filmus. Rezultate rodykite filmo ID, pavadinimą ir nuomos kainą.
-- EN: Retrieve the top 5 highest-grossing films. Display the film ID, title, and rental rate in the result.

 /*SELECT DISTINCT
 
    , rental_rate
FROM
    film
ORDER BY rental_rate DESC
LIMIT 5;*/
    




-- ID 13 | Topic: LIMIT
-- LT: Ištraukite 10 seniausių filmų. Rezultate rodyti filmo ID, pavadinimą ir išleidimo metus.
-- EN: Retrieve the 10 oldest films. Display the film ID, title, and release year in the result.

-- SELECT 
-- 	film_id
--     , title
--     , release_year
-- FROM film
-- ORDER BY release_year ASC
-- LIMIT 10;

-- ID 14 | Topic: LIMIT
-- LT: Ištraukite 3 paskutinius pridėtus klientus. Rodyti kliento ID, vardą ir pavardę, pavardę ir sukūrimo datą.
-- EN: Retrieve the 3 most recently added customers. Display the customer ID, first name, last name, and creation date in the result.

-- SELECT
-- 	customer_id
--     , first_name
--     , last_name
--     , create_date
-- FROM customer
-- ORDER BY create_date DESC
-- LIMIT 3;



-- ID 15 | Topic: LIMIT
-- LT: Gaukite 7 didžiausius pakeitimo sąnaudų (replacement cost) filmus. Rezultate rodomas filmo ID, pavadinimas ir pakeitimo kaina.
-- EN: Retrieve the 7 highest replacement cost films. Display the film ID, title, and replacement cost in the result.

-- SELECT 
-- 	film_id
--     , title
--     , replacement_cost
-- FROM film
-- ORDER BY replacement_cost DESC
-- LIMIT 7;


/* ==================== TOPIC: DISTINCT ==================== */

-- ID 16 | Topic: DISTINCT
-- LT: Gaukite unikalius filmų reitingus ir surūšiuokite juos abėcėlės tvarka.
-- EN: Retrieve the unique ratings of films available and sort them in alphabetical order.

-- SELECT DISTINCT
--     rating
-- FROM
--     film
-- ORDER BY rating ASC;





-- ID 17 | Topic: DISTINCT
-- LT: Gaukite unikalius aktorių vardus iš duomenų bazės ir surūšiuokite juos atvirkštine abėcėlės tvarka.
-- EN: Retrieve the unique actors' first names from the database and sort them in reverse alphabetical order.

-- SELECT DISTINCT 
-- 	first_name
--     FROM actor
-- ORDER BY 
-- 	first_name DESC;




-- ID 18 | Topic: DISTINCT
-- LT: Gaukite skirtingas filmų nuomos trukmes ir surūšiuokite jas didėjančia tvarka.
-- EN: Retrieve the distinct rental durations of films and sort them in ascending order.

-- SELECT DISTINCT
-- 	rental_duration
-- FROM film
-- ORDER BY 
-- 	rental_duration ASC;

-- ID 19 | Topic: DISTINCT
-- LT: Gaukite unikalius klientų el. laiškus iš duomenų bazės ir surūšiuokite juos abėcėlės tvarka.
-- EN: Retrieve the unique customer emails from the database and sort them in alphabetical order.

-- SELECT DISTINCT
-- 	email
-- FROM customer
-- ORDER BY
-- 	email ASC;
	
-- ID 20 | Topic: DISTINCT
-- LT: Gauti skirtingas mokėjimų sumas iš mokėjimų lentelės ir surūšiuoti jas mažėjančia tvarka.
-- EN: Retrieve the distinct payment amounts from the payment table and sort them in descending order.

-- SELECT DISTINCT	
-- 	amount
-- FROM payment
-- ORDER BY
-- 	amount DESC;

/* ==================== TOPIC: ALIAS ==================== */

-- ID 21 | Topic: ALIAS
-- LT: Pasirinkite ir pervadinkite stulpelį "first_name" į "Customer First Name".
-- EN: Select and rename the "first_name" column to "Customer First Name".

-- SELECT 
-- 	first_name AS 'Customer First Name'
-- FROM customer;





-- ID 22 | Topic: ALIAS
-- LT: Pervadinkite stulpelį "last_name" į "Customer Last Name" ir stulpelį "email" į "Customer Email".
-- EN: Rename the "last_name" column to "Customer Last Name" and the "email" column to "Customer Email".

/*SELECT
	last_name AS 'Customer Last Name',
    email AS 'Customer Email'
    FROM customer;*/





-- ID 23 | Topic: ALIAS
-- LT: Pervadinkite stulpelį "title" į "Film Title", o stulpelį "description" - į "Film Description" ir rodykite tik pirmuosius 10 rezultatų.
-- EN: Rename the "title" column to "Film Title" and the "description" column to "Film Description", and only display the first 10 results.

-- SELECT 
-- 	title AS 'Film Title'
--     , description AS 'Film Description'
-- FROM film
-- LIMIT 10;

-- ID 24 | Topic: ALIAS
-- LT: Gauti skirtingas klientų pavardes ir atitinkamus el. pašto adresus kaip "Customer Email", surūšiuokite juos abėcėlės tvarka pagal pavardę ir apribokite rezultatą iki 5 įrašų.
-- EN: Retrieve the distinct last names of customers and their corresponding email addresses as "Customer Email", and sort them in alphabetical order by the last name and limit the result to 5 records.

-- SELECT DISTINCT
-- 	last_name
--     , email AS 'Customer Email'
-- FROM customer
-- ORDER BY
-- 	last_name ASC
-- LIMIT 5;
	
-- ID 25 | Topic: ALIAS
-- LT: Gaukite filmo pavadinimą, išleidimo metus ir filmų nuomos trukmę. Pateikite lentelės slapyvardį "f" ir stulpelių slapyvardžius "Title", "Year" ir "Duration". Rezultatus surūšiuokite didėjančia tvarka pagal filmo pavadinimą ir apribokite išvestį tik iki 10 įrašų.
-- EN: Retrieve the film title, release year, and rental duration of films. Provide an alias for the table as "f" and aliases for the columns as "Title", "Year", and "Duration". Sort the results in ascending order based on the film title and limit the output to only 10 records.

-- SELECT 
-- 	title AS Title
--     , release_year AS Year
--     , rental_duration AS Duration
-- FROM 
-- 	film AS f
-- ORDER BY 
-- 	title ASC
-- LIMIT 10;


/* ==================== TOPIC: FUNCTIONS ==================== */

-- ID 26 | Topic: FUNCTIONS
-- LT: Suskaičiuokite klientų skaičių klientų lentelėje.
-- EN: Count the number of customers in the customer table.

-- SELECT 
-- 	COUNT(customer_id) AS Total_customers
-- FROM
-- 	customer;





-- ID 27 | Topic: FUNCTIONS
-- LT: Raskite adresų skaičių adresų lentelėje, kurių stulpelyje address2 yra NULL reikšmė ir adresų, kurių stulpelyje address2 nėra NULL, skaičių.
-- EN: Find the number of addresses in the address table that have a NULL value in the address2 column and the number of addresses with a non-NULL address2.

-- SELECT 
-- 	SUM(address2 IS NULL) AS count_NULLS
-- FROM 
-- 	address
-- WHERE address2 IS NULL;

-- SELECT 
-- 	COUNT(address2 IS NOT NULL) AS count_NULLS
-- FROM 
-- 	address
-- WHERE address2 IS NULL;
	




-- ID 28 | Topic: FUNCTIONS
-- LT: Raskite didžiausią kada nors įvykusį mokėjimą.
-- EN: Find the maximum payment ever happened.


-- SELECT 
-- 	MAX(amount)
-- FROM 
-- 	payment;

  
-- ID 29 | Topic: FUNCTIONS
-- LT: Raskite vidutinę visų filmų keitimo kainą, įskaitant tuos filmus, kurių "replacement_cost" stulpelyje yra NULL reikšmė.
-- EN: Find the average replacement cost of all films in the film table, including those that have a NULL value in the "replacement_cost" column.



-- SELECT
-- 	avg(replacement_cost) avg_replacement_cost
-- FROM film
-- WHERE 
-- replacement_cost IS NULL;

-- SELECT
-- 	ROUND(AVG(replacement_cost), 2) avg_replacement_cost,
--     AVG(replacement_cost) as avg_replacement_cost_all,
--     SUM(replacement_cost) / COUNT(replacement_cost) as manual_replacement_cost_avg,
--     AVG(IFNULL(replacement_cost, 0)) AS avg_replacement_cost_NULL
-- FROM film;

-- SELECT 
-- 	COUNT(*) as total_films,
--     ROUND(AVG(replacement_cost), 2) avg_replacement_cost,
--     AVG(replacement_cost) as  avg_replacement_cost_all,
--     SUM(replacement_cost) / COUNT(*) as manual_replacement_cost_avg
-- FROM
--     film;

-- SELECT 
--     COUNT(*) - COUNT(address2) AS 'Addresses null',
--     COUNT(address2) AS 'Addresses'
-- FROM
--     sakila.address;

-- SELECT 
-- 	AVG(IFNULL(replacement_cost, 0)) AS avg_replacement_cost
-- FROM film;


-- ID 30 | Topic: FUNCTIONS
-- LT: Apskaičiuokite bendrą visų filmų, pateiktų filmų lentelėje, ilgį.
-- EN: Calculate the total length of all films in the film table.

-- SELECT
-- 	SUM(length) AS 'Total length'
-- FROM film;


-- ID 31 | Topic: FUNCTIONS
-- LT: Parašykite SQL užklausą, kad apskaičiuotumėte visų nuomos sumų sumą. Rezultatą pateikite kaip "Bendra mokėjimo suma".
-- EN: Write an SQL query to calculate the sum of payment amounts for all rentals. Present the result as "Total Payment Amount".

-- SELECT
-- 	SUM(amount) AS 'Total Payment Amount'
-- FROM payment;


-- ID 32 | Topic: FUNCTIONS
-- LT: Konvertuoti visus filmų lentelės pavadinimus į didžiąsias raides.
-- EN: Convert all titles in the film table to uppercase.

-- SELECT
-- 	UPPER(title) AS title
-- FROM 
-- 	film;

-- ID 33 | Topic: FUNCTIONS
-- LT: Sujunkite kiekvieno kliento vardą ir pavardę iš lentelės "Klientai" į vieną eilutę, atskiriamą tarpu.
-- EN: Combine the first name and last name of each customer in the customer table into a single string, separated by a space.

-- SELECT
-- 	CONCAT(first_name,' ', last_name) AS 'Customer full name'
-- FROM 
-- 	customer;


-- ID 34 | Topic: FUNCTIONS
-- LT: Sujunkite kiekvieno filmo pavadinimą ir aprašymą filmo lentelėje į vieną eilutę, pavadinimą ir aprašymą atskirti dvitaškiu.
-- EN: Combine the title and description of each film in the film table into a single string, with the title and description separated by a colon.

-- SELECT
-- 	CONCAT(title, ': ', description) AS 'Movie description'
-- FROM 
-- 	film;


-- ID 35 | Topic: FUNCTIONS
-- LT: Sujunkite klientų lentelėje esančių klientų vardus ir pavardes į vieną eilutę, su didžiąja raide užrašytu vardu ir mažąja raide užrašyta pavarde.
-- EN: Combine the first and last names of customers in the customer table into a single string, with the first name in uppercase and the last name in lowercase.

-- SELECT
-- 	CONCAT(UPPER(first_name), ' ', LOWER(last_name)) AS 'Customer full name'
-- FROM
-- 	customer;

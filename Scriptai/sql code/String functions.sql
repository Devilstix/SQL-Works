-- MySQL String Functions - leidžia manipuliuoti tekstu ir užtikrinti duomenų analizės tikslumą:

-- 1. CONCAT() 	Funkcija: Apjungia kelis tekstinius laukus į vieną. Sakilos duomenų bazėje sujungiame aktorių vardą ir pavardę. 
	SELECT CONCAT(first_name, ' ', last_name) AS full_name from actor;
    SELECT CONCAT(first_name, ' ', last_name) AS full_name from staff;
    SELECT CONCAT_WS(' ', first_name, last_name) AS full_name from staff;
	-- Galimos klaidos: Jei naudojate NULL reikšmes, funkcija gali grąžinti NULL. Pvz.: 
	SELECT CONCAT(first_name, NULL, last_name) FROM actor;
    
-- Rezultatas bus NULL. Siekiant išvengti šios problemos, naudokite COALESCE() - tikrina, ar yra Null, taip pat galima nurodyti kelias reikšmes - 
SELECT COALESCE(email, 'No email provided') AS email_status 
FROM customer;

SELECT COALESCE(email, customer_id, 'No contact info available') AS contact_info 
FROM customer;

-- SUBSTRING()  	Funkcija: Leidžia išskirti dalį teksto. Ištraukiame pirmus 20 simbolių iš filmo aprašymo.
	
SELECT SUBSTRING(description, 1, 15) AS short_description 
FROM film;


select description from film;

--	Galimos klaidos: Jei indeksas viršija teksto ilgį, funkcija grąžins tuščią rezultatą.

-- 3. LENGTH() 	Funkcija: Grąžina teksto ilgį simboliais. 
	
SELECT title, LENGTH(title) AS title_length 
FROM film WHERE LENGTH(title) > 10;
select title from film;

-- Išfiltruojame filmus, kurių pavadinimas ilgesnis nei 10 simbolių. 	Galimos klaidos: Funkcija skaičiuoja simbolius, įskaitant tarpus, todėl reikėtų tai įvertinti.

-- 4. LOWER() ir UPPER() 	Funkcija: Konvertuoja tekstą į mažąsias (LOWER) arba didžiąsias (UPPER) raides.
	
SELECT UPPER(city) AS uppercase_title 
FROM city;
SELECT LOWER(title) AS lowercase_title 
FROM film;
--	Galimos klaidos: Šios funkcijos gali neveikti tinkamai, jei tekstas yra nestandartinė koduotė.
-- Funcijas galima derinti:
SELECT CONCAT(LOWER(first_name), ' ', LOWER(last_name)) AS full_name_lowercase
FROM actor;


-- 5. REPLACE() 	Funkcija: Leidžia pakeisti teksto dalį.
-- Pakeičiame žodį „amazing“ į „fantastic“ aprašyme. 	Galimos klaidos: Jei nėra sutampančių tekstų, rezultatas nesikeis.
SELECT REPLACE(description, 'Amazing', 'fantastic') AS updated_description 
FROM film WHERE description LIKE '%Amazing%';

SELECT description from film
where description like '%amazing%';

-- 6. TRIM() 	Funkcija: Pašalina tarpus ar kitus simbolius iš teksto pradžios ir pabaigos.

SELECT TRIM(title) AS clean_title 
FROM film;

SELECT TRIM(description) AS clean_title 
FROM film_text;
-- Išvalome nereikalingus tarpus iš filmo pavadinimų.
	-- Galimos klaidos: Netiksli simbolių specifikacija gali palikti nereikalingus simbolius.
/*Konteksto svarba
	Duomenų išsamumas: Jei laukai gali turėti NULL, naudokite COALESCE(), kad išvengtumėte neapibrėžtų rezultatų.
	Numatomi užklausų rezultatai: Tiksliai apibrėžkite užklausos tikslą, kad išvengtumėte perteklinio duomenų apdorojimo. 
    Pvz., jei ieškote tik tam tikrų simbolių, naudokite filtravimą su LIKE arba WHERE.
Efektyvumo didinimas
	Apribokite rezultatų kiekį: Naudokite LIMIT, kad išvengtumėte perteklinio duomenų apdorojimo.
	Derinkite funkcijas: Pvz., sujunkite CONCAT() su LOWER() tam, kad generuotumėte konsoliduotą rezultatą mažosiomis raidėmis.*/



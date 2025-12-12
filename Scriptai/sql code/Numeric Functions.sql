-- Pagrindinės MySQL skaitinės funkcijos

-- 1.	ABS() – grąžina absoliučią skaičiaus reikšmę: 
 
SELECT film_id, ABS(rental_duration - replacement_cost) AS absolute_difference
FROM film
LIMIT 5;
-- Galimos klaidos: Jei laukas rental_duration arba replacement_cost yra NULL, rezultatas irgi bus NULL. Naudokite COALESCE() norėdami apdoroti NULL reikšmes.

-- 2.	CEIL() ir FLOOR() – CEIL() grąžina artimiausią didesnį sveikąjį skaičių, FLOOR() – artimiausią mažesnį:
 
SELECT CEIL(replacement_cost) AS ceiling_value, FLOOR(replacement_cost) AS floor_value
FROM film
WHERE rental_rate > 2.99
LIMIT 5;

-- 3.	ROUND() – suapvalina skaičių iki nurodyto skaitmenų kiekio:
 SELECT ROUND(replacement_cost) AS rounded_cost
FROM film
LIMIT 5;
-- Galimos klaidos: Naudojant per didelį dešimtainių skaitmenų kiekį galima gauti netikslų rezultatą.

 /* MOD() yra MySQL skaitinė funkcija, skirta gauti likutį, kuris lieka padalijus vieną skaičių iš kito. 
Matematiškai tai atitinka modulio operaciją, kurią dažnai naudoja programuotojai ir duomenų analitikai ciklams, sekos generatoriams, grupavimui ar analizei.*/
-- 4.	MOD() – grąžina likutį dalinant skaičių:
 
SELECT title, length, rental_duration, MOD(length, rental_duration) AS remainder
FROM film
WHERE rental_duration > 0
LIMIT 5;
select 86/6 from film;

/*Naudojimo gairės: Naudinga, kai dirbate su ciklais arba grupuočių užklausomis.
Not the same as 86 / 6 = 14.33
86 / 6 = quotient (result of division)

MOD(86, 6) = remainder (what’s left after division)

This is like how in math:

17 ÷ 5 = 3 with remainder 2
because 3×5 = 15 → and 17 − 15 = 2
MOD(a, b) = a - FLOOR(a / b) * b */

-- 5.	POWER() ir SQRT() – POWER() pakelia skaičių laipsniu, SQRT() grąžina kvadratinę šaknį:
 
SELECT title, POWER(length, 3) AS squared_length, SQRT(length) AS square_root
FROM film
LIMIT 5;
-- Galimos klaidos: Jei length yra neigiamas, SQRT() iššauks klaidą. bet turime ABS()


-- 6.	RAND() – generuoja atsitiktinį skaičių:
 
SELECT title, RAND() AS random_value
FROM film
LIMIT 5;
-- Naudojimas: Naudinga, jei reikia atsitiktinių rezultatų, pvz., testuojant.


/*2. Konteksto svarba funkcijų naudojimui
Duomenų išsamumas: Užklausose su NULL reikšmėmis galite patirti netikėtų rezultatų. Pvz., ABS(NULL) grąžins NULL.
Rekomendacija: Naudokite COALESCE(): */
SELECT COALESCE(ABS(rental_duration), 0) AS non_null_value
FROM film;
-- Numatomi rezultatai: Jei užklausoje reikalingas sveikasis skaičius, naudokite ROUND() arba CAST(), arba Truncate():
SELECT CAST(CEIL(replacement_cost) AS UNSIGNED) AS integer_value
FROM film
LIMIT 5;
-- The CAST() function converts a value (of any type) into a specified datatype.
-- CAST(... AS UNSIGNED) means Convert a number to an integer type that cannot be negative.

SELECT CAST(CEIL(replacement_cost) AS SIGNED) AS integer_value
FROM film
LIMIT 5;


SELECT 
  CAST(5.9 AS UNSIGNED) AS a,       
  CAST(-5.9 AS UNSIGNED) AS b,
  CAST(-5.9 AS SIGNED) AS C;     

SELECT TRUNCATE(replacement_cost,0) AS integer_value
FROM film
LIMIT 5;

/* Efektyvumas: Naudokite funkcijas tik tuomet, kai jos būtinos – per daug funkcijų gali lėtinti užklausų vykdymą.

•	Tikslinga funkcijų kombinacija: Suderinkite funkcijas tam, kad sumažintumėte veiksmų kiekį. Pvz., jei reikia suapvalinti ir paversti teigiamu:
•	SELECT ROUND(ABS(replacement_cost), 1) AS positive_rounded_cost
•	FROM film;

4. Dažniausios klaidingos nuomonės
1.	„Funkcijos visada ignoruoja NULL reikšmes“: Tai netiesa. Pvz., SUM() ignoruos NULL, tačiau ABS() ne.
2.	„CEIL() ir ROUND() yra tas pats“: CEIL() visada didina, o ROUND() – apvalina į artimiausią skaičių.


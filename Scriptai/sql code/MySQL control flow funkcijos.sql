/*MySQL control flow funkcijos leidžia valdyti vykdomų užklausų logiką ir priimti sprendimus pagal tam tikras sąlygas. 
Pagrindinės šios kategorijos funkcijos yra IF(), CASE, IFNULL(), COALESCE() ir NULLIF(). */

-- 1. Funkcija CASE leidžia vykdyti sąlyginį vertinimą pagal kelis skirtingus scenarijus.  Pavyzdys: Kategorizuojame filmus pagal jų nuomos kainą (rental_rate).
SELECT title, rental_rate,
       CASE 
           WHEN rental_rate > 4.99 THEN 'Brangus'
           WHEN rental_rate BETWEEN 2.99 AND 4.99 THEN 'Vidutinė kaina'
           ELSE 'Nebrangus'
       END AS price_category
FROM film;
--  Galima klaida: Jei rental_rate turi NULL reikšmių, verta naudoti COALESCE(rental_rate, 0), kad būtų išvengta netikėtų rezultatų.

-- 2. IF() funkcija veikia kaip paprastesnis CASE variantas, tinkantis situacijoms su dviem rezultatais.
 -- Pavyzdys: Nustatome, ar klientas yra „aktyvus“ per pastaruosius 3 mėn. pagal jo paskutinę nuomos datą.
SELECT 
    c.customer_id, 
    IF(DATEDIFF(MAX(r.rental_date), MIN(r.rental_date)) <= 90, 'Aktyvus', 'Neaktyvus') AS statusas
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

 -- Galima klaida: IF() neveiks, jei reikia daugiau nei dviejų alternatyvų—tokiu atveju geriau naudoti CASE.

-- 3. IFNULL() Naudojama pakeisti NULL reikšmes alternatyviomis.  Pavyzdys: Jei klientas neturi emailo, vietoj jo pateikiame „Neįvestas “.
SELECT customer_id, IFNULL(email, 'Neįvestas') AS contact_info
FROM customer;

select * from staff;
SELECT staff_id, IFNULL(password, 'Neįvestas') AS psw_check
FROM staff;
 -- Galima klaida: Jei laukiamas NULL, bet duomenų bazėje reikšmė nėra NULL, IFNULL() nepakeis duomenų.

-- 4. COALESCE() Funkcija grąžina pirmąją nenulinę reikšmę iš pateiktų reikšmių.  Pavyzdys: Kliento kontaktų parinkimas (telefonas pirmas, jei nėra – el. paštas, jei nėra – tekstinė žinutė).
SELECT 
    c.customer_id, 
    COALESCE(a.phone, c.email, 'Neįvesti kontaktai') AS contact_info
FROM customer c
JOIN address a ON c.address_id = a.address_id;

SELECT 
  staff_id, 
    COALESCE(password, email, 'Neįvesta') AS staff_check
FROM staff;

 -- Galima klaida: Jei visos pateiktos reikšmės yra NULL, COALESCE() grąžins NULL.

-- 5. NULLIF()   funkcija grąžina NULL, jei dvi reikšmės yra identiškos, kitu atveju – pirmąją reikšmę.
 -- Pavyzdys: Filmo nuomos kainos nustatymas—jei kaina lygi 0.99, grąžiname NULL, kitaip rodome reikšmę.
SELECT 
    title,
    rental_rate, 
    NULLIF(rental_rate, 0.99) AS adjusted_rate
FROM
    film;
 -- Galima klaida: Jei palyginamos reikšmės skirtingų tipų, gali kilti klaidų.

-- MySQL control flow funkcijos padeda efektyviai tvarkyti duomenų srautus, išvengti klaidų ir optimizuoti užklausų vykdymą. 


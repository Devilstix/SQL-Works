Use sakila;
select * from payment;

/*MySQL comes with the following data types for storing a date or a date/time value in the database:

DATE - format YYYY-MM-DD
DATETIME - format: YYYY-MM-DD HH:MI:SS
TIMESTAMP - format: YYYY-MM-DD HH:MI:SS
YEAR - format YYYY or YY    
*/

/*1. DATE() - Gauti tik datą iš datetime
Aprašymas: Ši funkcija iš datetime tipo reikšmės grąžina tik datą (YYYY-MM-DD). Pavyzdys: Suraskime nuomos pradžios datas iš rental lentelės.*/
SELECT rental_id, DATE(rental_date) AS rental_start_date
FROM rental;

/*2. CURDATE() - Dabartinė data
Aprašymas: Ši funkcija grąžina dabartinę datą (serveryje esamą datą). Pavyzdys: Suraskime visas nuomas, kurios buvo atliktos šiandien.*/
SELECT rental_id, rental_date
FROM rental
WHERE DATE(rental_date) = CURDATE();
-- sakilos atveju
SELECT rental_id, date(rental_date)
FROM rental
WHERE rental_date = (SELECT MAX(rental_date) FROM rental);


/*3. NOW() - Dabartinis datetime
Aprašymas: Grąžina dabartinį laiką (YYYY-MM-DD HH:MM:SS). Pavyzdys: Įterpkime naują mokėjimo įrašą su dabartine data.*/
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (1, 1, 100, 5.99, NOW());

DELETE FROM payment
WHERE customer_id = 1 AND staff_id = 1 AND rental_id = 100 AND amount = 5.99; 

select sum(amount) from payment;
select * from payment
where rental_id = 100; 

/*4. DATE_ADD() - Pridėti laiko periodą prie datos Aprašymas: Leidžia pridėti dienas, mėnesius, metus ar kitas laiko dalis prie datos. 
Pavyzdys: Suraskime nuomas, kurių grąžinimo terminas baigiasi per 7 dienas.*/
SELECT rental_id, DATE(rental_date) ISNUOMUOTA, DATE(DATE_ADD(rental_date, INTERVAL 3 month)) AS due_date
FROM rental;

/*5. DATE_SUB() - Atimti laiko periodą iš datos
Aprašymas: Leidžia atimti laiką iš datos. Pavyzdys: Suraskime nuomas, kurios buvo atliktos prieš 30 dienų. */
SELECT rental_id, rental_date
FROM rental
WHERE rental_date > DATE_SUB(NOW(), INTERVAL 30 DAY);
 
/*6. DATEDIFF() - Dienų skirtumas tarp dviejų datų
Aprašymas: Grąžina dienų skaičių tarp dviejų datų. Pavyzdys: Suraskime skirtumą tarp nuomos pradžios ir grąžinimo datų.*/
SELECT rental_id, DATEDIFF(return_date, rental_date) AS rental_duration
FROM rental;
 SELECT rental_id, abs(DATEDIFF(rental_date, return_date)) AS rental_duration
FROM rental;


/*7. YEAR(), MONTH(), DAY() - Išskirti metus, mėnesį ar dieną
Aprašymas: Šios funkcijos leidžia atskirti metus, mėnesį ar dieną iš datos. Pavyzdžiai:
•	Suraskime, kurių metų nuomos yra įrašytos. */
SELECT DISTINCT YEAR(rental_date) AS rental_year
FROM rental;
-- 	Suraskime visas nuomas, atliktas tam tikrą mėnesį (pvz., vasario).
SELECT rental_id, rental_date, MONTH(rental_date) 
FROM rental
WHERE MONTH(rental_date) = 7;

/*8. STR_TO_DATE() - Konvertuoti tekstą į datą
Aprašymas: Naudojama tekstiniam formatui (pvz., '2025-03-31') konvertuoti į datą. Pavyzdys: Konvertuoti tekstinį įrašą į datą ir naudoti paieškai.*/
SELECT 
  payment_id,
  STR_TO_DATE(DATE_FORMAT(payment_date, '%d-%m-%Y'), '%d-%m-%Y') AS parsed_date
FROM payment
LIMIT 5;

/*9. EXTRACT() - Išskirti specifinę dalį iš datos
Aprašymas: Grąžina konkretų pasirinktą laikotarpį, pvz., metus, mėnesį ar savaitės dieną. Pavyzdys: Suraskime viską :), kai buvo atliktos nuomos.*/
SELECT EXTRACT(YEAR FROM rental_date) AS rental_year,
       EXTRACT(MONTH FROM rental_date) AS rental_month,
       EXTRACT(WEEK FROM rental_date) AS rental_week
FROM rental;


/*10. UNIX_TIMESTAMP() - Konvertuoti datą į timestamp
Aprašymas: Grąžina laiko žymą (timestamp) iš datetime reikšmės. Pavyzdys: Konvertuoti grąžinimo datą į timestamp.*/
SELECT rental_id, return_date, UNIX_TIMESTAMP(return_date) AS return_timestamp
FROM rental;

/*11. FROM_UNIXTIME() - Konvertuoti timestamp į datą
Aprašymas: Konvertuoja timestamp reikšmę į įprastą datetime formatą. Pavyzdys: Konvertuokime timestamp atgal į datą.*/
SELECT FROM_UNIXTIME(UNIX_TIMESTAMP()) AS current_date_time; -- :)

/*12. WEEK(), DAYOFWEEK(), DAYOFMONTH(), DAYOFYEAR() - Išsami informacija apie datą
•	WEEK(): Gauti metų savaitę.
•	DAYOFWEEK(): Savaitės diena (7 = sekmadienis, 6 = šeštadienis).
•	DAYOFMONTH(): Mėnesio diena.
•	DAYOFYEAR(): Dienų skaičius metų pradžioje. Pavyzdys: Gaukime metų savaitę užsakymo metu.*/
SELECT rental_id, WEEK(rental_date) AS rental_week
FROM rental;

SELECT rental_id, DAYOFWEEK( rental_date) AS day_of_week
FROM rental;

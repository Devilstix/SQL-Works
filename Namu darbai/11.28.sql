-- MySQL functions Tasks
-- BONUS už gražų kodą ir gerą formatavimą, įvairius kodų variantus, kūrybiškumą
-- USE SAKILA:
-- Naudoti
-- 1. Raskite aktorių vardus, kurių pavardė prasideda raide „A“, ir pridėkite simbolių skaičių
-- prie kiekvieno jų vardo.

SELECT 
	first_name AS Vardas
	, LENGTH(first_name) AS 'Simboliu skaicius'
FROM actor
WHERE last_name LIKE 'A%';
    
-- 2. Apskaičiuokite kiekvieno kliento nuomos mokesčio vidurkį.

SELECT 
	p.customer_id
    , CONCAT(c.first_name, ' ', c.last_name) AS 'Kliento vardas, pavarde'
    , ROUND(AVG(p.amount), 2) AS 'Nuomos mokescio vidurkis'
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
GROUP BY p.customer_id, `Kliento vardas, pavarde`;

-- 3. Sugrupuokite nuomas pagal metus ir mėnesį bei parodykite jų skaičių.
SELECT
    , YEAR(rental_date) AS Metai
    , MONTH(rental_date) AS Menuo
    , COUNT(rental_id) AS  'Nuomos skaicius'
FROM rental 
GROUP BY YEAR(rental_date), MONTH(rental_date)
ORDER BY Metai, Menuo ASC;

SELECT
	rental_id
	, DATE_FORMAT(rental_date, '%Y-%m')  AS year_month
    , COUNT(*) AS 'Nuomos skaicius'
FROM rental
GROUP BY DATE_FORMAT(rental_date, '%Y-%m')
ORDER BY DATE_FORMAT(rental_date, '%Y-%m');

SELECT
  YEAR(rental_date) AS Metai,
  MONTH(rental_date) AS Menuo,
  COUNT(*) AS Nuomos_skaicius
FROM rental
GROUP BY YEAR(rental_date), MONTH(rental_date)
ORDER BY YEAR(rental_date), MONTH(rental_date);

SELECT
  DATE_FORMAT(rental_date, '%Y-%m') AS year_month,
  COUNT(*) AS Nuomos_skaicius
FROM rental
GROUP BY DATE_FORMAT(rental_date, '%Y-%m')
ORDER BY DATE_FORMAT(rental_date, '%Y-%m');

SELECT DATE_FORMAT(rental_date, '%Y-%m') FROM rental LIMIT 5;
-- 4. Parodykite klientų vardus su jų bendrais mokėjimais, apvalinant iki dviejų skaitmenų po
-- kablelio.
-- 5. Rodyti kiekvieną filmą, id, pavadinimo pirmus 2 žodžius ir ar jo trukmė ilgesnė nei
-- vidutinė (IF)
-- 6. Išveskite visas kategorijas ir skaičių filmų, priklausančių kiekvienai kategorijai, bendrą
-- pelną, vidutinį nuomos įkainį.
-- 7. Raskite visų nuomų, kurios įvyko darbo dienomis ir savaitgaliais, skaičių ir generuotas
-- sumas
-- 8. Išveskite aktorius, kurių vardai yra ilgesni nei 6 simboliai.
-- 9. Išveskite filmų pavadinimus kartu su jų kategorijomis, sudarytą viename stulpelyje.
-- 10. Raskite aktoriaus pilną vardą ir kiek filmų jis (ji) suvaidino.
-- 11. Parodykite nuomų, kurios buvo grąžintos vėluojant 3 dienas ar daugiau, skaičių.
-- 12. Raskite visų filmų pavadinimų raidžių skaičių vidurkį.
-- 13. Išveskite klientus, kurių vardai prasideda raide „M“, ir parodykite jų mokėjimų sumą.
-- 14. Apskaičiuokite, kokią pajamų dalį sudaro nuomos, kurios truko mažiau nei 5 dienas.
-- 15. Parodykite filmų trukmes, sugrupuotas pagal intervalus (pvz., 0-60 min, 61-120 min ir t.
-- t.).
-- 16. Klientai su paskutine nuomos data ir jos mėnesiu
-- 17. Kiek nuomų atliko kiekvienas klientas (vardas pavardė sujungti)
-- 18. Rodyti kiekvienos nuomos trukmę dienomis
-- 19. Priskirti klientui kategoriją pagal jų generuotas sumas (CASE)
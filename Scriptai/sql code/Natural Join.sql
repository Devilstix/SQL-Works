-- ============================================================================================
-- NATURAL JOIN DEMO (Sakila DB)
-- Veikiantys pavyzdžiai + neveikiantys pavyzdžiai + paaiškinimai
-- ============================================================================================

USE sakila;

-- ============================================================================================
-- 1. Kas yra NATURAL JOIN?
-- --------------------------------------------------------------------------------------------
-- NATURAL JOIN automatiškai suranda VISUS bendrus stulpelius pagal pavadinimą
-- ir jais sujungia lenteles.
--
-- Pavojus:
--   - Tu nekontroliuoji, per ką vyksta join.
--   - Jei lentelėse yra keli bendri stulpeliai → join tapo neteisingas.
--   - Jei schema pasikeis → join pradės veikti kitaip.
--
-- Mūsų tikslas: parodyti studentams tiek sėkmingus, tiek KLAIDINGUS atvejus.
-- ============================================================================================



-- ============================================================================================
-- 2. VEIKIANTIS NATURAL JOIN pavyzdys (saugus)
-- --------------------------------------------------------------------------------------------
-- staff ir address turi TIK VIENĄ bendrą stulpelį: address_id
--
-- Verslo scenarijus:
--   "Parodyti darbuotojus ir jų adresus."
-- ============================================================================================

SELECT
    staff_id,
    first_name,
    last_name,
    address,
    district,
    city_id
FROM staff
NATURAL JOIN address
LIMIT 10;

-- Šitas NATURAL JOIN VEIKIA teisingai.
--  - Jungiama per address_id
--  - Nėra jokių kitų bendrų stulpelių → saugus atvejis.



-- ============================================================================================
-- 3. ANTRAS VEIKIANTIS pavyzdys – store + address
-- --------------------------------------------------------------------------------------------
-- Abi lentelės dalijasi address_id ir daugiau nieko.
-- ============================================================================================

SELECT
    store_id,
    address,
    district,
    city_id
FROM store
NATURAL JOIN address
LIMIT 10;

-- Vėl – saugus NATURAL JOIN, nes yra tik vienas bendras raktas.



-- ============================================================================================
-- 4. BLOGAS NATURAL JOIN pavyzdys (NEVEIKIA) – address + city
-- --------------------------------------------------------------------------------------------
-- ČIA DEMONSTRUOJAMAS NATŪRALUS "FAIL"
--
-- Lentelės address ir city turi bendrus stulpelius:
--   city_id        (tinka jungimui)
--   last_update    (NETINKA jungimui)
--
-- NATURAL JOIN bandys sujungti per abu:
--   ON address.city_id = city.city_id
--   AND address.last_update = city.last_update
--
-- last_update reikšmės N E S U T A M P A → todėl 0 eilučių.
--
-- Verslo scenarijus:
--   "Studentai klausia: kodėl nieko negrąžina?"
-- ============================================================================================

SELECT *
FROM address
NATURAL JOIN city;

-- Tikėtinas rezultatas: 0 rows returned
-- Paaiškinimas:
--   last_update N E S U T A M P A tarp address ir city lentelių.
--   Todėl NATURAL JOIN "užgesina" visus rezultatus.



-- ============================================================================================
-- 5. TEISINGA ALTERNATYVA tam pačiam NEveikiančiam pavyzdžiui
-- --------------------------------------------------------------------------------------------
-- Ta pati loginė užklausa, parašyta teisingai:
-- ============================================================================================

SELECT
    a.address_id,
    a.address,
    ci.city,
    ci.country_id
FROM address a
JOIN city ci
  ON a.city_id = ci.city_id
LIMIT 10;

-- Šis JOINS veikia, nes jungiam tik per city_id.
-- NATURAL JOIN prideda last_update ir viską sugadina.



-- ============================================================================================
-- 6. LABAI BLOGAS NATURAL JOIN pavyzdys – daug lentelių
-- --------------------------------------------------------------------------------------------
-- NATURAL JOIN tarp rental, inventory, film, customer būtų katastrofa.
--
-- Jungiama per:
--   - inventory_id
--   - film_id
--   - customer_id
--   - last_update
--   - ir kitus (kaip adresas priklauso nuo schemos)
--
-- DEMONSTRUOJAM KAIP STUDENTAMS "KODĖL NIEKADA TAIP NEDAROM".
-- ============================================================================================

SELECT *
FROM rental
NATURAL JOIN inventory
NATURAL JOIN film
NATURAL JOIN customer
LIMIT 10;

-- Tikėtinas rezultatas:
--   - arba 0 eilučių,
--   - arba supainioti duomenys (klientai sumažinti su ne tais filmais),
--   - arba nelogiškos kombinacijos
--
-- Tai yra blogiausias įmanomas pavyzdys praktikoje.



-- ============================================================================================
-- 7. TEISINGA alternatyva blogam pavyzdžiui
-- --------------------------------------------------------------------------------------------
-- Ta pati verslo logika, kaip ir aukščiau:
--   "Išvesti nuomas su filmu ir klientu"
-- bet su aiškiais ON sąlygų JOIN’ais.
-- ============================================================================================

SELECT
    r.rental_id,
    r.rental_date,
    f.title,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM rental r
JOIN inventory i   ON r.inventory_id = i.inventory_id
JOIN film f        ON i.film_id = f.film_id
JOIN customer c    ON r.customer_id = c.customer_id
ORDER BY r.rental_id
LIMIT 10;



-- ============================================================================================
-- 8. Gerosios praktikos
-- --------------------------------------------------------------------------------------------
-- NATURAL JOIN naudoti tik tuomet:
--     Kai lentelės turi TIK vieną bendrą stulpelį.
--     Kai žinai, kad schema nesikeis.
--     Kai tai DEMO pavyzdys mokymams.
--
-- Blogosios praktikos:
--     Nenaudoti su SELECT *
--     Nenaudoti BI, Dashboardams, Produkcijai
--     Nenaudoti kai lentelės turi last_update, status, active, created_at ir pan.
--     Nenaudoti daugiau nei su 2 lentelėmis
-- ============================================================================================



-- ============================================================================================
-- 9. NATURAL JOIN → rekomenduojama alternatyva
-- --------------------------------------------------------------------------------------------
-- 1) JOIN ... ON        – aiškiausia, saugiausia ir profesionaliausia praktika.
-- 2) JOIN ... USING     – tinka, kai stulpelių pavadinimai sutampa.
-- ============================================================================================


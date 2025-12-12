-- ============================================================
-- SAKILA – JOIN ... ON vs JOIN ... USING
-- Paaiškinimai, verslo pavyzdžiai, gerosios praktikos
-- ============================================================

USE sakila;

-- ============================================================
-- 1. PAGRINDINĖ IDĖJA
-- ------------------------------------------------------------
-- JOIN ... ON:
--   - Lankstus, aiškus, visada veikia.
--   - Naudojamas, kai stulpeliai gali turėti skirtingus pavadinimus
--     arba reikia sudėtingesnių sąlygų.
--
-- JOIN ... USING(col):
--   - Trumpesnis, bet veikia tik tada, kai abu stulpeliai turi
--     TOKĮ PATĮ pavadinimą.
--   - Rezultate gaunamas tik vienas stulpelis 'col' vietoj dviejų.
--
-- GEROJI PRAKTIKA:
--   - Produkcijoj ir BI pasaulyje dažniausiai naudojame JOIN ... ON,
--     o USING – tik PAPRASTOMS, akivaizdžioms PK/FK jungtims.
-- ============================================================



-- ============================================================
-- 2. PAGRINDINIS PAVYZDYS: CUSTOMER + PAYMENT
-- ------------------------------------------------------------
-- Verslo klausimas:
--   "Parodyti klientus ir jų apmokėjimus."
--
-- Lentelės:
--   customer(customer_id, first_name, last_name, ...)
--   payment(payment_id, customer_id, amount, payment_date, ...)
--
-- Abu turi stulpelį customer_id – galima naudoti ir ON, ir USING.
-- ============================================================


-- 2.1. JOIN ... ON (pilnai aiškus variantas)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    p.payment_id,
    p.amount,
    p.payment_date
FROM customer AS c
JOIN payment AS p
    ON c.customer_id = p.customer_id
ORDER BY c.customer_id, p.payment_id
LIMIT 20;

-- Komentaras:
-- - Aiškiai matosi, iš kurio stulpelio daromas JOIN.
-- - Veiktų net jei stulpeliai vadintųsi skirtingai
--   (pvz. c.id ir p.customer_id).


-- 2.2. JOIN ... USING(customer_id) (trumpesnis variantas)

SELECT
    customer_id,           -- nereikia c. ar p., USING sujungė į vieną
    c.first_name,
    c.last_name,
    p.payment_id,
    p.amount,
    p.payment_date
FROM customer AS c
JOIN payment AS p
    USING (customer_id)
ORDER BY customer_id, p.payment_id
LIMIT 20;

-- Komentaras:
-- - USING(customer_id) reiškia tą patį kaip ON c.customer_id = p.customer_id.
-- - Rezultate nėra dviejų stulpelių (c.customer_id ir p.customer_id),
--   yra tik vienas 'customer_id'.
-- - Kode SELECT galima naudoti tiesiog customer_id be alias.



-- ============================================================
-- 3. PRAKTINIS PAVYZDYS SU KELETU JOIN – INVENTORY / RENTAL / FILM
-- ------------------------------------------------------------
-- Verslo klausimas:
--   "Parodyti nuomų sąrašą su filmo pavadinimu."
--
-- Lentelės:
--   rental(rental_id, rental_date, inventory_id, customer_id, ...)
--   inventory(inventory_id, film_id, store_id, ...)
--   film(film_id, title, ...)
--
-- Čia turime:
--   - rental.inventory_id  = inventory.inventory_id  (toks pats pavadinimas)
--   - inventory.film_id    = film.film_id            (toks pats pavadinimas)
-- ============================================================

-- 3.1. JOIN ... ON (pilnai eksplicitus variantas)

SELECT
    r.rental_id,
    r.rental_date,
    i.inventory_id,
    f.film_id,
    f.title
FROM rental AS r
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id
ORDER BY r.rental_date
LIMIT 20;


-- 3.2. JOIN ... USING (...) (trumpesnis variantas, kai aiškūs PK/FK)

SELECT
    r.rental_id,
    r.rental_date,
    inventory_id,   -- iš USING, nereikia prefix
    film_id,        -- iš USING
    f.title
FROM rental AS r
JOIN inventory AS i
    USING (inventory_id)
JOIN film AS f
    USING (film_id)
ORDER BY r.rental_date
LIMIT 20;

-- Komentaras:
-- - USING tinka, kai jungiamės per standartinius raktus (PK → FK),
--   ir abiejose lentelėse stulpelių pavadinimai sutampa.
-- - Kodas trumpesnis, bet svarbu suprasti, kad logika tokia pati
--   kaip su ON.



-- ============================================================
-- 4. PAVYZDYS, KADA USING NEGALIMA – SKIRTINGI STULPELIŲ PAVADINIMAI
-- ------------------------------------------------------------
-- Verslo klausimas:
--   "Parodyti, kokiame mieste yra parduotuvė."
--
-- Lentelės:
--   store(store_id, address_id, ...)
--   address(address_id, city_id, ...)
--   city(city_id, city, ...)
--
-- store.address_id = address.address_id  (tas pats pavadinimas → galima USING)
-- address.city_id  = city.city_id        (tas pats pavadinimas → galima USING)
-- Bet jei pavadinimai skirtingi – USING nebeveiktų.
-- ============================================================

-- 4.1. JOIN ... ON

SELECT
    s.store_id,
    a.address,
    ci.city,
    co.country
FROM store AS s
JOIN address AS a
    ON s.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id
JOIN country AS co
    ON ci.country_id = co.country_id
ORDER BY s.store_id;


-- 4.2. JOIN ... USING (galima, nes pavadinimai sutampa)

SELECT
    s.store_id,
    address,
    city,
    country
FROM store AS s
JOIN address AS a
    USING (address_id)
JOIN city AS ci
    USING (city_id)
JOIN country AS co
    USING (country_id)
ORDER BY s.store_id;

-- Geroji praktika:
-- - USING naudoti tik ten, kur skaitomybė iškart išauga ir aiškiai matosi,
--   jog sujungiami PK/FK tipo stulpeliai.
-- - Jei kyla bent kiek abejonių – rinktis ON.



-- ============================================================
-- 5. KODĖL USING + SELECT * GALI BŪTI PAVOJINGA
-- ------------------------------------------------------------
-- Verslo scenarijus:
--   "Greitai pažiūrėsiu, kas yra customer + payment".
--
-- Problema:
--   - Kai yra vienodi stulpelių pavadinimai, SELECT * elgesys skiriasi.
--   - Su ON turėsi abu stulpelius (c.customer_id, p.customer_id),
--     su USING – tik vieną customer_id (MySQL pats pasirinks).
-- ============================================================

-- 5.1. SELECT * su JOIN ... ON

SELECT
    *
FROM customer AS c
JOIN payment AS p
    ON c.customer_id = p.customer_id
LIMIT 5;

-- Rezultate:
--   - bus ir c.customer_id, ir p.customer_id (du atskiri stulpeliai).
--   - gali matyti aiškiai, kad abi pusės turi tą stulpelį.


-- 5.2. SELECT * su JOIN ... USING

SELECT
    *
FROM customer AS c
JOIN payment AS p
    USING (customer_id)
LIMIT 5;

-- Rezultate:
--   - customer_id bus tik vienas.
--   - nebesimato, iš kurios lentelės jis paimtas (praktikoje tas pats, bet
--     schema evoliucijos metu gali būti rizika).
--
-- GEROJI PRAKTIKA:
--   - NENAUDOTI SELECT * reportuose ir BI logikoje.
--   - Visada aiškiai nurodyti stulpelius.
--   - Ypač atsargiai su USING ir SELECT * – gali slėptis netikėti rezultatai
--     arba prarandama kontrolė, kurie stulpeliai rodomi.



-- ============================================================
-- 6. KĄ REIKIA PRISIMINTI APIE JOIN ... USING
-- ------------------------------------------------------------
-- 1) TIK jei stulpelių pavadinimai sutampa abiejose lentelėse.
-- 2) Rezultate gaunamas vienas bendras stulpelis.
-- 3) Daugeliui analitinių užduočių geriau naudoti JOIN ... ON –
--    aiškiau, lengviau prižiūrėti, mažiau siurprizų.
-- ============================================================



-- ============================================================
-- 7. KO N I E K A D A N E D A R Y T I
-- ------------------------------------------------------------
-- 1) Nenaudoti NATURAL JOIN.
--    MySQL automatiškai sujungia per VISUS vienodo pavadinimo stulpelius.
--    Jei schema pasikeis (atsiras naujas stulpelis) – join logika
--    pasikeis tyčia be įspėjimo.
--
-- 2) Nemaišyti USING ir miglotų sąlygų.
--    Jei reikia sudėtingesnio join (kelios sąlygos, intervalai,
--    nelygybės) – VISADA naudoti ON.
--
-- 3) Nerašyti JOIN be ON/USING (seno stiliaus comma join).
--    Pvz.:
--       FROM customer c, payment p
--       WHERE c.customer_id = p.customer_id
--    Tai bloga praktika, klaidų rizika didesnė, ypač kai prisideda
--    papildomos sąlygos.
-- ============================================================

-- BLOGA PRAKTIKA – NATURAL JOIN (DEMONSTRACINIS PAVYZDYS, NEVYKDYTI PROD):

-- SELECT
--     *
-- FROM customer
-- NATURAL JOIN payment;

-- Kodėl blogai:
--  - join’inama per VISUS vienodai pavadintus stulpelius.
--  - šiandien gal tik customer_id, rytoj schema kažką pakeis –
--    join logika pasikeis automatiškai ir tyliai.
--  - Analitiko požiūriu – tai "minos laukas".

-- ============================================================
-- REZIUMĖ:
--   - JOIN ... ON – pagrindinis, saugus ir universalus būdas.
--   - JOIN ... USING – galima naudoti paprastoms, akivaizdžioms
--     PK/FK jungtims, kai pavadinimai sutampa ir siekiamas tik
--     sintaksinis sutrumpinimas.
--   - NATURAL JOIN ir SELECT * – laikyti bloga praktika analitiko darbe.
-- ============================================================

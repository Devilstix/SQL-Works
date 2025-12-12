-- =====================================================================================
-- DATA GRANULARITY (DUOMENŲ DETALUMO LYGIS) – DEMO SU SAKILA DB
-- =====================================================================================

/*Kas yra data granularity?

Granularity (duomenų detalumo lygis) – tai, kokio tikslumo / detalumo lygio yra data.
Ta pati informacija gali būti matuojama skirtingais pjūviais:

per sekundę / minutę / valandą
per dieną
per mėnesį
per metus
per klientą / per parduotuvę / per regioną

Kuo smulkesnė granularity, tuo daugiau eilučių ir detalių.
Kuo stambesnė granularity, tuo daugiau suagreguotos informacijos.

Paprasčiau:

Granularity = „kiek detali yra informacija“. */
-- Granularity = KIEK DETALI yra informacija.
-- Ta pati metrika (pvz. pajamos) gali būti:
--   - per vieną mokėjimą (transaction-level)
--   - per dieną (daily)
--   - per mėnesį (monthly)
--   - per metus (yearly)
--   - per parduotuvę + laikotarpį (store-level by period)
--
-- Kuo smulkesnė granularity → daugiau eilučių, daugiau detalių.
-- Kuo stambesnė granularity → mažiau eilučių, daugiau agregavimo.
--
-- DEMO: visi pavyzdžiai naudoja tą pačią lentelę payment, bet skirtingą granularity.
-- =====================================================================================

USE sakila;

-- =====================================================================================
-- 1. SMULKIAUSIA granularity – TRANSACTION-LEVEL (MOKĖJIMO LYGIS)
-- -------------------------------------------------------------------------------------
-- KLAUSIMAS:
--   "Parodyk kiekvieną atskirą mokėjimą."
--
-- granularity:
--   - viena eilutė = vienas mokėjimas
--   - naudinga detaliam auditui, atskiroms operacijoms analizuoti.
-- =====================================================================================

SELECT
    payment_id,
    customer_id,
    date(payment_date),
    amount
FROM payment
ORDER BY payment_date;



-- =====================================================================================
-- 2. DAILY GRANULARITY – PAJAMOS PER DIENĄ
-- -------------------------------------------------------------------------------------
-- KLAUSIMAS:
--   "Kokios buvo dienos pajamos?"
--
-- Čia:
--   - viena eilutė = viena diena
--   - prarandame atskiras transakcijas, bet gauname dienos KPI.
-- =====================================================================================

SELECT
    DATE(payment_date) AS day,
    SUM(amount) AS daily_revenue,
    COUNT(*) AS payments_count
FROM payment
GROUP BY DATE(payment_date)
ORDER BY day;



-- =====================================================================================
-- 3. MONTHLY GRANULARITY – PAJAMOS PER MĖNESĮ
-- -------------------------------------------------------------------------------------
-- KLAUSIMAS:
--   "Kokios yra mėnesinės pajamos?"
--
-- granularity dar stambesnė:
--   - viena eilutė = vienas mėnuo
--   - naudinga sezoniškumui, tendencijoms, monthly KPI.
-- =====================================================================================

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS yearmonth,
    SUM(amount) AS monthly_revenue,
    COUNT(*) AS payments_count
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY yearmonth;


-- =====================================================================================
-- 4. YEARLY GRANULARITY – PAJAMOS PER METUS
-- -------------------------------------------------------------------------------------
-- KLAUSIMAS:
--   "Kokios buvo metinės pajamos?"
--
-- granularity:
--   - viena eilutė = vieni metai
--   - naudojama aukščiausio lygio vadovų ataskaitose, ilgo laikotarpio trendui.
-- =====================================================================================

SELECT
    YEAR(payment_date) AS year,
    SUM(amount) AS yearly_revenue,
    COUNT(*) AS payments_count
FROM payment
GROUP BY YEAR(payment_date)
ORDER BY year;


-- =====================================================================================
-- 5. granularity SU DIMENSIJA – STORE + DAY
-- -------------------------------------------------------------------------------------
-- KLAUSIMAS:
--   "Kokios dienos pajamos kiekvienoje parduotuvėje?"
--
-- Čia granularity:
--   - viena eilutė = (parduotuvė, diena)
--   - darome ir laiko, ir parduotuvės (store_id) agregavimą.
-- =====================================================================================

SELECT
    s.store_id,
    DATE(p.payment_date) AS day,
    SUM(p.amount) AS daily_revenue
FROM payment p
JOIN rental r    ON p.rental_id  = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s     ON i.store_id   = s.store_id
GROUP BY
    s.store_id,
    DATE(p.payment_date)
ORDER BY
    s.store_id,
    day
LIMIT 50;


-- =====================================================================================
-- 6. TAS PATS KPI, SKIRTINGA granularity – PALYGINIMAS
-- -------------------------------------------------------------------------------------
-- APAČIOJE – TRYS UŽKLAUSOS APIE "PAJAMAS", BET SU VIS SKIRTINGU DETALUMO LYGIU.
-- =====================================================================================

-- 6.1. TRANSACTION-LEVEL – kiekviena eilutė = vienas payment
SELECT
    payment_id,
    payment_date,
    amount
FROM payment
ORDER BY payment_date;


-- 6.2. DAILY-LEVEL – kiekviena eilutė = viena diena
SELECT
    DATE(payment_date) AS day,
    SUM(amount) AS daily_revenue
FROM payment
GROUP BY DATE(payment_date)
ORDER BY day;


-- 6.3. MONTHLY-LEVEL – kiekviena eilutė = vienas mėnuo
SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS yearmonth,
    SUM(amount) AS monthly_revenue
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY yearmonth;



-- =====================================================================================
-- 7. Apibendrinimas
-- -------------------------------------------------------------------------------------
-- Granularity = "Kokio detalumo noriu savo atsakymo?"
--
-- KLAUSIMAI, KURIUOS VISADA REIKIA UŽDUOTI:
--   1) Ar man reikia DETALIŲ (transaction-level)?
--   2) Ar man reikia DIENOS, SAVAITĖS, MĖNESIO, METŲ KPI?
--   3) Kokia yra prasminga laiko granularity verslo sprendimui?
--
-- NETEISINGA granularity →
--   - per smulki: chaosas, sunku matyti vaizdą
--   - per stambi: prarandamos įžvalgos, nematyti problemų
--
-- Šitie pavyzdžiai rodo, kad:
--   - TA PATI metrika (pajamos) atrodo visiškai kitaip,
--   - priklausomai nuo to, kokį detalumo lygį pasirenkame.
-- =====================================================================================

-- ============================================
-- BEGINNERS JOIN DEMO – SAKILA DATABASE
-- JOIN pagrindai su verslo kontekstu
-- ============================================
USE sakila;

-- ============================================
-- 1. PAPRASTAS 2-TABLE JOIN
-- Verslo kontekstas:
-- "Norime pamatyti klientų adresus – kas yra mūsų
--  klientų bazė ir kur jie gyvena."
-- ============================================




-- ============================================
-- 2. 3-TABLE JOIN: KLIENTAI IR MIESTAI
-- Verslo kontekstas:
-- "Norime pasižiūrėti, kokiuose miestuose turime
--  daugiausiai klientų (lokalios rinkos analizė)."
-- ============================================

-- 2.1. Klientų sąrašas su miestu ir šalimi


-- 2.2. Klientų skaičius per miestą (kiek klientų turime kiekviename mieste)



-- ============================================
-- 3. JOIN SU PAYMENT: PAJAMOS PAGAL KLIENTĄ
-- Verslo kontekstas:
-- "Norime rasti, kurie klientai generuoja daugiausiai pajamų."
-- ============================================



-- ============================================
-- 4. GRANDINĖ: PAYMENT -> RENTAL -> INVENTORY -> FILM
-- Verslo kontekstas:
-- "Norime suprasti, kurie filmai (produktai) generuoja daugiausiai pajamų."
-- ============================================



-- ============================================
-- 5. GRANDINĖ: STORES (PARDUOTUVĖS) IR LOKACIJA
-- Verslo kontekstas:
-- "Norime palyginti parduotuvių rezultatus (store performance)."
-- ============================================




-- ============================================
-- 6. MANY-TO-MANY PER JUNGIMO LENTELĘ (BRIDGE)
-- PAVYZDYS: FILM – CATEGORY
-- Verslo kontekstas:
-- "Norime pamatyti pajamas pagal filmų kategorijas (žanrus)."
-- ============================================



-- ============================================
-- 7. MANY-TO-MANY: FILM – ACTOR
-- Verslo kontekstas:
-- "Norime pamatyti, kurie aktoriai žaidžia konkrečiame filme
--  (naudinga marketingui, žvaigždžių komunikacijai)."
-- ============================================

-- 7.1. Aktorių sąrašas vienam konkrečiam filmui (pvz. 'ACADEMY DINOSAUR')



-- 7.2. Aktorių skaičius per filmą (kiek aktorių dalyvauja kiekviename filme)


-- ============================================
-- 8. LEFT JOIN PAGRINDAI
-- Verslo kontekstas:
-- "Norime pamatyti ir tuos objektus, kurie neturi susijusių įrašų."
-- ============================================

-- 8.1. Visi klientai ir jų paskutinė nuoma (jei yra)
-- LEFT JOIN – rodome visus klientus, net jei jie
-- dar nieko nenuomavo (potenciali klientų aktyvinimo kampanija).


-- 8.2. Visos kategorijos ir filmų skaičius jose
-- LEFT JOIN – jei ateityje atsirastų kategorijų be filmų,
-- jos vis tiek būtų matomos, kad pastebėtume "tuščias" kategorijas.


-- ============================================
-- 9. LEFT JOIN: FILMAI BE NUOMŲ (SILPNI PRODUKTAI)
-- Verslo kontekstas:
-- "Norime identifikuoti filmus, kurie nesinuomojami –
--  gal juos reikia išimti iš katalogo arba pakeisti kainodarą."
-- ============================================




-- ============================================
-- 10. JOIN SU DARBUOTOJAIS (STAFF PERFORMANCE)
-- Verslo kontekstas:
-- "Norime palyginti darbuotojų veiklą – kiek pajamų jie generuoja."
-- ============================================



-- ============================================
--  JOIN demonstruoja:
-- - 2-table ir 3-table INNER JOIN (customer–address–city)
-- - Grandines JOIN per kelias lenteles (payment–rental–inventory–film–store)
-- - Many-to-many per jungimo lentelę (film_category, film_actor)
-- - LEFT JOIN, kai norime matyti įrašus be atitikmenų
-- - Tipinius verslo klausimus:
--     * top klientai
--     * top filmai
--     * pajamos pagal kategoriją ir parduotuvę
--     * klientų aktyvumas
--     * darbuotojų performance
-- ============================================

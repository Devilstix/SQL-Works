-- ============================================================================================
-- CROSS JOIN –  (Sakila DB)

-- ============================================================================================
USE sakila;

-- ============================================================================================
-- 1. Kas yra CROSS JOIN?
-- --------------------------------------------------------------------------------------------
-- CROSS JOIN sujungia kiekvieną eilutę iš vienos lentelės su kiekviena eilute iš kitos lentelės.
-- Jei viena lentelė turi 10 eilučių, o kita 5, rezultatas bus 10 × 5 = 50 eilučių.
--
-- Svarbu:
--   - CROSS JOIN nenaudoja ON ir USING.
--   - JOIN vyksta be loginio ryšio, tik matematinis kombinavimas.
--
-- Realus pavojus:
--   - Jei lentelės didelės, rezultatas gali būti milijonai eilučių.
--   - CROSS JOIN beveik niekada nenaudojamas atsitiktinai.
-- ============================================================================================


-- ============================================================================================
-- 2. Paprasčiausias CROSS JOIN pavyzdys (Sakila)
-- --------------------------------------------------------------------------------------------
-- Verslo scenarijus:
--   "Pateikti visas parduotuvės × miesto kombinacijas."
-- ============================================================================================

SELECT
    s.store_id,
    c.city
FROM store s
CROSS JOIN city c
;
select * from city;
-- Interpretacija:
--   Kiekviena parduotuvė sujungiama su kiekvienu miestu.
--   Naudojama rinkos plėtros analizei, sandėlių planavimui, galimų lokacijų idėjoms.


-- ============================================================================================
-- 3. CROSS JOIN su sąlyga (WHERE)
-- --------------------------------------------------------------------------------------------
-- Verslo scenarijus:
--   "Gauti tik kombinacijas miestams, prasidedantiems raide A."
-- ============================================================================================

SELECT
    s.store_id,
    c.city
FROM store s
CROSS JOIN city c
WHERE c.city LIKE 'A%'
;

-- Naudojimas:
--   - modeliuoti galimas parduotuvių lokacijas tik tam tikruose regionuose


-- ============================================================================================
-- 4. CROSS JOIN su produktų sąrašu
-- --------------------------------------------------------------------------------------------
-- Verslo scenarijus:
--   "Rodyti visas parduotuvės × filmo kombinacijas."
--   Naudinga atsargų planavimui, prekių paskirstymui.
-- ============================================================================================

SELECT
    s.store_id,
    f.title
FROM store s
CROSS JOIN film f
LIMIT 20;


-- ============================================================================================
-- 5. CROSS JOIN pavojus – blogas naudojimas
-- --------------------------------------------------------------------------------------------
-- Jei lentelės didelės:
-- customer: 599
-- payment : 14596
-- CROSS JOIN rezultatas:
-- 599 × 14596 = 8,737,204 eilučių
--
-- Studentų dažniausia klaida:
-- ============================================================================================

SELECT *
FROM customer
CROSS JOIN payment
LIMIT 50;

-- Ši užklausa sugeneruos milžinišką duomenų kiekį, jei LIMIT nebus panaudotas.


-- ============================================================================================
-- 6. CROSS JOIN atsiranda automatiškai, jei nenurodai ON
-- --------------------------------------------------------------------------------------------
-- Kartais studentai netyčia padaro CROSS JOIN:
-- ============================================================================================

-- Blogai:
-- SELECT * FROM film JOIN category;

-- Kodėl blogai?
-- JOIN be ON arba USING tampa CROSS JOIN ir kombinuos kiekvieną film su kiekviena category.


-- ============================================================================================
-- 7. Kada CROSS JOIN naudinga versle?
-- --------------------------------------------------------------------------------------------
-- CROSS JOIN naudojamas:
--    modeliavimui
--    projekcijoms
--    visų galimų kombinacijų generavimui
--    kalendorių generavimui
--    kainų kampanijų planavimui
--    sandėlio ar atsargų paskirstymui
--
-- Taisyklė:
--   Jei nenori kombinacijų → NENAUDOK CROSS JOIN.
-- ============================================================================================


-- ============================================================================================
-- 8. Suvestinė pradedantiesiems
-- --------------------------------------------------------------------------------------------
-- CROSS JOIN:
--   - generuoja visas galimas kombinacijas tarp dviejų lentelių
--   - retai naudojamas duomenų skaitymui
--   - dažniausiai naudojamas analizei, prognozėms, planavimui
--
-- Gerosios praktikos:
--    naudoti CROSS JOIN tik tada, kai jis logiškai reikalingas
--    visada LIMIT jei lentelės didelės
--
-- Blogosios praktikos:
--    CROSS JOIN vietoj JOIN ... ON
--    nerašyti ON → automatiškai gaunasi CROSS JOIN
--    naudoti didelėse lentelėse be ribojimo
-- ============================================================================================


-- UŽDUOTIS: Darbuotojų duomenų valymas

-- Tikslas: Išvalyti dirty_employees.csv duomenų rinkinį ir sukurti švarią lentelę 'employees_clean'

-- Etapas 1: Lentelės struktūra
-- Sukurkite lentelę dirty_employees su atitinkamais stulpeliais, tinkamais duomenų tipais (bet palikite hire_date, salary kaip TEXT)
-- Patarimas: naudokite VARCHAR viskam, kad galėtumėte sėkmingai importuoti duomenis

-- Etapas 2: Įkelkite CSV per Table Import Wizard

-- Etapas 3: Sukurkite švarią lentelę employees_clean su teisingais tipais

CREATE TABLE clean_employees AS
SELECT * FROM dirty_employees;

CREATE TABLE clean_employees AS
SELECT * FROM dirty_employees WHERE 1=0;

CREATE TABLE employees_clean (
emp_id INT
,name VARCHAR(100)
,email VARCHAR(100)
,dept VARCHAR(50)
,hire_date DATE
,salary DECIMAL(10,2)
,status VARCHAR(20));

-- Etapas 4: Išvalykite ir perkelkite duomenis į švarią lentelę

-- a) Vardų normalizavimas:
-- - Pašalinkite nereikalingus kabliataškius, tarpus, padarykite 'Title Case'
-- - Kokias funkcijas galite naudoti? TRIM, REPLACE, CONCAT, ...

SELECT
	full_name
FROM clean_employees;

-- 4. Išvalome duomenis ir įrašome į clean_employees
INSERT INTO clean_employees
SELECT 
    client_id,
    -- normalizuojame vardus
    CONCAT(UCASE(LEFT(TRIM(full_name), 1)), 
           LCASE(SUBSTRING(TRIM(full_name), 2))) AS full_name,
 
    -- pašaliname tarpus iš email
    LOWER(TRIM(REPLACE(REPLACE(REPLACE(email, ' ', ''), ' @', '@'), '@ ', '@'))) AS email,
 
    -- datų konvertavimas iš galimų formatų, jei yra tinkamas formatas
    CASE
        WHEN birthdate REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN STR_TO_DATE(birthdate, '%Y-%m-%d')
        WHEN birthdate REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(birthdate, '%d/%m/%Y')
        ELSE NULL
    END AS birthdate,
 
    -- jei phone tuščias – UNKNOWN
    CASE 
        WHEN phone IS NULL OR TRIM(phone) = '' THEN 'UNKNOWN'
        ELSE TRIM(phone)
    END AS phone,
 
    -- status → lowercase → validacija
    CASE 
        WHEN LOWER(TRIM(status)) IN ('active', 'inactive') THEN LOWER(TRIM(status))
        ELSE NULL
    END AS status,
 
    -- country → jei tuščias → NULL
    NULLIF(TRIM(country), '') AS country
 
FROM dirty_employees;

-- b) Email valymas:
-- - Pašalinkite tarpų simbolius, patikrinkite ar yra '@' ir '.'
-- - Tik palikite email'us su teisingu formatu

-- c) Departamento vienodinimas:
-- - 'Sales' ir 'sales' turi būti viena reikšmė
-- - Tušti įrašai turi būti 'Unknown'
-- - Galite naudoti CASE

-- d) Data valymas:
-- - hire_date yra tekstas įvairiais formatais
-- - Konvertuokite į DATE naudodami STR_TO_DATE()
-- - Ką daryti su 'not_a_date'?

-- e) Atlyginimų konvertavimas:
-- - Pašalinkite blogas reikšmes (pvz., tekstą), konvertuokite skaičius
-- - Kas netinka – neperkelkite

-- f) Status reikšmių normalizavimas:
-- - Suvienodinkite formatus: 'Active', 'Inactive'
-- - Naudokite UPPER / LOWER + CASE

-- Etapas 5: Tikrinkite
-- - Kiek įrašų buvo išvalyta?
-- - Kiek įrašų perkelta į employees_clean?

-- BONUS: Sukurkite ataskaitą:
-- - Kiek darbuotojų per metus?
-- - Vidutinis atlyginimas pagal skyrių?

-- Sekmės!

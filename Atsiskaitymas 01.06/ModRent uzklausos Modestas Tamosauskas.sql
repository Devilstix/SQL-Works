			-- ======================== --
-- ========== UAB MODERENT ========== --
			-- ======================== --


-- Parodyti visas nuomas

SELECT 
    n.NuomosID,
    v.Vardas,
    v.Pavarde,
    m.Gamintojas,
    m.Modelis,
    n.NuomosData,
    n.GrazinimoData,
    n.VisaSuma AS BendraKaina,
    d.Suma AS Depozitas,
    d.Grazintas,
    GROUP_CONCAT(p.Pavadinimas SEPARATOR ', ') AS PapildomosPaslaugos
FROM Nuomos n
JOIN Vartotojai v 
    ON n.VartotojoID = v.VartotojoID
JOIN Masinos m 
    ON n.MasinosID = m.MasinosID
LEFT JOIN Depozitai d 
    ON n.NuomosID = d.NuomosID
LEFT JOIN NuomosPaslaugos np 
    ON n.NuomosID = np.NuomosID
LEFT JOIN PapildomosPaslaugos p 
    ON np.PaslaugosID = p.PaslaugosID
GROUP BY 
    n.NuomosID,
    v.Vardas,
    v.Pavarde,
    m.Gamintojas,
    m.Modelis,
    n.NuomosData,
    n.GrazinimoData,
    n.VisaSuma,
    d.Suma,
    d.Grazintas
ORDER BY n.NuomosData DESC;

-- Nuomos su depozitais ir grąžinimo statusu
SELECT 
    n.NuomosID,
    v.Vardas, v.Pavarde,
    m.Gamintojas, m.Modelis,
    d.Suma AS Depozitas,
    d.Grazintas
FROM Nuomos n
JOIN Vartotojai v ON n.VartotojoID = v.VartotojoID
JOIN Masinos m ON n.MasinosID = m.MasinosID
LEFT JOIN Depozitai d ON n.NuomosID = d.NuomosID
ORDER BY n.NuomosData DESC;

-- Nuomų suma pagal miestą (paėmimo vieta)
SELECT 
    vt.Miestas,
    COUNT(n.NuomosID) AS NuomuKiekis,
    SUM(n.VisaSuma) AS BendraSuma
FROM Nuomos n
JOIN Vietoves vt ON n.PaemimoVietaID = vt.VietovesID
GROUP BY vt.Miestas
ORDER BY BendraSuma DESC;

-- Automobiliu technine apžiūra
SELECT 
    m.MasinosID,
    m.Gamintojas, m.Modelis,
    MAX(tp.GaliojaIki) AS TechnikineGaliojaIki
FROM Masinos m
LEFT JOIN TechninePrieziura tp ON m.MasinosID = tp.MasinosID AND tp.Tipas = 'TA'
GROUP BY m.MasinosID, m.Gamintojas, m.Modelis
ORDER BY TechnikineGaliojaIki DESC;

-- Populiariausios papildomos paslaugos
SELECT 
    p.Pavadinimas,
    COUNT(np.NuomosID) AS Kiekis
FROM NuomosPaslaugos np
JOIN PapildomosPaslaugos p ON np.PaslaugosID = p.PaslaugosID
GROUP BY p.Pavadinimas
ORDER BY Kiekis DESC;

-- Darbuotojų veiksmų žurnalas (audit)
SELECT 
    dz.ZurnaloID,
    d.Vardas, d.Pavarde,
    dz.Veiksmas,
    dz.LentelesPavadinimas,
    dz.IrasaID,
    dz.Data
FROM VeiksmuZurnalas dz
JOIN Darbuotojai d ON dz.DarbuotojoID = d.DarbuotojoID
ORDER BY dz.Data DESC;

-- Nuomos su statuso aprašymu pagal sumą
SELECT 
    n.NuomosID,
    v.Vardas, v.Pavarde,
    m.Gamintojas, m.Modelis,
    n.VisaSuma,
    CASE 
        WHEN n.VisaSuma < 50 THEN 'Maža nuoma'
        WHEN n.VisaSuma BETWEEN 50 AND 100 THEN 'Vidutinė nuoma'
        ELSE 'Brangi nuoma'
    END AS NuomosTipas
FROM Nuomos n
JOIN Vartotojai v ON n.VartotojoID = v.VartotojoID
JOIN Masinos m ON n.MasinosID = m.MasinosID
ORDER BY n.VisaSuma DESC;

-- Kiekvieno vartotojo nuomų statistika
SELECT 
    v.Vardas, v.Pavarde,
    COUNT(n.NuomosID) AS NuomuKiekis,
    SUM(n.VisaSuma) AS BendraSuma,
    AVG(n.VisaSuma) AS VidutineKaina,
    CASE
        WHEN SUM(n.VisaSuma) > 300 THEN 'VIP klientas'
        ELSE 'Įprastas klientas'
    END AS KlientoTipas
FROM Nuomos n
JOIN Vartotojai v ON n.VartotojoID = v.VartotojoID
GROUP BY v.VartotojoID
ORDER BY BendraSuma DESC;

-- Nuomos pagal miestus su kategorijomis
SELECT 
    vt.Miestas,
    COUNT(n.NuomosID) AS NuomuSkaicius,
    SUM(n.VisaSuma) AS BendraSuma,
    CASE
        WHEN COUNT(n.NuomosID) >= 3 THEN 'Populiarus miestas'
        ELSE 'Mažiau populiarus'
    END AS MiestoTipas
FROM Nuomos n
JOIN Vietoves vt ON n.PaemimoVietaID = vt.VietovesID
GROUP BY vt.Miestas
ORDER BY BendraSuma DESC;

-- Darbuotojų nuomų valdymas
SELECT 
    d.Vardas, d.Pavarde,
    COUNT(n.NuomosID) AS NuomuSkaicius,
    SUM(n.VisaSuma) AS Pajamos,
    CASE
        WHEN COUNT(n.NuomosID) > 3 THEN 'Aktyvus darbuotojas'
        ELSE 'Mažiau aktyvus'
    END AS VeiklosTipas
FROM Nuomos n
JOIN Darbuotojai d ON n.DarbuotojoID = d.DarbuotojoID
GROUP BY d.DarbuotojoID
ORDER BY NuomuSkaicius DESC;

--  Automobiliai, kurių techninė apžiūra greitai baigsis
SELECT 
    m.Gamintojas, m.Modelis,
    MAX(tp.GaliojaIki) AS TechnikineGaliojaIki,
    CASE 
        WHEN MAX(tp.GaliojaIki) < CURDATE() + INTERVAL 30 DAY THEN 'Reikia atnaujinti'
        ELSE 'Galioja'
    END AS Statusas
FROM Masinos m
LEFT JOIN TechninePrieziura tp ON m.MasinosID = tp.MasinosID AND tp.Tipas='TA'
GROUP BY m.MasinosID
ORDER BY TechnikineGaliojaIki ASC;

-- Nuomos su visomis paslaugomis ir depozitu kaip viena eilutė
SELECT 
    n.NuomosID,
    v.Vardas, v.Pavarde,
    m.Gamintojas, m.Modelis,
    n.VisaSuma,
    d.Suma AS Depozitas,
    GROUP_CONCAT(p.Pavadinimas SEPARATOR ', ') AS PapildomosPaslaugos,
    CASE 
        WHEN d.Grazintas = 1 THEN 'Depozitas grąžintas'
        ELSE 'Depozitas negrąžintas'
    END AS DepozitoStatusas
FROM Nuomos n
JOIN Vartotojai v ON n.VartotojoID = v.VartotojoID
JOIN Masinos m ON n.MasinosID = m.MasinosID
LEFT JOIN Depozitai d ON n.NuomosID = d.NuomosID
LEFT JOIN NuomosPaslaugos np ON n.NuomosID = np.NuomosID
LEFT JOIN PapildomosPaslaugos p ON np.PaslaugosID = p.PaslaugosID
GROUP BY n.NuomosID, v.Vardas, v.Pavarde, m.Gamintojas, m.Modelis, n.VisaSuma, d.Suma, d.Grazintas
ORDER BY n.NuomosData DESC;


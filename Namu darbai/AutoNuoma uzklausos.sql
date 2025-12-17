			-- ======================== --
-- ========== UAB MODERENT ========== --
			-- ======================== --

-- Visos nuomos su pilna informacija
SELECT 
    n.NuomosID
    , v.Vardas AS VartotojoVardas
    , v.Pavarde AS VartotojoPavarde
    , m.Gamintojas
    , m.Modelis
    , vp.Pavadinimas AS PaemimoVieta
    , vg.Pavadinimas AS GrazinimoVieta
    , DATE(n.NuomosData) AS Nuomos_pradzia
    , DATE(n.GrazinimoData) AS Nuomos_pabaiga
    , DATEDIFF(n.GrazinimoData, n.NuomosData) AS NuomosDienos
    , n.VisaSuma
FROM nuomos n
JOIN vartotojai v ON n.VartotojoID = v.VartotojoID
JOIN masinos m ON n.MasinosID = m.MasinosID
JOIN vietoves vp ON n.PaemimoVietaID = vp.VietovesID
JOIN vietoves vg ON n.PalikimoVietaID = vg.VietovesID;

-- Kiek kartų kiekvienas automobilis buvo išnuomotas ir paskutinė nuomos data
SELECT 
    m.Gamintojas
    , m.Modelis
    , COUNT(n.NuomosID) AS NuomosKiekis
    , MAX(n.NuomosData) AS PaskutineNuoma
FROM masinos m
LEFT JOIN nuomos n ON m.MasinosID = n.MasinosID
GROUP BY m.MasinosID, m.Gamintojas, m.Modelis
ORDER BY PaskutineNuoma DESC;

-- Kiekvieno vartotojo nuomos su kainomis ir mokėjimo būdu
SELECT 
    v.Vardas
    , v.Pavarde
    , m.Gamintojas
    , m.Modelis
    , m.DienosKaina
    , DATEDIFF(n.GrazinimoData, n.NuomosData) AS NuomosDienos
    , n.VisaSuma
    , mk.MokejimoBudas
FROM vartotojai v
JOIN nuomos n ON v.VartotojoID = n.VartotojoID
JOIN masinos m ON n.MasinosID = m.MasinosID
JOIN mokejimai mk ON n.NuomosID = mk.NuomosID
ORDER BY n.VisaSuma DESC;

-- Populiariausias kėbulo tipas
SELECT 
    k.Tipas
    , COUNT(n.NuomosID) AS NuomosKiekis
FROM kebulotipas k
JOIN masinos m ON k.KebuloTipoID = m.KebuloTipoID
JOIN nuomos n ON m.MasinosID = n.MasinosID
GROUP BY k.Tipas
ORDER BY NuomosKiekis DESC
LIMIT 1;

-- Kiek kiekviename nuomos centre buvo išnuomota automobilių
SELECT 
    v.Pavadinimas AS NuomosCentras
    , v.Miestas
    , COUNT(n.NuomosID) AS IsnuomotuAutomobiliuKiekis
FROM vietoves v
JOIN nuomos n ON v.VietovesID = n.PaemimoVietaID
GROUP BY v.Pavadinimas, v.Miestas
ORDER BY IsnuomotuAutomobiliuKiekis DESC;

-- Darbuotojų aptarnautų nuomų skaičius
SELECT 
    d.Vardas
    , d.Pavarde
    , COUNT(n.NuomosID) AS AptarnautaNuomu
FROM darbuotojai d
JOIN nuomos n ON d.DarbuotojoID = n.DarbuotojoID
GROUP BY d.Vardas, d.Pavarde;

-- Visi mokėjimai su vartotojais
SELECT 
    m.MokejimoID
    , v.Vardas
    , v.Pavarde
    , m.Suma
    , m.MokejimoBudas
    , m.MokejimoData
FROM mokejimai m
JOIN nuomos n ON m.NuomosID = n.NuomosID
JOIN vartotojai v ON n.VartotojoID = v.VartotojoID;

-- Vartotojai, kurie išleido daugiau nei vidurkis
SELECT 
    v.Vardas
    , v.Pavarde
    , SUM(n.VisaSuma) AS BendraSuma
FROM vartotojai v
JOIN nuomos n ON v.VartotojoID = n.VartotojoID
GROUP BY v.Vardas, v.Pavarde
HAVING SUM(n.VisaSuma) > (
    SELECT AVG(VisaSuma)
    FROM nuomos
);

-- Automobiliai, kurie niekada nebuvo išnuomoti
SELECT 
    m.Gamintojas
    , m.Modelis
FROM masinos m
LEFT JOIN nuomos n ON m.MasinosID = n.MasinosID
WHERE n.NuomosID IS NULL;

-- Pajamos ir nuomų skaičius pagal mėnesį ir metus
SELECT 
    YEAR(n.NuomosData) AS Metai
    , MONTH(n.NuomosData) AS Menuo
    , COUNT(n.NuomosID) AS NuomuSkaicius
    , SUM(n.VisaSuma) AS Pajamos
FROM nuomos n
GROUP BY Metai, Menuo
ORDER BY Metai, Menuo;

-- Patikrinimas ar suma atitinka skaičiavimą
SELECT 
    n.NuomosID
    , m.DienosKaina
    , DATEDIFF(n.GrazinimoData, n.NuomosData) AS Dienos
    , n.VisaSuma
    , (m.DienosKaina * DATEDIFF(n.GrazinimoData, n.NuomosData)) AS TuretuButi
    , CASE 
        WHEN n.VisaSuma = (m.DienosKaina * DATEDIFF(n.GrazinimoData, n.NuomosData))
        THEN 'Sutampa'
        ELSE 'Nesutampa'
      END AS Tikrinimas
FROM nuomos n
JOIN masinos m ON n.MasinosID = m.MasinosID;

-- Dažniausiai naudojamas mokėjimo būdas
SELECT 
    MokejimoBudas
    , COUNT(*) AS KiekKartu
FROM mokejimai
GROUP BY MokejimoBudas
ORDER BY KiekKartu DESC
LIMIT 1;

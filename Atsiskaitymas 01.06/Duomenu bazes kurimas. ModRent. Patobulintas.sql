
			-- ======================== --
-- ========== UAB MODERENT ========== --
			-- ======================== --
            
-- 1. Duomenų bazė
CREATE DATABASE IF NOT EXISTS AutoNuoma;
USE AutoNuoma;

-- =========================
-- VARTOTOJAI
-- =========================
CREATE TABLE Vartotojai (
    VartotojoID INT PRIMARY KEY AUTO_INCREMENT,
    Vardas VARCHAR(50),
    Pavarde VARCHAR(50),
    GimimoData DATE,
    VairavimoStazas INT,
    VairuotojoPazymejimoNr VARCHAR(50),
    VairuotojoPazymejimoGaliojaIki DATE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telefonas VARCHAR(20) NOT NULL UNIQUE,
    RegistracijosData DATETIME DEFAULT CURRENT_TIMESTAMP,
    Aktyvus BOOLEAN DEFAULT 1
);

-- =========================
-- DARBUOTOJAI
-- =========================
CREATE TABLE Darbuotojai (
    DarbuotojoID INT PRIMARY KEY AUTO_INCREMENT,
    Vardas VARCHAR(50),
    Pavarde VARCHAR(50),
    Pareigos VARCHAR(50),
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telefonas VARCHAR(20) NOT NULL UNIQUE,
    IdarbinimoData DATE,
    Aktyvus BOOLEAN DEFAULT 1
);

-- =========================
-- VIETOVĖS
-- =========================
CREATE TABLE Vietoves (
    VietovesID INT PRIMARY KEY AUTO_INCREMENT,
    Pavadinimas VARCHAR(50),
    Adresas VARCHAR(100),
    Miestas VARCHAR(50),
    Rajonas VARCHAR(50),
    PastoKodas VARCHAR(10)
);

-- =========================
-- KĖBULO TIPAI
-- =========================
CREATE TABLE KebuloTipas (
    KebuloTipoID INT PRIMARY KEY AUTO_INCREMENT,
    Tipas VARCHAR(50),
    Aprasymas VARCHAR(255)
);

-- =========================
-- AUTOMOBILIAI
-- =========================
CREATE TABLE Masinos (
    MasinosID INT PRIMARY KEY AUTO_INCREMENT,
    KebuloTipoID INT,
    KlasesID INT,
    Gamintojas VARCHAR(50),
    Modelis VARCHAR(50),
    Spalva VARCHAR(30),
    KuroTipas VARCHAR(50),
    Metai YEAR,
    VIN VARCHAR(50) UNIQUE,
    Numeriai VARCHAR(20),
    Rida INT,
    Statusas ENUM('laisva','rezervuota','isnuomota','remonte') DEFAULT 'laisva',
    TAGaliojaIki DATE,
    DraudimasGaliojaIki DATE,
    DienosKaina DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (KebuloTipoID) REFERENCES KebuloTipas(KebuloTipoID),
    FOREIGN KEY (KlasesID) REFERENCES AutomobiliuKlases(KlasesID)
);

-- =========================
-- NUOMOS
-- =========================
CREATE TABLE Nuomos (
    NuomosID INT PRIMARY KEY AUTO_INCREMENT,
    VartotojoID INT,
    MasinosID INT,
    DarbuotojoID INT,
    PaemimoVietaID INT,
    PalikimoVietaID INT,
    NuomosData DATETIME,
    GrazinimoData DATETIME,
    Busena ENUM('rezervuota','aktyvi','baigta','atsaukta') DEFAULT 'rezervuota',
    VisaSuma DECIMAL(10,2),
    FOREIGN KEY (VartotojoID) REFERENCES Vartotojai(VartotojoID),
    FOREIGN KEY (MasinosID) REFERENCES Masinos(MasinosID),
    FOREIGN KEY (DarbuotojoID) REFERENCES Darbuotojai(DarbuotojoID),
    FOREIGN KEY (PaemimoVietaID) REFERENCES Vietoves(VietovesID),
    FOREIGN KEY (PalikimoVietaID) REFERENCES Vietoves(VietovesID)
);

-- =========================
-- MOKĖJIMAI
-- =========================
CREATE TABLE Mokejimai (
    MokejimoID INT PRIMARY KEY AUTO_INCREMENT,
    NuomosID INT,
    MokejimoData DATETIME,
    Suma DECIMAL(10,2),
    PVM DECIMAL(10,2),
    MokejimoBudas VARCHAR(50),
    Statusas ENUM('laukiama','apmoketa','atmesta','grazinta'),
    TransakcijosNr VARCHAR(100),
    FOREIGN KEY (NuomosID) REFERENCES Nuomos(NuomosID)
);

-- =========================
-- DEPOZITAI
-- =========================
CREATE TABLE Depozitai (
    DepozitoID INT PRIMARY KEY AUTO_INCREMENT,
    NuomosID INT,
    Suma DECIMAL(10,2),
    Grazintas BOOLEAN DEFAULT 0,
    GrazinimoData DATETIME,
    FOREIGN KEY (NuomosID) REFERENCES Nuomos(NuomosID)
);

-- =========================
-- PAPILDOMOS PASLAUGOS
-- =========================
CREATE TABLE PapildomosPaslaugos (
    PaslaugosID INT PRIMARY KEY AUTO_INCREMENT,
    Pavadinimas VARCHAR(100),
    DienosKaina DECIMAL(10,2)
);

CREATE TABLE NuomosPaslaugos (
    NuomosID INT,
    PaslaugosID INT,
    Kiekis INT DEFAULT 1,
    PRIMARY KEY (NuomosID, PaslaugosID),
    FOREIGN KEY (NuomosID) REFERENCES Nuomos(NuomosID),
    FOREIGN KEY (PaslaugosID) REFERENCES PapildomosPaslaugos(PaslaugosID)
);

-- =========================
-- TECHNINĖ PRIEŽIŪRA
-- =========================
CREATE TABLE TechninePrieziura (
    PrieziurosID INT PRIMARY KEY AUTO_INCREMENT,
    MasinosID INT NOT NULL,
    Tipas ENUM('TA','Servisas','Remontas'),
    AtlikimoData DATE NOT NULL,
    GaliojaIki DATE NOT NULL,
    Aprasymas TEXT,
    Kaina DECIMAL(10,2),
    FOREIGN KEY (MasinosID) REFERENCES Masinos(MasinosID)
);


-- =========================
-- VEIKSMŲ ŽURNALAS (AUDITAS)
-- =========================
CREATE TABLE VeiksmuZurnalas (
    ZurnaloID INT PRIMARY KEY AUTO_INCREMENT,
    DarbuotojoID INT,
    Veiksmas VARCHAR(255),
    LentelesPavadinimas VARCHAR(50),
    IrasaID INT,
    Data DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DarbuotojoID) REFERENCES Darbuotojai(DarbuotojoID)
);

-- =========================
-- AUTOMOBILIU KLASES
-- =========================
CREATE TABLE AutomobiliuKlases (
    KlasesID INT PRIMARY KEY AUTO_INCREMENT,
    Pavadinimas ENUM('Ekonomine','Standartine','Premium') UNIQUE,
    MinimalusVairavimoStazas INT NOT NULL,
    Aprasymas VARCHAR(255)
);

-- =========================
-- AUTO NUOTRAUKOS
-- =========================

CREATE TABLE MasinuNuotraukos (
    MasinosID INT PRIMARY KEY,
    NuotraukosURL VARCHAR(255) NOT NULL,
    IkelimoData DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (MasinosID) REFERENCES Masinos(MasinosID)
);

-- =========================
-- TRIGGER DEL AUTO KLASES PASIRINKIMO
-- =========================

DELIMITER $$

CREATE TRIGGER trg_tikrinti_vairavimo_staza
BEFORE INSERT ON Nuomos
FOR EACH ROW
BEGIN
    DECLARE klases_stazas INT;
    DECLARE vartotojo_stazas INT;

    -- Kliento vairavimo stazas
    SELECT VairavimoStazas
    INTO vartotojo_stazas
    FROM Vartotojai
    WHERE VartotojoID = NEW.VartotojoID;

    -- Reikalingas stazas pagal automobilio klase
    SELECT ak.MinimalusVairavimoStazas
    INTO klases_stazas
    FROM Masinos m
    JOIN AutomobiliuKlases ak ON m.KlasesID = ak.KlasesID
    WHERE m.MasinosID = NEW.MasinosID;

    -- Tikrinimas
    IF vartotojo_stazas < klases_stazas THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nuoma negalima: nepakankamas vairavimo stazas pasirinktai automobilio klasei';
    END IF;
END$$

DELIMITER ;

-- =========================
-- TRIGGER DEL AUTO TECH GALIOJIMO
-- =========================
DELIMITER $$

CREATE TRIGGER trg_tikrinti_technine_apziura
BEFORE INSERT ON Nuomos
FOR EACH ROW
BEGIN
    DECLARE galiojanti_ta DATE;

    SELECT MAX(GaliojaIki)
    INTO galiojanti_ta
    FROM TechninePrieziura
    WHERE MasinosID = NEW.MasinosID
      AND Tipas = 'TA';

    IF galiojanti_ta IS NULL OR galiojanti_ta < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nuoma negalima: automobilio technine apziura negalioja';
    END IF;
END$$

DELIMITER ;

-- =========================
-- VIEW PAZIURETI PATOGIAI TECH GALIOJIMUS
-- =========================

CREATE VIEW MasinuTechnineBukle AS
SELECT 
    m.MasinosID,
    m.Gamintojas,
    m.Modelis,
    MAX(tp.GaliojaIki) AS TechnikineGaliojaIki
FROM Masinos m
LEFT JOIN TechninePrieziura tp 
    ON m.MasinosID = tp.MasinosID
    AND tp.Tipas = 'TA'
GROUP BY m.MasinosID;

-- =======Pripildome duomenimis======== --

-- Automobilių klasės
INSERT INTO AutomobiliuKlases (Pavadinimas, MinimalusVairavimoStazas, Aprasymas) VALUES
('Ekonomine', 1, 'Maža kaina, paprasta komforto klasė'),
('Standartine', 3, 'Vidutinė klasė, daugiau komforto'),
('Premium', 5, 'Prabangūs automobiliai, aukštas komfortas');

-- Kėbulo tipai
INSERT INTO KebuloTipas (Tipas, Aprasymas) VALUES
('Sedanas', '4 durų sedanas'),
('Hatchback', 'Kompaktiškas automobilis'),
('SUV', 'Didesnis automobilis, daugiau vietos'),
('Universalas', 'Automobilis su didesne bagažine'),
('Cabriolet', 'Atviras automobilis');

-- Vietovės / Nuomos punktai
INSERT INTO Vietoves (Pavadinimas, Adresas, Miestas, Rajonas, PastoKodas) VALUES
('Vilnius Centras', 'Gedimino pr. 1', 'Vilnius', 'Centras', '01103'),
('Kaunas Centras', 'Laisvės al. 10', 'Kaunas', 'Centras', '44299'),
('Klaipėda Uostas', 'Herkaus Manto g. 5', 'Klaipėda', 'Centras', '91234'),
('Šiauliai', 'Tilžės g. 20', 'Šiauliai', 'Centras', '77123'),
('Panevėžys', 'Laisvės g. 25', 'Panevėžys', 'Centras', '35101');

-- Vartotojai (30)
INSERT INTO Vartotojai (Vardas, Pavarde, GimimoData, VairavimoStazas, VairuotojoPazymejimoNr, VairuotojoPazymejimoGaliojaIki, Email, Telefonas) VALUES
('Jonas','Petraitis','1985-05-12',5,'LT123456','2030-12-31','jonas.petraitis@gmail.com','+37060000101'),
('Aiste','Kazlauskiene','1990-08-22',2,'LT223344','2028-06-30','aiste.kaz@gmail.com','+37060000102'),
('Mantas','Jankauskas','1995-02-15',4,'LT334455','2029-11-30','mantas.j@gmail.com','+37060000103'),
('Rasa','Dirgelyte','1988-09-03',6,'LT445566','2032-01-01','rasa.dirg@gmail.com','+37060000104'),
('Tomas','Vasiliauskas','1992-12-11',3,'LT556677','2030-05-15','tomas.vas@gmail.com','+37060000105'),
('Laura','Stankeviciute','1994-03-21',1,'LT667788','2027-10-10','laura.st@gmail.com','+37060000106'),
('Darius','Kavaliauskas','1980-07-07',10,'LT778899','2033-03-20','darius.kav@gmail.com','+37060000107'),
('Simona','Gelaite','1993-11-18',2,'LT889900','2028-08-25','simona.g@gmail.com','+37060000108'),
('Edgaras','Pocius','1987-06-30',7,'LT990011','2031-09-15','edgaras.p@gmail.com','+37060000109'),
('Inga','Barauskaite','1996-01-05',1,'LT101112','2027-12-31','inga.b@gmail.com','+37060000110'),
('Karolis','Urbonas','1991-05-15',3,'LT101113','2030-11-20','karolis.u@gmail.com','+37060000111'),
('Egle','Paulauskiene','1992-08-21',2,'LT101114','2028-12-31','egle.p@gmail.com','+37060000112'),
('Mindaugas','Petraitis','1989-03-11',6,'LT101115','2032-05-10','mindaugas.p@gmail.com','+37060000113'),
('Ruta','Jankauskiene','1995-09-29',1,'LT101116','2027-08-15','ruta.j@gmail.com','+37060000114'),
('Tadas','Kazlauskas','1986-12-05',8,'LT101117','2032-02-20','tadas.k@gmail.com','+37060000115'),
('Aurelija','Barauskiene','1993-07-17',2,'LT101118','2028-09-30','aurelija.b@gmail.com','+37060000116'),
('Evaldas','Petrauskas','1990-11-22',4,'LT101119','2029-05-01','evaldas.p@gmail.com','+37060000117'),
('Indre','Stankeviciute','1994-04-04',1,'LT101120','2027-06-20','indre.s@gmail.com','+37060000118'),
('Dovydas','Zukauskas','1988-10-30',7,'LT101121','2031-11-15','dovydas.z@gmail.com','+37060000119'),
('Laura','Paulauskiene','1992-02-14',3,'LT101122','2030-03-01','laura.p@gmail.com','+37060000120'),
('Marius','Petraitis','1987-08-08',5,'LT101123','2030-12-31','marius.p@gmail.com','+37060000121'),
('Ieva','Jankauskaite','1996-06-10',1,'LT101124','2027-09-10','ieva.j@gmail.com','+37060000122'),
('Dainius','Kazlauskas','1985-03-19',9,'LT101125','2032-01-20','dainius.k@gmail.com','+37060000123'),
('Simona','Urboniene','1993-12-05',2,'LT101126','2028-10-30','simona.u@gmail.com','+37060000124'),
('Andrius','Stankevicius','1989-05-25',6,'LT101127','2031-04-15','andrius.s@gmail.com','+37060000125'),
('Inga','Paulauskiene','1994-11-11',3,'LT101128','2030-06-30','inga.p@gmail.com','+37060000126'),
('Rokas','Petraitis','1990-09-09',4,'LT101129','2029-12-01','rokas.p@gmail.com','+37060000127'),
('Laura','Jankauskaite','1995-01-01',2,'LT101130','2028-07-20','laura.j@gmail.com','+37060000128'),
('Darius','Kazlauskas','1988-02-28',5,'LT101131','2030-10-15','darius.k@gmail.com','+37060000129'),
('Egle','Urboniene','1991-04-04',3,'LT101132','2030-01-30','egle.u@gmail.com','+37060000130');

-- Darbuotojai (5)
INSERT INTO Darbuotojai (Vardas, Pavarde, Email, Telefonas, IdarbinimoData) VALUES
('Evaldas','Petrauskas','evaldas.pet@gmail.com','+37061100001','2020-01-10'),
('Justina','Kavaliauskiene','justina.kav@gmail.com','+37061100002','2021-03-15'),
('Andrius','Paulauskas','andrius.paul@gmail.com','+37061100003','2019-07-20'),
('Rita','Jankauskiene','rita.jan@gmail.com','+37061100004','2022-05-05'),
('Mindaugas','Stankevicius','mindaugas.st@gmail.com','+37061100005','2018-11-01');

-- Automobiliai (15)
INSERT INTO Masinos (KebuloTipoID, KlasesID, Gamintojas, Modelis, Spalva, KuroTipas, Metai, VIN, Numeriai, Rida, Statusas, DienosKaina) VALUES
(1,1,'Toyota','Corolla','Balta','Benzinas',2019,'VIN1234567890','ABC111',50000,'laisva',30.00),
(2,1,'Honda','Civic','Juoda','Benzinas',2020,'VIN1234567891','ABC112',30000,'laisva',32.00),
(3,2,'BMW','320i','Melyna','Dyzelinas',2018,'VIN1234567892','ABC113',40000,'laisva',50.00),
(4,2,'Audi','A4','Pilka','Benzinas',2019,'VIN1234567893','ABC114',35000,'laisva',52.00),
(5,3,'Mercedes','E200','Balta','Benzinas',2021,'VIN1234567894','ABC115',20000,'laisva',80.00),
(1,1,'Ford','Focus','Raudona','Benzinas',2017,'VIN1234567895','ABC116',60000,'laisva',28.00),
(2,2,'Volkswagen','Passat','Juoda','Dyzelinas',2020,'VIN1234567896','ABC117',45000,'laisva',45.00),
(3,3,'Audi','A6','Melyna','Benzinas',2021,'VIN1234567897','ABC118',25000,'laisva',85.00),
(4,1,'Hyundai','i30','Balta','Benzinas',2018,'VIN1234567898','ABC119',32000,'laisva',30.00),
(5,2,'Skoda','Octavia','Pilka','Dyzelinas',2019,'VIN1234567899','ABC120',40000,'laisva',42.00),
(1,1,'Renault','Clio','Raudona','Benzinas',2017,'VIN1234567800','ABC121',38000,'laisva',25.00),
(2,2,'Peugeot','308','Melyna','Dyzelinas',2018,'VIN1234567801','ABC122',36000,'laisva',40.00),
(3,3,'BMW','520d','Juoda','Dyzelinas',2020,'VIN1234567802','ABC123',30000,'laisva',75.00),
(4,2,'Mercedes','C180','Balta','Benzinas',2019,'VIN1234567803','ABC124',32000,'laisva',55.00),
(5,3,'Audi','A7','Pilka','Benzinas',2021,'VIN1234567804','ABC125',15000,'laisva',90.00);

-- MasinuNuotraukos (viena nuotrauka kiekvienam automobiliui)
INSERT INTO MasinuNuotraukos (MasinosID, NuotraukosURL) VALUES
(1,'/img/toyota_corolla.jpg'),
(2,'/img/honda_civic.jpg'),
(3,'/img/bmw_320i.jpg'),
(4,'/img/audi_a4.jpg'),
(5,'/img/mercedes_e200.jpg'),
(6,'/img/ford_focus.jpg'),
(7,'/img/vw_passat.jpg'),
(8,'/img/audi_a6.jpg'),
(9,'/img/hyundai_i30.jpg'),
(10,'/img/skoda_octavia.jpg'),
(11,'/img/renault_clio.jpg'),
(12,'/img/peugeot_308.jpg'),
(13,'/img/bmw_520d.jpg'),
(14,'/img/mercedes_c180.jpg'),
(15,'/img/audi_a7.jpg');

-- TechninePrieziura
INSERT INTO TechninePrieziura (MasinosID, Tipas, AtlikimoData, GaliojaIki, Aprasymas, Kaina) VALUES
(1,'TA','2023-01-10','2025-01-10','Reguliari TA',50.00),
(2,'TA','2023-06-15','2025-06-15','Reguliari TA',50.00),
(3,'TA','2023-03-20','2025-03-20','Reguliari TA',55.00),
(4,'TA','2023-07-05','2025-07-05','Reguliari TA',55.00),
(5,'TA','2023-02-28','2025-02-28','Reguliari TA',60.00),
(6,'TA','2023-01-12','2025-01-12','Reguliari TA',45.00),
(7,'TA','2023-08-10','2025-08-10','Reguliari TA',50.00),
(8,'TA','2023-04-18','2025-04-18','Reguliari TA',60.00),
(9,'TA','2023-03-01','2025-03-01','Reguliari TA',48.00),
(10,'TA','2023-05-15','2025-05-15','Reguliari TA',50.00),
(11,'TA','2023-01-20','2025-01-20','Reguliari TA',40.00),
(12,'TA','2023-06-01','2025-06-01','Reguliari TA',42.00),
(13,'TA','2023-02-10','2025-02-10','Reguliari TA',55.00),
(14,'TA','2023-04-05','2025-04-05','Reguliari TA',50.00),
(15,'TA','2023-03-15','2025-03-15','Reguliari TA',60.00);

-- Nuomos (10–15 logiškų nuomų, vartotojai atitinka klasę)
INSERT INTO Nuomos (VartotojoID, MasinosID, DarbuotojoID, PaemimoVietaID, PalikimoVietaID, NuomosData, GrazinimoData, VisaSuma) VALUES
(1,1,1,1,2,'2025-12-01 10:00:00','2025-12-05 10:00:00',120.00),
(2,2,2,2,2,'2025-12-03 09:00:00','2025-12-04 09:00:00',32.00),
(3,3,3,3,3,'2025-11-20 14:00:00','2025-11-25 14:00:00',250.00),
(4,5,4,1,1,'2025-12-10 08:00:00','2025-12-15 08:00:00',400.00),
(5,6,5,4,4,'2025-12-02 12:00:00','2025-12-03 12:00:00',28.00),
(6,7,1,2,3,'2025-12-05 11:00:00','2025-12-08 11:00:00',135.00),
(7,8,2,3,1,'2025-12-07 15:00:00','2025-12-10 15:00:00',255.00),
(8,9,3,4,5,'2025-12-01 09:00:00','2025-12-03 09:00:00',60.00),
(9,10,4,5,1,'2025-12-04 16:00:00','2025-12-07 16:00:00',126.00),
(10,11,5,1,2,'2025-12-06 08:00:00','2025-12-09 08:00:00',75.00);

-- Mokejimai
INSERT INTO Mokejimai (NuomosID, MokejimoData, Suma, MokejimoBudas) VALUES
(1,'2025-12-01 09:50:00',120.00,'Kredito kortelė'),
(2,'2025-12-03 08:50:00',32.00,'Banko pavedimas'),
(3,'2025-11-20 13:50:00',250.00,'Kredito kortelė'),
(4,'2025-12-10 07:50:00',400.00,'Kredito kortelė'),
(5,'2025-12-02 11:50:00',28.00,'Banko pavedimas'),
(6,'2025-12-05 10:50:00',135.00,'Kredito kortelė'),
(7,'2025-12-07 14:50:00',255.00,'Kredito kortelė'),
(8,'2025-12-01 08:50:00',60.00,'Banko pavedimas'),
(9,'2025-12-04 15:50:00',126.00,'Kredito kortelė'),
(10,'2025-12-06 07:50:00',75.00,'Banko pavedimas');

-- Depozitai
INSERT INTO Depozitai (NuomosID, Suma, Busena) VALUES
(1,50.00,'Gautas'),
(2,20.00,'Gautas'),
(3,80.00,'Gautas'),
(4,100.00,'Gautas'),
(5,30.00,'Gautas'),
(6,40.00,'Gautas'),
(7,90.00,'Gautas'),
(8,25.00,'Gautas'),
(9,35.00,'Gautas'),
(10,20.00,'Gautas');

-- Papildomos paslaugos
INSERT INTO PapildomosPaslaugos (Pavadinimas, Aprasymas, Kaina) VALUES
('GPS','Navigacijos sistema',5.00),
('Vaiko kede','Automobilinė vaiko kėdutė',7.00),
('Papildomas vairuotojas','Galimybė turėti papildomą vairuotoją',10.00),
('Wi-Fi','Automobilio Wi-Fi',3.00);

-- NuomosPaslaugos
INSERT INTO NuomosPaslaugos (NuomosID, PapildomosPaslaugosID) VALUES
(1,1),
(1,2),
(2,1),
(3,3),
(4,2),
(5,1),
(6,1),
(6,4),
(7,2),
(8,3),
(9,1),
(10,4);

-- Veiksmų žurnalas (audit)
INSERT INTO VeiksmuZurnalas (DarbuotojoID, Veiksmas, LentelesPavadinimas, IrasaID, Data) VALUES
(1,'Sukurta nuoma','Nuomos',1,'2025-12-01 10:01:00'),
(2,'Sukurta nuoma','Nuomos',2,'2025-12-03 09:01:00'),
(3,'Sukurta nuoma','Nuomos',3,'2025-11-20 14:01:00'),
(4,'Sukurta nuoma','Nuomos',4,'2025-12-10 08:01:00'),
(5,'Sukurta nuoma','Nuomos',5,'2025-12-02 12:01:00'),
(1,'Atliktas mokėjimas','Mokejimai',1,'2025-12-01 09:51:00'),
(2,'Atliktas mokėjimas','Mokejimai',2,'2025-12-03 08:51:00'),
(3,'Atliktas mokėjimas','Mokejimai',3,'2025-11-20 13:51:00'),
(4,'Atliktas mokėjimas','Mokejimai',4,'2025-12-10 07:51:00'),
(5,'Atliktas mokėjimas','Mokejimai',5,'2025-12-02 11:51:00');


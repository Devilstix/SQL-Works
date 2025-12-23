
			-- ======================== --
-- ========== UAB MODERENT ========== --
			-- ======================== --
            
-- 1. Sukuriame duomenų bazę
CREATE DATABASE IF NOT EXISTS AutoNuoma;
USE AutoNuoma;

-- 2. Lentelės

-- Vartotojai
CREATE TABLE Vartotojai (
   VartotojoID INT PRIMARY KEY,
    Vardas VARCHAR(50),
    Pavarde VARCHAR(50),
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telefonas VARCHAR(20) NOT NULL UNIQUE);
    -- vairavimo stazas ar amzius

-- Darbuotojai
CREATE TABLE Darbuotojai (
    DarbuotojoID INT PRIMARY KEY,
    Vardas VARCHAR(50),
    Pavarde VARCHAR(50),
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telefonas VARCHAR(20) NOT NULL UNIQUE,
    IdarbinimoData DATE
);

-- Vietoves, autonuomu taskai
CREATE TABLE Vietoves (
   VietovesID INT PRIMARY KEY,
    Pavadinimas VARCHAR(50),
    Adresas VARCHAR(100),
    Miestas VARCHAR(50),
    Rajonas VARCHAR(50),
    PastoKodas VARCHAR(10)
);

-- Kebulo tipas ir aprasymas
CREATE TABLE KebuloTipas (
    KebuloTipoID INT PRIMARY KEY,
    Tipas VARCHAR(50),
    Aprasymas VARCHAR(255)
);

-- Masinos papildyti del technikinio
CREATE TABLE Masinos (
    MasinosID INT PRIMARY KEY, -- auto pildymas
    KebuloTipoID INT,
    Gamintojas VARCHAR(50),
    Modelis VARCHAR(50),
    KuroTipas VARCHAR(50),
    Metai YEAR,
    Numeriai VARCHAR(20),
    DienosKaina DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (KebuloTipoID) REFERENCES KebuloTipas(KebuloTipoID)
);

-- Nuomos
CREATE TABLE Nuomos (
    NuomosID INT PRIMARY KEY,
    VartotojoID INT,
	MasinosID INT,
    DarbuotojoID INT,
    PaemimoVietaID INT,
    PalikimoVietaID INT,
    NuomosData DATETIME,
    GrazinimoData DATETIME,
    VisaSuma DECIMAL(10,2),
    FOREIGN KEY (VartotojoID) REFERENCES Vartotojai(VartotojoID),
    FOREIGN KEY (MasinosID) REFERENCES Masinos(MasinosID),
    FOREIGN KEY (DarbuotojoID) REFERENCES Darbuotojai(DarbuotojoID),
    FOREIGN KEY (PaemimoVietaID) REFERENCES Vietoves(VietovesID),
    FOREIGN KEY (PalikimoVietaID) REFERENCES Vietoves(VietovesID)
);

-- Mokejimai
CREATE TABLE Mokejimai (
    MokejimoID INT PRIMARY KEY,
    NuomosID INT,
    MokejimoData DATETIME,
    Suma DECIMAL(10,2),
    MokejimoBudas VARCHAR(50),
    FOREIGN KEY (NuomosID) REFERENCES Nuomos(NuomosID)
);

-- =======Pripildome duomenimis======== --

-- Vartotojai
INSERT INTO Vartotojai VALUES
(1,'Mantas','Kazlauskas','mantas.kazlauskas@gmail.com','+37061234567'),
(2,'Ieva','Petrauskaitė','ieva.petrauskaite@gmail.com','+37062345678'),
(3,'Tomas','Jankauskas','tomas.jankauskas@outlook.com','+37063456789'),
(4,'Laura','Vaitkutė','laura.vaitkute@gmail.com','+37064567890'),
(5,'Andrius','Mockus','andrius.mockus@gmail.com','+37065678901'),
(6,'Eglė','Stankevičiūtė','egle.stankeviciute@gmail.com','+37066789012'),
(7,'Paulius','Klimas','paulius.klimas@gmail.com','+37067890123'),
(8,'Rūta','Žukauskaitė','ruta.zukauskaite@gmail.com','+37068901234'),
(9,'Darius','Balčiūnas','darius.balciunas@outlook.com','+37061122334'),
(10,'Monika','Norkutė','monika.norkute@gmail.com','+37062233445'),
(11,'Lukas','Grigas','lukas.grigas@gmail.com','+37063344556'),
(12,'Simona','Vaičiulytė','simona.vaiciulyte@gmail.com','+37064455667'),
(13,'Vytautas','Kairys','vytautas.kairys@gmail.com','+37065566778'),
(14,'Karolina','Mikalauskaitė','karolina.mikalauskaite@gmail.com','+37066677889'),
(15,'Justinas','Pocius','justinas.pocius@gmail.com','+37067788990');

-- Darbuotojai
INSERT INTO Darbuotojai VALUES
(1,'Agnė','Bendoraitė','agne.bendoraiste@autonuoma.lt','+37061111111','2019-06-01'),
(2,'Rokas','Lukšys','rokas.luksys@autonuoma.lt','+37062222222','2021-02-15'),
(3,'Ingrida','Šimkutė','ingrida.simkute@autonuoma.lt','+37063333333','2022-09-10');

-- Vietoves
INSERT INTO Vietoves VALUES
(1,'Vilnius Centras','Gedimino pr. 1','Vilnius','Vilniaus','LT-01103'),
(2,'Kaunas Centras','Laisvės al. 10','Kaunas','Kauno','LT-44250'),
(3,'Klaipėdos Taskas ','Taikos pr. 5','Klaipėda','Klaipėdos','LT-92123'),
(4,'Šiauliukai','Tilžės g. 3','Šiauliai','Šiaulių','LT-78145'),
(5,'Panevėžiukas','Respublikos g. 7','Panevėžys','Panevėžio','LT-35173'),
(6,'Vilniaus Oro Uostas','Rodūnios kl. 2','Vilnius','Vilniaus','LT-02189');

-- Kebulo tipas ir aprasymas 
INSERT INTO KebuloTipas VALUES
(1,'Sedanas','Klasikinis sedanas'),
(2,'SUV','Didelis šeimos automobilis'),
(3,'Hečbekas','Kompaktiškas automobilis'),
(4,'Kabrioletas','Atviras automobilis'),
(5,'Universalas','Talpus automobilis');

-- Automobiliai
INSERT INTO Masinos VALUES
(1,1,'Toyota','Corolla','Hibridas',2022,'KBT347',35),
(2,1,'VW','Passat','Dyzelinas',2021,'JLM582',45),
(3,2,'BMW','X5','Dyzelinas',2023,'HNR901',90),
(4,2,'Audi','Q7','Dyzelinas',2022,'MVS274',85),
(5,3,'Ford','Focus','Benzinas',2020,'ZXC618',30),
(6,3,'VW','Golf','Dyzelinas',2021,'PLK439',32),
(7,4,'Mazda','MX-5','Benzinas',2023,'RTR712',110),
(8,5,'Skoda','Octavia','Dyzelinas',2022,'LGT506',40),
(9,1,'Honda','Civic','Benzinas',2021,'BNA883',34),
(10,2,'Toyota','RAV4','Hibridas',2022,'YKP194',60),
(11,3,'Hyundai','i30','Benzinas',2020,'FDS367',28),
(12,5,'Volvo','V60','Hibridas',2023,'WQE728',55),
(13,1,'Mercedes','C200','Benzinas',2022,'DMC451',70),
(14,2,'Kia','Sorento','Dyzelinas',2021,'GTR639',65),
(15,3,'Opel','Astra','Benzinas',2020,'JXP204',29),
(16,1,'Renault','Talisman','Dyzelinas',2021,'KLS785',42),
(17,5,'Ford','Mondeo','Dyzelinas',2022,'PQR911',44),
(18,2,'Tesla','Model Y','Elektra',2023,'EVT123',95),
(19,3,'Peugeot','308','Dyzelinas',2021,'ZMP468',31),
(20,1,'Mazda','6','Benzinas',2022,'HJK350',48);


-- Nuomos
INSERT INTO Nuomos VALUES
(1,1,1,1,1,1,'2025-01-10','2025-01-15',175),
(2,2,3,2,2,2,'2025-02-05','2025-02-10',450),
(3,3,5,1,3,3,'2025-03-12','2025-03-16',120),
(4,4,7,3,6,1,'2025-04-01','2025-04-04',330),
(5,5,10,2,1,1,'2025-05-20','2025-05-27',420),
(6,6,12,1,4,4,'2025-06-03','2025-06-08',275),
(7,7,9,2,1,6,'2025-07-10','2025-07-15',170),
(8,8,2,3,2,1,'2025-08-01','2025-08-06',225),
(9,9,14,1,3,5,'2025-09-14','2025-09-20',390),
(10,10,18,2,6,6,'2025-10-05','2025-10-08',285),
(11,11,6,1,1,2,'2025-11-02','2025-11-06',128),
(12,12,8,2,4,4,'2025-12-10','2025-12-15',200),
(13,13,11,3,5,5,'2025-06-18','2025-06-21',84),
(14,14,16,1,2,3,'2025-07-22','2025-07-27',210),
(15,15,20,2,1,1,'2025-09-01','2025-09-06',240);

-- Mokejimai
INSERT INTO Mokejimai VALUES
(1,1,'2025-01-10',175,'Kortele'),
(2,2,'2025-02-05',450,'Bankinis'),
(3,3,'2025-03-12',120,'Grynieji'),
(4,4,'2025-04-01',330,'Kortele'),
(5,5,'2025-05-20',420,'Online'),
(6,6,'2025-06-03',275,'Kortele'),
(7,7,'2025-07-10',170,'Online'),
(8,8,'2025-08-01',225,'Bankinis'),
(9,9,'2025-09-14',390,'Kortele'),
(10,10,'2025-10-05',285,'Online'),
(11,11,'2025-11-02',128,'Grynieji'),
(12,12,'2025-12-10',200,'Kortele'),
(13,13,'2025-06-18',84,'Bankinis'),
(14,14,'2025-07-22',210,'Online'),
(15,15,'2025-09-01',240,'Kortele');
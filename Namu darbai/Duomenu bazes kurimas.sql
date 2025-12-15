
CREATE SCHEMA `auto_nuoma` ;

CREATE TABLE vartotojai (
    vartotojo_id INT PRIMARY KEY,
    kliento_vardas VARCHAR(100),
    email VARCHAR(100));
    
ALTER TABLE vartotojai
ADD COLUMN kliento_pavarde VARCHAR(100) ;
    
CREATE TABLE automobiliai (
    auto_id INT PRIMARY KEY,
    auto_pavadinimas VARCHAR(100),
    kategorijos_id INT,
	FOREIGN KEY ( kategorijos_id) REFERENCES kategorijos(kategorijos_id));
    
ALTER TABLE automobiliai
ADD COLUMN auto_pavadinimas VARCHAR(100);
    
CREATE TABLE uzsakymai (
    uzsakymo_id INT PRIMARY KEY,
    vartotojo_id INT,
    uzsakymo_data DATE,
    FOREIGN KEY (vartotojo_id) REFERENCES vartotojai( vartotojo_id));
    
ALTER TABLE uzsakymai
MODIFY COLUMN uzsakymo_data TIMESTAMP;

ALTER TABLE uzsakymai
ADD COLUMN grazinimo_data TIMESTAMP;

    
CREATE TABLE kategorijos (
    kategorijos_id INT PRIMARY KEY,
	marke VARCHAR(100),
	modelis VARCHAR(100));
    
ALTER TABLE kategorijos
CHANGE COLUMN marke kategorijos_pavadinimas VARCHAR(100);
ALTER TABLE kategorijos
DROP COLUMN modelis;
    
CREATE TABLE nuoma (
    nuomos_id INT PRIMARY KEY,
    uzsakymo_id INT,
    kaina INT,
    FOREIGN KEY (uzsakymo_id) REFERENCES uzsakymai( uzsakymo_id));
    
    INSERT INTO vartotojai (vartotojo_id, kliento_vardas, kliento_pavarde, email) VALUES
('1', 'Jonas', 'Kevalas', 'j.kavalierius@gmail.com'),
('2', 'Monika', 'Tvoraite', 'monikute@gmail.com'),
('3', 'Giedrius', 'Simonaitis', 'simonaitixxx@gmail.com'),
('4', 'Laura', 'Vainyte', 'vainiux69@gmail.com');

INSERT INTO vartotojai (vartotojo_id, kliento_vardas, kliento_pavarde, email) VALUES
('5', 'Gabrielius', 'Stonkus', 'babston@gmail.com'),
('6', 'Saulius', 'Zubravicius', 'superzuber@gmail.com');

SELECT * FROM vartotojai;


INSERT INTO automobiliai (auto_id, kategorijos_id, auto_pavadinimas) VALUES
('1', '2', 'Dodge Durango'),
('2', '1', 'BMW 525d'),
('3', '3', 'VW Golf'),
('4', '2', 'Honda CRV'),
('5', '1', 'Opel Insignia'),
('6', '3', 'Toyota Yaris');

SELECT * FROM automobiliai;

INSERT INTO kategorijos (kategorijos_id, kategorijos_pavadinimas) VALUES
('1', 'Sedanas'),
('2', 'SUV'),
('3', 'Hecbekas');

SELECT * FROM kategorijos;

INSERT INTO uzsakymai (uzsakymo_id, vartotojo_id, uzsakymo_data) VALUES
('1', '4', '2025-03-04'),
('2', '1', '2025-06-30'),
('3', '3', '2025-09-01'),
('4', '2', '2025-07-15');

SELECT * FROM uzsakymai;

INSERT INTO nuoma (nuomos_id, uzsakymo_id, kaina) VALUES
('1', '2', '284'),
('2', '4', '127'),
('3', '1', '469'),
('4', '3', '98');

SELECT * FROM nuoma;




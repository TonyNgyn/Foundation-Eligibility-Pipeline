-- ============================================================
--  Foundation Eligibility Pipeline Tracker
--  Author: Tony Nguyen
--  MySQL Workbench Compatible Version
--  Description: Tracks patient applications through the
--  Genentech Foundation eligibility pipeline, including
--  document completeness, follow-up activity, and outcomes.
-- ============================================================

-- ============================================================
--  SETUP — run this first
-- ============================================================

CREATE DATABASE IF NOT EXISTS foundation_pipeline;
USE foundation_pipeline;

-- ============================================================
--  SCHEMA
-- ============================================================

DROP TABLE IF EXISTS followup_log;
DROP TABLE IF EXISTS patients;

CREATE TABLE patients (
    patient_id          INT           PRIMARY KEY,
    first_name          VARCHAR(50)   NOT NULL,
    last_name           VARCHAR(50)   NOT NULL,
    date_of_birth       DATE,
    state               CHAR(2),
    insurer             VARCHAR(100),
    drug                VARCHAR(100),
    prescriber          VARCHAR(100),
    application_date    DATE          NOT NULL,
    agi                 INT,
    household_size      INT,
    fpl_pct             DECIMAL(5,1),
    has_consent_form    TINYINT(1)    DEFAULT 0,
    has_rx_form         TINYINT(1)    DEFAULT 0,
    has_insurance_card  TINYINT(1)    DEFAULT 0,
    has_pa_letter       TINYINT(1)    DEFAULT 0,
    has_income_proof    TINYINT(1)    DEFAULT 0,
    docs_complete       TINYINT(1)    DEFAULT 0,
    status              VARCHAR(20),
    resolution_date     DATE,
    delay_days          INT           DEFAULT 0
);

CREATE TABLE followup_log (
    followup_id         INT           PRIMARY KEY,
    patient_id          INT,
    missing_document    VARCHAR(100),
    contact_type        VARCHAR(20),
    followup_sent       DATE,
    resolved_date       DATE,
    resolved            TINYINT(1)    DEFAULT 0,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);


-- ============================================================
--  SEED DATA — PATIENTS (100 rows)
-- ============================================================
INSERT INTO patients VALUES
  (1,'Michael','Miller','1985-05-03','GA','Humana','Ocrevus','Dr. Linda Marsh','2024-11-23',22000,1,150.9,1,1,1,0,1,0,'Pending',NULL,8),
  (2,'Grace','Wilson','1949-03-03','WA','Self-Pay','Kadcyla','Dr. Marcus Webb','2024-08-02',28000,4,93.3,1,0,1,1,1,0,'Pending',NULL,8),
  (3,'Priya','Johnson','1944-02-10','TX','Kaiser','Perjeta','Dr. Marcus Webb','2024-01-23',70000,4,233.3,1,0,1,1,1,0,'Pending',NULL,8),
  (4,'Daniel','Miller','1954-08-29','AZ','Medicaid','Kadcyla','Dr. Grace Kim','2024-05-22',42000,6,104.3,1,1,1,0,1,0,'Incomplete',NULL,15),
  (5,'Kevin','Perez','1997-09-02','AZ','Cigna','Rituxan','Dr. Grace Kim','2024-12-16',34000,1,233.2,1,0,1,1,0,0,'Incomplete',NULL,18),
  (6,'Kevin','Taylor','1993-06-17','AZ','Cigna','Vabysmo','Dr. Grace Kim','2024-10-25',37000,3,148.8,0,1,1,0,0,0,'Pending',NULL,29),
  (7,'Rosa','Lopez','1985-07-18','GA','UnitedHealthcare','Tecentriq','Dr. Priya Patel','2024-02-27',31000,4,103.3,1,0,1,1,1,0,'Incomplete',NULL,9),
  (8,'David','Harris','1983-08-07','WA','Medicaid','Vabysmo','Dr. Priya Patel','2024-09-28',18000,5,51.2,1,1,1,0,0,0,'Pending',NULL,20),
  (9,'Carlos','Nguyen','1992-10-11','CO','Cigna','Tecentriq','Dr. Carlos Ruiz','2024-04-18',48000,6,119.2,1,1,1,1,0,0,'Pending',NULL,4),
  (10,'Daniel','Hall','1991-03-25','GA','Cigna','Avastin','Dr. Samuel Torres','2024-12-28',62000,1,425.2,1,1,1,1,1,1,'Denied','2025-01-02',0),
  (11,'Nicole','Williams','1945-06-09','IL','Aetna','Herceptin','Dr. Marcus Webb','2024-08-30',37000,2,187.6,1,1,1,1,1,1,'Pending',NULL,0),
  (12,'Maria','Lopez','1988-06-30','OR','Kaiser','Hemlibra','Dr. Samuel Torres','2024-05-07',28000,2,142.0,1,1,1,1,0,0,'Incomplete',NULL,4),
  (13,'Priya','Moore','1953-11-20','TX','UnitedHealthcare','Perjeta','Dr. Samuel Torres','2024-04-19',37000,1,253.8,1,0,1,0,1,0,'Incomplete',NULL,30),
  (14,'Linda','Perez','1991-02-09','TX','Kaiser','Phesgo','Dr. Carlos Ruiz','2024-01-26',55000,4,183.3,0,1,1,1,0,0,'Pending',NULL,15),
  (15,'David','Nguyen','1981-02-11','GA','Medicaid','Phesgo','Dr. Marcus Webb','2024-06-10',31000,2,157.2,1,1,1,1,1,1,'Pending',NULL,0),
  (16,'Nicole','Martin','1940-09-13','CO','Kaiser','Perjeta','Dr. Marcus Webb','2024-02-07',48000,2,243.4,1,0,0,0,1,0,'Incomplete',NULL,34),
  (17,'Grace','Brown','1997-02-26','FL','Humana','Rituxan','Dr. James Okafor','2024-04-14',62000,6,153.9,1,1,0,1,1,0,'Pending',NULL,4),
  (18,'Hana','Anderson','1958-11-05','TX','UnitedHealthcare','Hemlibra','Dr. Robert Hale','2024-01-05',22000,1,150.9,1,0,1,1,1,0,'Incomplete',NULL,5),
  (19,'Patricia','Lewis','2002-11-30','WA','Cigna','Kadcyla','Dr. Emily Chen','2024-11-13',70000,2,355.0,0,0,1,0,1,0,'Pending',NULL,28),
  (20,'Hana','Davis','1956-01-08','GA','Humana','Perjeta','Dr. Emily Chen','2024-04-08',37000,3,148.8,0,0,1,1,1,0,'Incomplete',NULL,9),
  (21,'Aisha','Thomas','1946-04-11','NY','Medicare','Phesgo','Dr. Robert Hale','2024-11-06',48000,1,329.2,0,1,1,1,1,0,'Incomplete',NULL,6),
  (22,'Thomas','Thompson','1966-12-31','IL','Medicare','Vabysmo','Dr. Emily Chen','2024-09-16',31000,6,77.0,1,1,1,1,1,1,'Denied','2024-09-21',0),
  (23,'Marcus','Johnson','1965-06-17','CO','Medicare','Phesgo','Dr. Robert Hale','2024-06-04',31000,2,157.2,1,1,1,1,1,1,'Denied','2024-06-09',0),
  (24,'David','Hernandez','1977-03-07','GA','Humana','Tecentriq','Dr. Aisha Diallo','2024-02-17',28000,6,69.5,1,1,1,1,1,1,'Incomplete',NULL,0),
  (25,'Emily','Hernandez','1944-07-03','CO','UnitedHealthcare','Tecentriq','Dr. Marcus Webb','2024-09-10',37000,2,187.6,1,1,1,0,1,0,'Pending',NULL,18),
  (26,'Hana','Jones','1982-08-02','AZ','Kaiser','Perjeta','Dr. Samuel Torres','2024-08-25',62000,5,176.4,1,0,0,1,1,0,'Incomplete',NULL,18),
  (27,'David','Thomas','1976-07-26','NY','Humana','Vabysmo','Dr. James Okafor','2024-08-13',22000,6,54.6,1,1,0,1,1,0,'Pending',NULL,3),
  (28,'Andre','Harris','1988-12-29','GA','Blue Cross Blue Shield','Tecentriq','Dr. James Okafor','2024-08-03',37000,5,105.3,0,1,1,1,1,0,'Incomplete',NULL,9),
  (29,'Mei','Brown','1981-06-02','CA','Medicare','Ocrevus','Dr. Grace Kim','2024-01-15',37000,3,148.8,1,0,0,0,1,0,'Incomplete',NULL,24),
  (30,'Barbara','Garcia','1941-10-29','GA','Blue Cross Blue Shield','Rituxan','Dr. Samuel Torres','2024-05-09',22000,4,73.3,1,1,0,1,1,0,'Pending',NULL,2),
  (31,'Sara','Nguyen','1967-12-27','GA','Humana','Kadcyla','Dr. Aisha Diallo','2024-10-15',28000,4,93.3,1,1,1,0,1,0,'Incomplete',NULL,8),
  (32,'Tyler','Smith','1971-02-24','CO','Cigna','Kadcyla','Dr. Robert Hale','2024-10-30',70000,6,173.8,1,1,1,1,1,1,'Incomplete',NULL,0),
  (33,'Fatima','Gonzalez','1953-09-22','IL','Medicaid','Rituxan','Dr. Linda Marsh','2024-02-05',48000,6,119.2,1,1,1,1,1,1,'Incomplete',NULL,0),
  (34,'William','Perez','1980-06-10','TX','Kaiser','Avastin','Dr. Carlos Ruiz','2024-11-29',31000,5,88.2,1,1,1,1,1,1,'Approved','2024-12-03',0),
  (35,'Emily','Garcia','1947-09-06','TX','Medicaid','Kadcyla','Dr. James Okafor','2024-11-08',62000,4,206.7,1,0,1,1,0,0,'Incomplete',NULL,12),
  (36,'Aisha','Gonzalez','1980-09-15','FL','Cigna','Perjeta','Dr. Grace Kim','2024-01-09',22000,3,88.5,1,1,1,1,1,1,'Approved','2024-01-17',0),
  (37,'Grace','Martin','1993-07-16','FL','Cigna','Hemlibra','Dr. Samuel Torres','2024-04-28',22000,6,54.6,1,1,0,1,1,0,'Pending',NULL,6),
  (38,'Samuel','Nguyen','1991-07-02','FL','Kaiser','Avastin','Dr. James Okafor','2024-04-01',31000,1,212.6,1,1,1,1,0,0,'Incomplete',NULL,4),
  (39,'Susan','Johnson','1962-04-07','WA','Aetna','Vabysmo','Dr. Aisha Diallo','2024-05-09',42000,1,288.1,1,1,1,1,1,1,'Pending',NULL,0),
  (40,'Thomas','Harris','1948-11-25','TX','Cigna','Tecentriq','Dr. Grace Kim','2024-11-06',55000,5,156.5,1,1,0,1,1,0,'Incomplete',NULL,2),
  (41,'Priya','Walker','1980-09-24','WA','Aetna','Tecentriq','Dr. Grace Kim','2024-05-02',25000,5,71.1,1,1,1,1,1,1,'Approved','2024-05-09',0),
  (42,'Fatima','Williams','1982-01-18','FL','Cigna','Kadcyla','Dr. Grace Kim','2024-11-16',55000,6,136.5,1,1,1,0,0,0,'Pending',NULL,18),
  (43,'Grace','Clark','1955-09-19','AZ','Blue Cross Blue Shield','Vabysmo','Dr. James Okafor','2024-06-14',55000,3,221.2,1,0,1,1,0,0,'Incomplete',NULL,12),
  (44,'Rosa','Clark','1989-05-08','OR','Medicare','Avastin','Dr. Marcus Webb','2024-02-16',42000,3,168.9,1,1,1,1,1,1,'Approved','2024-02-25',0),
  (45,'Aisha','White','1984-09-20','AZ','Aetna','Ocrevus','Dr. Samuel Torres','2024-06-10',31000,3,124.7,0,1,1,0,1,0,'Incomplete',NULL,21),
  (46,'Rosa','Hall','1950-03-06','AZ','Self-Pay','Hemlibra','Dr. Priya Patel','2024-03-03',18000,6,44.7,1,1,1,1,1,1,'Denied','2024-03-09',0),
  (47,'Eric','White','1985-08-06','CA','Kaiser','Hemlibra','Dr. Grace Kim','2024-09-12',70000,3,281.6,1,1,1,1,1,1,'Approved','2024-09-18',0),
  (48,'Aisha','Wilson','1989-07-07','CO','Humana','Kadcyla','Dr. James Okafor','2024-07-31',34000,5,96.8,1,1,1,1,0,0,'Pending',NULL,10),
  (49,'Jorge','Smith','1951-04-29','CO','Medicare','Phesgo','Dr. Robert Hale','2024-10-19',37000,2,187.6,1,1,1,0,1,0,'Incomplete',NULL,9),
  (50,'Carlos','White','2002-02-22','IL','Blue Cross Blue Shield','Hemlibra','Dr. Robert Hale','2024-02-21',48000,4,160.0,1,1,1,1,1,1,'Incomplete',NULL,0),
  (51,'Barbara','Harris','1948-02-09','IL','Medicaid','Hemlibra','Dr. Marcus Webb','2024-12-11',48000,4,160.0,1,0,1,1,1,0,'Incomplete',NULL,9),
  (52,'Tyler','Jones','1955-04-02','CA','Medicaid','Hemlibra','Dr. Carlos Ruiz','2024-06-02',18000,1,123.5,1,1,1,1,1,1,'Pending',NULL,0),
  (53,'Hana','Lewis','1981-09-27','FL','Cigna','Vabysmo','Dr. Priya Patel','2024-07-14',55000,6,136.5,1,1,1,1,1,1,'Pending',NULL,0),
  (54,'Linda','Miller','1974-03-19','GA','Self-Pay','Herceptin','Dr. Carlos Ruiz','2024-02-07',42000,3,168.9,1,0,1,1,1,0,'Incomplete',NULL,12),
  (55,'Thomas','Lewis','1971-08-10','TX','Humana','Tecentriq','Dr. Carlos Ruiz','2024-01-12',62000,4,206.7,1,0,1,0,0,0,'Incomplete',NULL,34),
  (56,'Emily','Martin','1964-06-13','CA','Medicaid','Perjeta','Dr. James Okafor','2024-08-13',18000,5,51.2,1,1,1,0,1,0,'Incomplete',NULL,12),
  (57,'Andre','Anderson','1948-02-07','IL','UnitedHealthcare','Ocrevus','Dr. Grace Kim','2024-02-28',42000,1,288.1,1,1,1,1,1,1,'Incomplete',NULL,0),
  (58,'Eric','White','1959-11-10','WA','Medicaid','Avastin','Dr. Grace Kim','2024-10-01',22000,4,73.3,1,1,1,0,0,0,'Pending',NULL,15),
  (59,'Hana','Thomas','1998-10-03','WA','Cigna','Avastin','Dr. Carlos Ruiz','2024-09-09',22000,1,150.9,0,1,1,1,1,0,'Incomplete',NULL,5),
  (60,'Maria','Taylor','1964-10-01','TX','Cigna','Hemlibra','Dr. James Okafor','2024-01-17',70000,3,281.6,1,0,1,1,1,0,'Incomplete',NULL,10),
  (61,'Barbara','Wilson','1953-03-28','GA','UnitedHealthcare','Ocrevus','Dr. Grace Kim','2024-01-26',34000,2,172.4,1,1,1,1,1,1,'Incomplete',NULL,0),
  (62,'Sara','Wilson','1941-06-01','CA','Humana','Perjeta','Dr. Emily Chen','2024-03-15',25000,5,71.1,1,1,1,1,1,1,'Pending',NULL,0),
  (63,'Thomas','Smith','1999-02-10','CO','Kaiser','Perjeta','Dr. James Okafor','2024-03-05',70000,4,233.3,1,1,1,1,1,1,'Denied','2024-03-11',0),
  (64,'David','Brown','1964-09-02','GA','Molina','Phesgo','Dr. Linda Marsh','2024-11-25',18000,1,123.5,1,1,1,0,1,0,'Pending',NULL,9),
  (65,'Andre','Harris','1959-04-16','IL','Self-Pay','Avastin','Dr. Samuel Torres','2024-05-30',42000,5,119.5,1,1,1,1,1,1,'Incomplete',NULL,0),
  (66,'David','Johnson','1947-08-29','WA','Medicare','Kadcyla','Dr. Marcus Webb','2024-07-30',34000,4,113.3,1,1,1,1,1,1,'Approved','2024-08-09',0),
  (67,'Grace','Thomas','2004-09-08','OR','Blue Cross Blue Shield','Perjeta','Dr. Carlos Ruiz','2024-07-09',25000,5,71.1,1,1,1,1,1,1,'Pending',NULL,0),
  (68,'Grace','Davis','1991-07-04','TX','Self-Pay','Kadcyla','Dr. Linda Marsh','2024-06-08',34000,1,233.2,1,1,1,1,0,0,'Incomplete',NULL,4),
  (69,'Kevin','Johnson','1952-09-22','OR','Humana','Hemlibra','Dr. Linda Marsh','2024-01-14',55000,6,136.5,1,1,1,0,1,0,'Pending',NULL,17),
  (70,'Marcus','Johnson','1964-05-30','AZ','Humana','Kadcyla','Dr. James Okafor','2024-06-23',25000,3,100.6,1,1,1,1,1,1,'Approved','2024-06-26',0),
  (71,'Emily','Lee','1967-09-02','OR','Humana','Tecentriq','Dr. Aisha Diallo','2024-11-06',42000,4,140.0,1,1,1,1,1,1,'Pending',NULL,0),
  (72,'Patricia','Brown','1974-02-09','CO','Cigna','Tecentriq','Dr. Linda Marsh','2024-11-02',18000,1,123.5,1,1,1,1,1,1,'Approved','2024-11-11',0),
  (73,'Sara','Taylor','2003-08-26','IL','Aetna','Perjeta','Dr. Marcus Webb','2024-10-13',62000,3,249.4,1,1,1,1,1,1,'Approved','2024-10-22',0),
  (74,'Kevin','Martin','1947-01-21','IL','UnitedHealthcare','Perjeta','Dr. Robert Hale','2024-07-26',18000,3,72.4,1,1,1,0,1,0,'Pending',NULL,16),
  (75,'Robert','Davis','1957-09-12','CA','Aetna','Phesgo','Dr. Priya Patel','2024-02-09',48000,6,119.2,1,1,1,1,0,0,'Pending',NULL,4),
  (76,'Carlos','Brown','1979-06-15','WA','Self-Pay','Avastin','Dr. James Okafor','2024-11-17',42000,4,140.0,1,1,0,1,1,0,'Incomplete',NULL,7),
  (77,'Samuel','Johnson','1995-03-05','GA','Kaiser','Vabysmo','Dr. Aisha Diallo','2024-10-29',18000,3,72.4,1,1,1,1,1,1,'Pending',NULL,0),
  (78,'Tyler','Perez','1970-10-23','WA','Blue Cross Blue Shield','Vabysmo','Dr. Priya Patel','2024-08-24',55000,5,156.5,1,0,1,1,1,0,'Pending',NULL,6),
  (79,'David','Wilson','1948-06-23','CO','Kaiser','Kadcyla','Dr. Grace Kim','2024-08-12',42000,5,119.5,1,1,0,1,0,0,'Pending',NULL,15),
  (80,'Marcus','Gonzalez','2001-06-28','CO','Humana','Hemlibra','Dr. Aisha Diallo','2024-12-05',25000,3,100.6,0,1,1,1,0,0,'Pending',NULL,13),
  (81,'Emily','Smith','1999-05-21','NY','Cigna','Phesgo','Dr. Priya Patel','2024-04-19',34000,4,113.3,1,1,1,0,1,0,'Incomplete',NULL,21),
  (82,'Barbara','Jackson','1961-06-16','FL','UnitedHealthcare','Avastin','Dr. Samuel Torres','2024-04-02',70000,5,199.2,1,1,1,0,0,0,'Incomplete',NULL,29),
  (83,'Priya','Walker','1986-04-14','WA','UnitedHealthcare','Perjeta','Dr. Marcus Webb','2024-09-14',48000,4,160.0,1,0,1,1,1,0,'Incomplete',NULL,6),
  (84,'Barbara','Nguyen','1968-08-03','WA','Cigna','Herceptin','Dr. Priya Patel','2024-03-16',37000,1,253.8,1,0,0,1,1,0,'Pending',NULL,10),
  (85,'Linda','Clark','1965-11-05','TX','Self-Pay','Perjeta','Dr. Marcus Webb','2024-12-27',42000,4,140.0,1,1,1,1,0,0,'Incomplete',NULL,9),
  (86,'James','White','1971-08-27','TX','Aetna','Phesgo','Dr. Aisha Diallo','2024-11-23',55000,4,183.3,1,0,1,1,1,0,'Pending',NULL,11),
  (87,'William','Harris','1941-06-16','NY','Kaiser','Hemlibra','Dr. Robert Hale','2024-09-25',34000,1,233.2,1,1,1,1,0,0,'Pending',NULL,8),
  (88,'Tyler','Brown','1945-08-29','AZ','UnitedHealthcare','Ocrevus','Dr. Grace Kim','2024-10-24',70000,3,281.6,1,1,1,1,0,0,'Incomplete',NULL,5),
  (89,'William','Williams','1973-01-06','IL','Humana','Kadcyla','Dr. James Okafor','2024-04-12',18000,3,72.4,1,0,1,1,0,0,'Pending',NULL,13),
  (90,'Susan','Hernandez','1994-01-23','IL','Medicare','Rituxan','Dr. James Okafor','2024-09-22',31000,1,212.6,1,1,1,1,1,1,'Approved','2024-09-29',0),
  (91,'Tyler','Harris','2000-12-13','CA','Medicaid','Ocrevus','Dr. Priya Patel','2024-06-28',42000,1,288.1,1,1,1,0,1,0,'Incomplete',NULL,15),
  (92,'Aisha','Anderson','1979-10-30','WA','Cigna','Phesgo','Dr. Priya Patel','2024-01-18',25000,1,171.5,1,1,1,1,1,1,'Pending',NULL,0),
  (93,'Grace','Davis','2003-02-28','AZ','Medicaid','Tecentriq','Dr. Carlos Ruiz','2024-09-28',34000,4,113.3,1,1,1,0,1,0,'Incomplete',NULL,11),
  (94,'Priya','Johnson','1989-05-05','CO','Aetna','Perjeta','Dr. Grace Kim','2024-04-12',22000,2,111.6,1,0,1,1,1,0,'Pending',NULL,10),
  (95,'Thomas','Perez','1947-09-26','WA','Aetna','Perjeta','Dr. Aisha Diallo','2024-07-04',48000,2,243.4,0,1,1,1,1,0,'Incomplete',NULL,5),
  (96,'Grace','Brown','1978-10-24','CO','Aetna','Ocrevus','Dr. Marcus Webb','2024-07-29',37000,5,105.3,1,1,1,1,1,1,'Approved','2024-08-03',0),
  (97,'Andre','Davis','1951-03-25','FL','UnitedHealthcare','Phesgo','Dr. Linda Marsh','2024-09-22',25000,3,100.6,1,0,1,0,1,0,'Pending',NULL,25),
  (98,'Nicole','Garcia','1991-04-30','IL','Self-Pay','Phesgo','Dr. Emily Chen','2024-03-28',62000,5,176.4,1,0,1,1,0,0,'Incomplete',NULL,21),
  (99,'Carlos','Walker','2004-06-12','NY','Medicare','Herceptin','Dr. Aisha Diallo','2024-09-04',28000,6,69.5,1,1,1,1,1,1,'Approved','2024-09-09',0),
  (100,'Samuel','White','1977-07-06','TX','Kaiser','Rituxan','Dr. Robert Hale','2024-03-07',34000,5,96.8,1,1,1,1,1,1,'Approved','2024-03-16',0);

-- ============================================================
--  SEED DATA — FOLLOW-UP LOG
-- ============================================================
INSERT INTO followup_log VALUES
  (1,1,'Prior Auth Letter','Provider','2024-11-24','2024-12-14',1),
  (2,2,'Prescriber Form','Provider','2024-08-04','2024-08-15',1),
  (3,3,'Prescriber Form','Provider','2024-01-24','2024-02-08',1),
  (4,4,'Prior Auth Letter','Provider','2024-05-25','2024-06-04',1),
  (5,5,'Prescriber Form','Provider','2024-12-17',NULL,0),
  (6,5,'Income Documentation','Patient','2024-12-19','2025-01-04',1),
  (7,6,'Consent Form','Patient','2024-10-28','2024-10-31',1),
  (8,6,'Prior Auth Letter','Provider','2024-10-28','2024-11-17',1),
  (9,6,'Income Documentation','Patient','2024-10-27','2024-11-09',1),
  (10,7,'Prescriber Form','Provider','2024-02-29','2024-03-20',1),
  (11,8,'Prior Auth Letter','Provider','2024-09-29','2024-10-19',1),
  (12,8,'Income Documentation','Patient','2024-09-29','2024-10-15',1),
  (13,9,'Income Documentation','Patient','2024-04-19',NULL,0),
  (14,12,'Income Documentation','Patient','2024-05-08','2024-05-26',1),
  (15,13,'Prescriber Form','Provider','2024-04-20','2024-05-10',1),
  (16,13,'Prior Auth Letter','Provider','2024-04-20','2024-04-24',1),
  (17,14,'Consent Form','Patient','2024-01-27','2024-02-12',1),
  (18,14,'Income Documentation','Patient','2024-01-29','2024-02-17',1),
  (19,16,'Prescriber Form','Provider','2024-02-08','2024-02-14',1),
  (20,16,'Insurance Card','Patient','2024-02-10','2024-02-21',1),
  (21,16,'Prior Auth Letter','Provider','2024-02-09','2024-02-22',1),
  (22,17,'Insurance Card','Patient','2024-04-17','2024-05-07',1),
  (23,18,'Prescriber Form','Provider','2024-01-08','2024-01-24',1),
  (24,19,'Consent Form','Patient','2024-11-15',NULL,0),
  (25,19,'Prescriber Form','Provider','2024-11-15','2024-11-25',1),
  (26,19,'Prior Auth Letter','Provider','2024-11-14',NULL,0),
  (27,20,'Consent Form','Patient','2024-04-09','2024-04-23',1),
  (28,20,'Prescriber Form','Provider','2024-04-11','2024-04-27',1),
  (29,21,'Consent Form','Patient','2024-11-09','2024-11-21',1),
  (30,25,'Prior Auth Letter','Provider','2024-09-12',NULL,0),
  (31,26,'Prescriber Form','Provider','2024-08-28','2024-09-16',1),
  (32,26,'Insurance Card','Patient','2024-08-27','2024-09-07',1),
  (33,27,'Insurance Card','Patient','2024-08-15',NULL,0),
  (34,28,'Consent Form','Patient','2024-08-04','2024-08-22',1),
  (35,29,'Prescriber Form','Provider','2024-01-17','2024-02-03',1),
  (36,29,'Insurance Card','Patient','2024-01-17','2024-02-01',1),
  (37,29,'Prior Auth Letter','Provider','2024-01-17','2024-02-02',1),
  (38,30,'Insurance Card','Patient','2024-05-10','2024-05-16',1),
  (39,31,'Prior Auth Letter','Provider','2024-10-18',NULL,0),
  (40,35,'Prescriber Form','Provider','2024-11-11','2024-11-29',1),
  (41,35,'Income Documentation','Patient','2024-11-11','2024-11-28',1),
  (42,37,'Insurance Card','Patient','2024-04-30',NULL,0),
  (43,38,'Income Documentation','Patient','2024-04-03','2024-04-07',1),
  (44,40,'Insurance Card','Patient','2024-11-09',NULL,0),
  (45,42,'Prior Auth Letter','Provider','2024-11-19','2024-12-06',1),
  (46,42,'Income Documentation','Patient','2024-11-17','2024-12-03',1),
  (47,43,'Prescriber Form','Provider','2024-06-16',NULL,0),
  (48,43,'Income Documentation','Patient','2024-06-17','2024-07-05',1),
  (49,45,'Consent Form','Patient','2024-06-12','2024-06-24',1),
  (50,45,'Prior Auth Letter','Provider','2024-06-12','2024-06-30',1),
  (51,48,'Income Documentation','Patient','2024-08-02','2024-08-12',1),
  (52,49,'Prior Auth Letter','Provider','2024-10-20','2024-11-06',1),
  (53,51,'Prescriber Form','Provider','2024-12-13',NULL,0),
  (54,54,'Prescriber Form','Provider','2024-02-09','2024-02-21',1),
  (55,55,'Prescriber Form','Provider','2024-01-14','2024-01-21',1),
  (56,55,'Prior Auth Letter','Provider','2024-01-15',NULL,0),
  (57,55,'Income Documentation','Patient','2024-01-15','2024-01-27',1),
  (58,56,'Prior Auth Letter','Provider','2024-08-15','2024-08-28',1),
  (59,58,'Prior Auth Letter','Provider','2024-10-04','2024-10-11',1),
  (60,58,'Income Documentation','Patient','2024-10-02','2024-10-14',1),
  (61,59,'Consent Form','Patient','2024-09-11','2024-09-22',1),
  (62,60,'Prescriber Form','Provider','2024-01-18','2024-01-21',1),
  (63,64,'Prior Auth Letter','Provider','2024-11-28','2024-12-17',1),
  (64,68,'Income Documentation','Patient','2024-06-11','2024-07-01',1),
  (65,69,'Prior Auth Letter','Provider','2024-01-15','2024-02-01',1),
  (66,74,'Prior Auth Letter','Provider','2024-07-27','2024-08-04',1),
  (67,75,'Income Documentation','Patient','2024-02-12',NULL,0),
  (68,76,'Insurance Card','Patient','2024-11-20','2024-12-01',1),
  (69,78,'Prescriber Form','Provider','2024-08-25',NULL,0),
  (70,79,'Insurance Card','Patient','2024-08-14','2024-08-21',1),
  (71,79,'Income Documentation','Patient','2024-08-14',NULL,0),
  (72,80,'Consent Form','Patient','2024-12-08','2024-12-22',1),
  (73,80,'Income Documentation','Patient','2024-12-07',NULL,0),
  (74,81,'Prior Auth Letter','Provider','2024-04-22','2024-04-30',1),
  (75,82,'Prior Auth Letter','Provider','2024-04-04','2024-04-21',1),
  (76,82,'Income Documentation','Patient','2024-04-04','2024-04-19',1),
  (77,83,'Prescriber Form','Provider','2024-09-15','2024-10-04',1),
  (78,84,'Prescriber Form','Provider','2024-03-17',NULL,0),
  (79,84,'Insurance Card','Patient','2024-03-18','2024-03-25',1),
  (80,85,'Income Documentation','Patient','2024-12-28',NULL,0),
  (81,86,'Prescriber Form','Provider','2024-11-24','2024-11-29',1),
  (82,87,'Income Documentation','Patient','2024-09-26','2024-10-02',1),
  (83,88,'Income Documentation','Patient','2024-10-25',NULL,0),
  (84,89,'Prescriber Form','Provider','2024-04-14','2024-04-22',1),
  (85,89,'Income Documentation','Patient','2024-04-14','2024-04-28',1),
  (86,91,'Prior Auth Letter','Provider','2024-07-01','2024-07-18',1),
  (87,93,'Prior Auth Letter','Provider','2024-09-30','2024-10-18',1),
  (88,94,'Prescriber Form','Provider','2024-04-13','2024-04-21',1),
  (89,95,'Consent Form','Patient','2024-07-07','2024-07-26',1),
  (90,97,'Prescriber Form','Provider','2024-09-23','2024-10-01',1),
  (91,97,'Prior Auth Letter','Provider','2024-09-25','2024-10-02',1),
  (92,98,'Prescriber Form','Provider','2024-03-30','2024-04-19',1),
  (93,98,'Income Documentation','Patient','2024-03-30','2024-04-11',1);

-- ============================================================
--  ANALYTICAL QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- 1. Pipeline Overview — case counts by status
-- ------------------------------------------------------------
SELECT
    status,
    COUNT(*)                                                          AS total_cases,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 1)     AS pct_of_total
FROM patients
GROUP BY status
ORDER BY total_cases DESC;


-- ------------------------------------------------------------
-- 2. Document Completeness Rate — which doc is most often missing?
-- ------------------------------------------------------------
SELECT 'Consent Form'    AS document, ROUND(AVG(has_consent_form)    * 100, 1) AS pct_complete FROM patients
UNION ALL
SELECT 'Prescriber Form',             ROUND(AVG(has_rx_form)         * 100, 1)                FROM patients
UNION ALL
SELECT 'Insurance Card',              ROUND(AVG(has_insurance_card)  * 100, 1)                FROM patients
UNION ALL
SELECT 'Prior Auth Letter',           ROUND(AVG(has_pa_letter)       * 100, 1)                FROM patients
UNION ALL
SELECT 'Income Proof',                ROUND(AVG(has_income_proof)    * 100, 1)                FROM patients
ORDER BY pct_complete ASC;


-- ------------------------------------------------------------
-- 3. Average Delay by Missing Document — what slows cases most?
-- ------------------------------------------------------------
SELECT
    f.missing_document,
    COUNT(*)                     AS cases_affected,
    ROUND(AVG(p.delay_days), 1)  AS avg_delay_days,
    MAX(p.delay_days)            AS max_delay_days
FROM followup_log f
JOIN patients p ON f.patient_id = p.patient_id
GROUP BY f.missing_document
ORDER BY avg_delay_days DESC;


-- ------------------------------------------------------------
-- 4. Eligibility by FPL Bracket — approval rates by income level
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN fpl_pct <= 100  THEN '0-100% FPL'
        WHEN fpl_pct <= 200  THEN '101-200% FPL'
        WHEN fpl_pct <= 300  THEN '201-300% FPL'
        WHEN fpl_pct <= 400  THEN '301-400% FPL'
        ELSE 'Above 400% FPL'
    END                                                               AS fpl_bracket,
    COUNT(*)                                                          AS total_cases,
    SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END)             AS approved,
    ROUND(
        SUM(CASE WHEN status = 'Approved' THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 1
    )                                                                 AS approval_rate_pct
FROM patients
GROUP BY fpl_bracket
ORDER BY MIN(fpl_pct);


-- ------------------------------------------------------------
-- 5. Follow-Up Resolution Rate — are we closing the loop?
-- ------------------------------------------------------------
SELECT
    contact_type,
    missing_document,
    COUNT(*)                                                          AS followups_sent,
    SUM(resolved)                                                     AS resolved,
    ROUND(AVG(resolved) * 100, 1)                                     AS resolution_rate_pct,
    ROUND(AVG(
        CASE WHEN resolved = 1
        THEN DATEDIFF(resolved_date, followup_sent) END
    ), 1)                                                             AS avg_days_to_resolve
FROM followup_log
GROUP BY contact_type, missing_document
ORDER BY contact_type, resolution_rate_pct ASC;


-- ------------------------------------------------------------
-- 6. Active Work Queue — cases with outstanding follow-ups
-- ------------------------------------------------------------
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name)                           AS patient_name,
    p.prescriber,
    p.application_date,
    p.status,
    GROUP_CONCAT(f.missing_document ORDER BY f.missing_document SEPARATOR ', ')
                                                                      AS outstanding_docs,
    COUNT(f.followup_id)                                              AS open_followups,
    DATEDIFF(CURDATE(), p.application_date)                           AS days_in_pipeline
FROM patients p
JOIN followup_log f ON p.patient_id = f.patient_id
WHERE f.resolved = 0
GROUP BY p.patient_id, p.first_name, p.last_name,
         p.prescriber, p.application_date, p.status
ORDER BY days_in_pipeline DESC
LIMIT 20;


-- ------------------------------------------------------------
-- 7. Prescriber Performance — who submits complete packets?
-- ------------------------------------------------------------
SELECT
    prescriber,
    COUNT(*)                                                          AS total_patients,
    ROUND(AVG(docs_complete) * 100, 1)                               AS complete_submission_rate_pct,
    ROUND(AVG(delay_days), 1)                                         AS avg_delay_days,
    SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END)             AS approvals
FROM patients
GROUP BY prescriber
ORDER BY complete_submission_rate_pct DESC;


-- ------------------------------------------------------------
-- 8. Monthly Application Volume & Approval Trend
-- ------------------------------------------------------------
SELECT
    DATE_FORMAT(application_date, '%Y-%m')                            AS month,
    COUNT(*)                                                          AS applications,
    SUM(CASE WHEN status = 'Approved'  THEN 1 ELSE 0 END)            AS approved,
    SUM(CASE WHEN status = 'Denied'    THEN 1 ELSE 0 END)            AS denied,
    SUM(CASE WHEN status IN ('Pending','Incomplete') THEN 1 ELSE 0 END) AS in_progress
FROM patients
GROUP BY month
ORDER BY month;


-- ------------------------------------------------------------
-- 9. Insurer Breakdown — prior auth rates by payer
-- ------------------------------------------------------------
SELECT
    insurer,
    COUNT(*)                                                          AS total_cases,
    ROUND(AVG(has_pa_letter) * 100, 1)                               AS pa_submission_rate_pct,
    SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END)             AS approvals,
    ROUND(
        SUM(CASE WHEN status = 'Approved' THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 1
    )                                                                 AS approval_rate_pct
FROM patients
GROUP BY insurer
ORDER BY total_cases DESC;


-- ------------------------------------------------------------
-- 10. End-to-End Pipeline Duration — app to resolution
-- ------------------------------------------------------------
SELECT
    status,
    COUNT(*)                                                          AS cases,
    ROUND(AVG(DATEDIFF(resolution_date, application_date)), 1)       AS avg_days_to_resolution,
    MIN(DATEDIFF(resolution_date, application_date))                  AS fastest_days,
    MAX(DATEDIFF(resolution_date, application_date))                  AS slowest_days
FROM patients
WHERE resolution_date IS NOT NULL
GROUP BY status;

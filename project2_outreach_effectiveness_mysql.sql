-- ============================================================
--  Project 2: Provider Outreach & Follow-Up Effectiveness
--  Author: Tony Nguyen
--  Description: Analyzes follow-up contact effectiveness across
--  document types, contact methods, and case complexity to identify
--  what drives resolution speed in a patient assistance pipeline.
--
--  Key operational insight modeled:
--  - Patient docs (Consent, Income) resolve faster via direct patient contact
--  - Multi-missing cases with PA are escalated to providers
--  - Prior Auth has worst response rate; fax alone is slow, calls accelerate
--  - Second attempts are tracked to measure escalation effectiveness
-- ============================================================

USE foundation_pipeline;

-- ============================================================
--  SCHEMA — enriched follow-up log (v2)
-- ============================================================

DROP TABLE IF EXISTS followup_log_v2;

CREATE TABLE followup_log_v2 (
    followup_id        INT          PRIMARY KEY,
    patient_id         INT,
    missing_document   VARCHAR(50),
    contact_type       VARCHAR(20),   -- Patient or Provider
    contact_method     VARCHAR(20),   -- Fax, Call, Phone/Text
    attempt_number     INT,           -- 1 = initial, 2 = escalation
    followup_sent      DATE,
    resolved_date      DATE,
    resolved           TINYINT(1),
    days_to_resolve    INT,
    total_missing_docs INT,           -- complexity flag
    notes              VARCHAR(200),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- ============================================================
--  SEED DATA
-- ============================================================
INSERT INTO followup_log_v2 VALUES
  (1,1,'Prior Auth Letter','Provider','Fax',1,'2024-11-25',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (2,1,'Prior Auth Letter','Provider','Call',2,'2024-12-03','2024-12-17',1,14,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (3,2,'Prescriber Form','Provider','Call',1,'2024-08-04','2024-08-11',1,7,1,'Initial Call sent to Provider'),
  (4,3,'Prescriber Form','Provider','Call',1,'2024-01-26','2024-01-29',1,3,1,'Initial Call sent to Provider'),
  (5,4,'Prior Auth Letter','Provider','Fax',1,'2024-05-25',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (6,4,'Prior Auth Letter','Provider','Call',2,'2024-06-02',NULL,0,NULL,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (7,5,'Prescriber Form','Provider','Call',1,'2024-12-18',NULL,0,NULL,2,'Multi-doc case — Initial Call sent to Provider'),
  (8,5,'Prescriber Form','Provider','Call',2,'2024-12-25','2025-01-04',1,10,2,'2nd attempt Call to Provider'),
  (9,5,'Income Documentation','Patient','Phone/Text',1,'2024-12-19','2024-12-27',1,8,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (10,6,'Consent Form','Provider','Phone/Text',1,'2024-10-28','2024-11-03',1,6,3,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (11,6,'Prior Auth Letter','Provider','Fax',1,'2024-10-27','2024-11-12',1,16,3,'Multi-doc case — Initial Fax sent to Provider'),
  (12,6,'Income Documentation','Provider','Phone/Text',1,'2024-10-27','2024-11-08',1,12,3,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (13,7,'Prescriber Form','Provider','Call',1,'2024-02-28','2024-03-06',1,7,1,'Initial Call sent to Provider'),
  (14,8,'Prior Auth Letter','Provider','Fax',1,'2024-09-29',NULL,0,NULL,2,'Multi-doc case — Initial Fax sent to Provider'),
  (15,8,'Prior Auth Letter','Provider','Call',2,'2024-10-11',NULL,0,NULL,2,'Escalated to Call — 2nd attempt Call to Provider'),
  (16,8,'Income Documentation','Provider','Phone/Text',1,'2024-09-29','2024-10-07',1,8,2,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (17,9,'Income Documentation','Patient','Phone/Text',1,'2024-04-19','2024-04-25',1,6,1,'Initial Phone/Text sent to Patient'),
  (18,12,'Income Documentation','Patient','Phone/Text',1,'2024-05-10',NULL,0,NULL,1,'Initial Phone/Text sent to Patient'),
  (19,12,'Income Documentation','Patient','Phone/Text',2,'2024-05-17','2024-05-25',1,8,1,'2nd attempt Phone/Text to Patient'),
  (20,13,'Prescriber Form','Provider','Call',1,'2024-04-20','2024-04-26',1,6,2,'Multi-doc case — Initial Call sent to Provider'),
  (21,13,'Prior Auth Letter','Provider','Fax',1,'2024-04-20',NULL,0,NULL,2,'Multi-doc case — Initial Fax sent to Provider'),
  (22,13,'Prior Auth Letter','Provider','Call',2,'2024-04-27','2024-05-07',1,10,2,'Escalated to Call — 2nd attempt Call to Provider'),
  (23,14,'Consent Form','Patient','Phone/Text',1,'2024-01-28','2024-02-03',1,6,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (24,14,'Income Documentation','Patient','Phone/Text',1,'2024-01-28','2024-01-31',1,3,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (25,16,'Prescriber Form','Provider','Call',1,'2024-02-10','2024-02-20',1,10,3,'Multi-doc case — Initial Call sent to Provider'),
  (26,16,'Insurance Card','Patient','Phone/Text',1,'2024-02-10','2024-02-16',1,6,3,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (27,16,'Prior Auth Letter','Provider','Fax',1,'2024-02-09',NULL,0,NULL,3,'Multi-doc case — Initial Fax sent to Provider'),
  (28,16,'Prior Auth Letter','Provider','Call',2,'2024-02-14','2024-02-29',1,15,3,'Escalated to Call — 2nd attempt Call to Provider'),
  (29,17,'Insurance Card','Provider','Phone/Text',1,'2024-04-17',NULL,0,NULL,1,'Initial Phone/Text sent to Provider'),
  (30,17,'Insurance Card','Provider','Phone/Text',2,'2024-04-23','2024-05-03',1,10,1,'2nd attempt Phone/Text to Provider'),
  (31,18,'Prescriber Form','Provider','Call',1,'2024-01-06',NULL,0,NULL,1,'Initial Call sent to Provider'),
  (32,18,'Prescriber Form','Provider','Call',2,'2024-01-13',NULL,0,NULL,1,'2nd attempt Call to Provider'),
  (33,19,'Consent Form','Provider','Phone/Text',1,'2024-11-15','2024-11-23',1,8,3,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (34,19,'Prescriber Form','Provider','Call',1,'2024-11-15','2024-11-26',1,11,3,'Multi-doc case — Initial Call sent to Provider'),
  (35,19,'Prior Auth Letter','Provider','Fax',1,'2024-11-14',NULL,0,NULL,3,'Multi-doc case — Initial Fax sent to Provider'),
  (36,19,'Prior Auth Letter','Provider','Call',2,'2024-11-23','2024-12-05',1,12,3,'Escalated to Call — 2nd attempt Call to Provider'),
  (37,20,'Consent Form','Patient','Phone/Text',1,'2024-04-10','2024-04-15',1,5,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (38,20,'Prescriber Form','Provider','Call',1,'2024-04-10',NULL,0,NULL,2,'Multi-doc case — Initial Call sent to Provider'),
  (39,20,'Prescriber Form','Provider','Call',2,'2024-04-21','2024-05-04',1,13,2,'2nd attempt Call to Provider'),
  (40,21,'Consent Form','Patient','Phone/Text',1,'2024-11-09','2024-11-11',1,2,1,'Initial Phone/Text sent to Patient'),
  (41,25,'Prior Auth Letter','Provider','Fax',1,'2024-09-12',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (42,25,'Prior Auth Letter','Provider','Call',2,'2024-09-24','2024-10-13',1,19,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (43,26,'Prescriber Form','Provider','Call',1,'2024-08-28','2024-08-31',1,3,2,'Multi-doc case — Initial Call sent to Provider'),
  (44,26,'Insurance Card','Provider','Phone/Text',1,'2024-08-28','2024-08-30',1,2,2,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (45,27,'Insurance Card','Provider','Phone/Text',1,'2024-08-16','2024-08-18',1,2,1,'Initial Phone/Text sent to Provider'),
  (46,28,'Consent Form','Patient','Phone/Text',1,'2024-08-05','2024-08-07',1,2,1,'Initial Phone/Text sent to Patient'),
  (47,29,'Prescriber Form','Provider','Call',1,'2024-01-17','2024-01-27',1,10,3,'Multi-doc case — Initial Call sent to Provider'),
  (48,29,'Insurance Card','Patient','Phone/Text',1,'2024-01-16','2024-01-25',1,9,3,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (49,29,'Prior Auth Letter','Provider','Fax',1,'2024-01-17',NULL,0,NULL,3,'Multi-doc case — Initial Fax sent to Provider'),
  (50,29,'Prior Auth Letter','Provider','Call',2,'2024-01-28',NULL,0,NULL,3,'Escalated to Call — 2nd attempt Call to Provider'),
  (51,30,'Insurance Card','Provider','Phone/Text',1,'2024-05-12','2024-05-14',1,2,1,'Initial Phone/Text sent to Provider'),
  (52,31,'Prior Auth Letter','Provider','Fax',1,'2024-10-17','2024-11-12',1,26,1,'Initial Fax sent to Provider'),
  (53,35,'Prescriber Form','Provider','Call',1,'2024-11-09','2024-11-13',1,4,2,'Multi-doc case — Initial Call sent to Provider'),
  (54,35,'Income Documentation','Patient','Phone/Text',1,'2024-11-10','2024-11-15',1,5,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (55,37,'Insurance Card','Provider','Phone/Text',1,'2024-05-01','2024-05-03',1,2,1,'Initial Phone/Text sent to Provider'),
  (56,38,'Income Documentation','Patient','Phone/Text',1,'2024-04-04','2024-04-12',1,8,1,'Initial Phone/Text sent to Patient'),
  (57,40,'Insurance Card','Provider','Phone/Text',1,'2024-11-08','2024-11-10',1,2,1,'Initial Phone/Text sent to Provider'),
  (58,42,'Prior Auth Letter','Provider','Fax',1,'2024-11-18',NULL,0,NULL,2,'Multi-doc case — Initial Fax sent to Provider'),
  (59,42,'Prior Auth Letter','Provider','Call',2,'2024-11-29','2024-12-27',1,28,2,'Escalated to Call — 2nd attempt Call to Provider'),
  (60,42,'Income Documentation','Provider','Phone/Text',1,'2024-11-19','2024-11-26',1,7,2,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (61,43,'Prescriber Form','Provider','Call',1,'2024-06-16',NULL,0,NULL,2,'Multi-doc case — Initial Call sent to Provider'),
  (62,43,'Prescriber Form','Provider','Call',2,'2024-06-23','2024-07-08',1,15,2,'2nd attempt Call to Provider'),
  (63,43,'Income Documentation','Patient','Phone/Text',1,'2024-06-15','2024-06-23',1,8,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (64,45,'Consent Form','Provider','Phone/Text',1,'2024-06-12','2024-06-18',1,6,2,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (65,45,'Prior Auth Letter','Provider','Fax',1,'2024-06-13',NULL,0,NULL,2,'Multi-doc case — Initial Fax sent to Provider'),
  (66,45,'Prior Auth Letter','Provider','Call',2,'2024-06-21',NULL,0,NULL,2,'Escalated to Call — 2nd attempt Call to Provider'),
  (67,48,'Income Documentation','Patient','Phone/Text',1,'2024-08-02','2024-08-05',1,3,1,'Initial Phone/Text sent to Patient'),
  (68,49,'Prior Auth Letter','Provider','Fax',1,'2024-10-20',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (69,49,'Prior Auth Letter','Provider','Call',2,'2024-10-29','2024-11-13',1,15,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (70,51,'Prescriber Form','Provider','Call',1,'2024-12-13','2024-12-17',1,4,1,'Initial Call sent to Provider'),
  (71,54,'Prescriber Form','Provider','Call',1,'2024-02-09','2024-02-13',1,4,1,'Initial Call sent to Provider'),
  (72,55,'Prescriber Form','Provider','Call',1,'2024-01-13',NULL,0,NULL,3,'Multi-doc case — Initial Call sent to Provider'),
  (73,55,'Prescriber Form','Provider','Call',2,'2024-01-24','2024-02-15',1,22,3,'2nd attempt Call to Provider'),
  (74,55,'Prior Auth Letter','Provider','Fax',1,'2024-01-13','2024-01-30',1,17,3,'Multi-doc case — Initial Fax sent to Provider'),
  (75,55,'Income Documentation','Provider','Phone/Text',1,'2024-01-14','2024-01-26',1,12,3,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (76,56,'Prior Auth Letter','Provider','Fax',1,'2024-08-14',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (77,56,'Prior Auth Letter','Provider','Call',2,'2024-08-26',NULL,0,NULL,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (78,58,'Prior Auth Letter','Provider','Fax',1,'2024-10-04','2024-10-30',1,26,2,'Multi-doc case — Initial Fax sent to Provider'),
  (79,58,'Income Documentation','Provider','Phone/Text',1,'2024-10-04','2024-10-09',1,5,2,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (80,59,'Consent Form','Patient','Phone/Text',1,'2024-09-11','2024-09-13',1,2,1,'Initial Phone/Text sent to Patient'),
  (81,60,'Prescriber Form','Provider','Call',1,'2024-01-20','2024-01-25',1,5,1,'Initial Call sent to Provider'),
  (82,64,'Prior Auth Letter','Provider','Fax',1,'2024-11-28','2024-12-20',1,22,1,'Initial Fax sent to Provider'),
  (83,68,'Income Documentation','Patient','Phone/Text',1,'2024-06-10','2024-06-14',1,4,1,'Initial Phone/Text sent to Patient'),
  (84,69,'Prior Auth Letter','Provider','Fax',1,'2024-01-17',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (85,69,'Prior Auth Letter','Provider','Call',2,'2024-01-22','2024-02-19',1,28,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (86,74,'Prior Auth Letter','Provider','Fax',1,'2024-07-27',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (87,74,'Prior Auth Letter','Provider','Call',2,'2024-08-03',NULL,0,NULL,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (88,75,'Income Documentation','Patient','Phone/Text',1,'2024-02-12','2024-02-16',1,4,1,'Initial Phone/Text sent to Patient'),
  (89,76,'Insurance Card','Provider','Phone/Text',1,'2024-11-18','2024-11-20',1,2,1,'Initial Phone/Text sent to Provider'),
  (90,78,'Prescriber Form','Provider','Call',1,'2024-08-26','2024-08-31',1,5,1,'Initial Call sent to Provider'),
  (91,79,'Insurance Card','Provider','Phone/Text',1,'2024-08-13','2024-08-15',1,2,2,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (92,79,'Income Documentation','Patient','Phone/Text',1,'2024-08-15','2024-08-20',1,5,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (93,80,'Consent Form','Patient','Phone/Text',1,'2024-12-08',NULL,0,NULL,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (94,80,'Consent Form','Patient','Phone/Text',2,'2024-12-14',NULL,0,NULL,2,'2nd attempt Phone/Text to Patient'),
  (95,80,'Income Documentation','Patient','Phone/Text',1,'2024-12-08','2024-12-12',1,4,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (96,81,'Prior Auth Letter','Provider','Fax',1,'2024-04-20',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (97,81,'Prior Auth Letter','Provider','Call',2,'2024-05-01','2024-05-20',1,19,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (98,82,'Prior Auth Letter','Provider','Fax',1,'2024-04-05',NULL,0,NULL,2,'Multi-doc case — Initial Fax sent to Provider'),
  (99,82,'Prior Auth Letter','Provider','Call',2,'2024-04-15',NULL,0,NULL,2,'Escalated to Call — 2nd attempt Call to Provider'),
  (100,82,'Income Documentation','Provider','Phone/Text',1,'2024-04-05','2024-04-10',1,5,2,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (101,83,'Prescriber Form','Provider','Call',1,'2024-09-15','2024-09-19',1,4,1,'Initial Call sent to Provider'),
  (102,84,'Prescriber Form','Provider','Call',1,'2024-03-18','2024-03-25',1,7,2,'Multi-doc case — Initial Call sent to Provider'),
  (103,84,'Insurance Card','Provider','Phone/Text',1,'2024-03-19',NULL,0,NULL,2,'Multi-doc case — Initial Phone/Text sent to Provider'),
  (104,84,'Insurance Card','Provider','Phone/Text',2,'2024-03-30',NULL,0,NULL,2,'2nd attempt Phone/Text to Provider'),
  (105,85,'Income Documentation','Patient','Phone/Text',1,'2024-12-28','2025-01-05',1,8,1,'Initial Phone/Text sent to Patient'),
  (106,86,'Prescriber Form','Provider','Call',1,'2024-11-26',NULL,0,NULL,1,'Initial Call sent to Provider'),
  (107,86,'Prescriber Form','Provider','Call',2,'2024-12-03',NULL,0,NULL,1,'2nd attempt Call to Provider'),
  (108,87,'Income Documentation','Patient','Phone/Text',1,'2024-09-27','2024-10-02',1,5,1,'Initial Phone/Text sent to Patient'),
  (109,88,'Income Documentation','Patient','Phone/Text',1,'2024-10-27','2024-11-02',1,6,1,'Initial Phone/Text sent to Patient'),
  (110,89,'Prescriber Form','Provider','Call',1,'2024-04-13','2024-04-17',1,4,2,'Multi-doc case — Initial Call sent to Provider'),
  (111,89,'Income Documentation','Patient','Phone/Text',1,'2024-04-13',NULL,0,NULL,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (112,89,'Income Documentation','Patient','Phone/Text',2,'2024-04-22','2024-05-07',1,15,2,'2nd attempt Phone/Text to Patient'),
  (113,91,'Prior Auth Letter','Provider','Fax',1,'2024-06-30',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (114,91,'Prior Auth Letter','Provider','Call',2,'2024-07-10','2024-08-01',1,22,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (115,93,'Prior Auth Letter','Provider','Fax',1,'2024-09-30',NULL,0,NULL,1,'Initial Fax sent to Provider'),
  (116,93,'Prior Auth Letter','Provider','Call',2,'2024-10-11',NULL,0,NULL,1,'Escalated to Call — 2nd attempt Call to Provider'),
  (117,94,'Prescriber Form','Provider','Call',1,'2024-04-15','2024-04-23',1,8,1,'Initial Call sent to Provider'),
  (118,95,'Consent Form','Patient','Phone/Text',1,'2024-07-05','2024-07-09',1,4,1,'Initial Phone/Text sent to Patient'),
  (119,97,'Prescriber Form','Provider','Call',1,'2024-09-25','2024-10-02',1,7,2,'Multi-doc case — Initial Call sent to Provider'),
  (120,97,'Prior Auth Letter','Provider','Fax',1,'2024-09-25',NULL,0,NULL,2,'Multi-doc case — Initial Fax sent to Provider'),
  (121,97,'Prior Auth Letter','Provider','Call',2,'2024-10-02',NULL,0,NULL,2,'Escalated to Call — 2nd attempt Call to Provider'),
  (122,98,'Prescriber Form','Provider','Call',1,'2024-03-29','2024-04-03',1,5,2,'Multi-doc case — Initial Call sent to Provider'),
  (123,98,'Income Documentation','Patient','Phone/Text',1,'2024-03-29',NULL,0,NULL,2,'Multi-doc case — Initial Phone/Text sent to Patient'),
  (124,98,'Income Documentation','Patient','Phone/Text',2,'2024-04-09','2024-04-17',1,8,2,'2nd attempt Phone/Text to Patient');

-- ============================================================
--  ANALYTICAL QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- 1. Resolution Rate by Document Type
--    Core question: which document is hardest to collect?
-- ------------------------------------------------------------
SELECT
    missing_document,
    COUNT(*)                                              AS total_attempts,
    SUM(resolved)                                         AS resolved,
    SUM(1 - resolved)                                     AS unresolved,
    ROUND(AVG(resolved) * 100, 1)                         AS resolution_rate_pct,
    ROUND(AVG(CASE WHEN resolved = 1
        THEN days_to_resolve END), 1)                     AS avg_days_when_resolved
FROM followup_log_v2
WHERE attempt_number = 1
GROUP BY missing_document
ORDER BY resolution_rate_pct ASC;


-- ------------------------------------------------------------
-- 2. Contact Method Effectiveness — Fax vs Call vs Phone/Text
--    Key insight: does calling actually move things faster?
-- ------------------------------------------------------------
SELECT
    contact_method,
    COUNT(*)                                              AS total_attempts,
    ROUND(AVG(resolved) * 100, 1)                         AS resolution_rate_pct,
    ROUND(AVG(CASE WHEN resolved = 1
        THEN days_to_resolve END), 1)                     AS avg_days_to_resolve,
    MIN(CASE WHEN resolved = 1 THEN days_to_resolve END)  AS fastest_resolution,
    MAX(CASE WHEN resolved = 1 THEN days_to_resolve END)  AS slowest_resolution
FROM followup_log_v2
GROUP BY contact_method
ORDER BY resolution_rate_pct DESC;


-- ------------------------------------------------------------
-- 3. Prior Auth Deep Dive — Fax vs Call for PA specifically
--    Validates: calling on PA is significantly more effective than fax
-- ------------------------------------------------------------
SELECT
    contact_method,
    attempt_number,
    COUNT(*)                                              AS attempts,
    ROUND(AVG(resolved) * 100, 1)                         AS resolution_rate_pct,
    ROUND(AVG(CASE WHEN resolved = 1
        THEN days_to_resolve END), 1)                     AS avg_days_to_resolve
FROM followup_log_v2
WHERE missing_document = 'Prior Auth Letter'
GROUP BY contact_method, attempt_number
ORDER BY attempt_number, resolution_rate_pct DESC;


-- ------------------------------------------------------------
-- 4. Escalation Effectiveness — did attempt 2 recover stalled cases?
--    Compares attempt 1 vs attempt 2 resolution rates by document
-- ------------------------------------------------------------
SELECT
    missing_document,
    attempt_number,
    COUNT(*)                                              AS attempts,
    ROUND(AVG(resolved) * 100, 1)                         AS resolution_rate_pct,
    ROUND(AVG(CASE WHEN resolved = 1
        THEN days_to_resolve END), 1)                     AS avg_days_to_resolve
FROM followup_log_v2
GROUP BY missing_document, attempt_number
ORDER BY missing_document, attempt_number;


-- ------------------------------------------------------------
-- 5. Case Complexity Impact — do multi-missing cases take longer?
--    Segments by number of missing docs (simple vs complex cases)
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN total_missing_docs = 1 THEN '1 doc missing'
        WHEN total_missing_docs = 2 THEN '2 docs missing'
        ELSE '3+ docs missing'
    END                                                   AS case_complexity,
    COUNT(DISTINCT patient_id)                            AS patients,
    COUNT(*)                                              AS total_followups,
    ROUND(AVG(resolved) * 100, 1)                         AS resolution_rate_pct,
    ROUND(AVG(CASE WHEN resolved = 1
        THEN days_to_resolve END), 1)                     AS avg_days_to_resolve
FROM followup_log_v2
GROUP BY case_complexity
ORDER BY MIN(total_missing_docs);


-- ------------------------------------------------------------
-- 6. Patient vs Provider Contact — who responds faster?
--    Overall comparison of patient-side vs provider-side outreach
-- ------------------------------------------------------------
SELECT
    contact_type,
    missing_document,
    COUNT(*)                                              AS attempts,
    ROUND(AVG(resolved) * 100, 1)                         AS resolution_rate_pct,
    ROUND(AVG(CASE WHEN resolved = 1
        THEN days_to_resolve END), 1)                     AS avg_days_to_resolve
FROM followup_log_v2
WHERE attempt_number = 1
GROUP BY contact_type, missing_document
ORDER BY contact_type, resolution_rate_pct DESC;


-- ------------------------------------------------------------
-- 7. Unresolved Cases After 2 Attempts — highest priority work queue
--    These are the cases most at risk of falling through
-- ------------------------------------------------------------
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name)               AS patient_name,
    p.prescriber,
    p.application_date,
    p.status,
    GROUP_CONCAT(
        DISTINCT f.missing_document
        ORDER BY f.missing_document SEPARATOR ', '
    )                                                     AS still_missing,
    COUNT(DISTINCT f.missing_document)                    AS docs_outstanding,
    DATEDIFF(CURDATE(), p.application_date)               AS days_in_pipeline
FROM patients p
JOIN followup_log_v2 f ON p.patient_id = f.patient_id
WHERE f.resolved = 0
GROUP BY p.patient_id, p.first_name, p.last_name,
         p.prescriber, p.application_date, p.status
HAVING COUNT(DISTINCT f.followup_id) >= 2
ORDER BY days_in_pipeline DESC
LIMIT 15;


-- ------------------------------------------------------------
-- 8. Monthly Follow-Up Volume & Resolution Trend
--    Are we getting better at resolving cases over time?
-- ------------------------------------------------------------
SELECT
    DATE_FORMAT(followup_sent, '%Y-%m')                   AS month,
    COUNT(*)                                              AS followups_sent,
    SUM(resolved)                                         AS resolved,
    ROUND(AVG(resolved) * 100, 1)                         AS resolution_rate_pct,
    ROUND(AVG(CASE WHEN resolved = 1
        THEN days_to_resolve END), 1)                     AS avg_days_to_resolve
FROM followup_log_v2
GROUP BY month
ORDER BY month;


-- ------------------------------------------------------------
-- 9. Optimal Contact Strategy Summary (CTE)
--    Uses a CTE to rank contact methods per document type
--    by resolution rate — the recommended playbook
-- ------------------------------------------------------------
WITH method_performance AS (
    SELECT
        missing_document,
        contact_method,
        COUNT(*)                            AS attempts,
        ROUND(AVG(resolved) * 100, 1)       AS resolution_rate_pct,
        ROUND(AVG(CASE WHEN resolved = 1
            THEN days_to_resolve END), 1)   AS avg_days
    FROM followup_log_v2
    GROUP BY missing_document, contact_method
),
ranked AS (
    SELECT *,
        RANK() OVER (
            PARTITION BY missing_document
            ORDER BY resolution_rate_pct DESC
        ) AS method_rank
    FROM method_performance
)
SELECT
    missing_document,
    contact_method                          AS best_method,
    resolution_rate_pct,
    avg_days,
    attempts
FROM ranked
WHERE method_rank = 1
ORDER BY resolution_rate_pct DESC;


-- ------------------------------------------------------------
-- 10. Full Follow-Up Journey — start to resolution per patient
--     Shows the complete outreach timeline for each case
-- ------------------------------------------------------------
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name)               AS patient_name,
    f.missing_document,
    f.attempt_number,
    f.contact_type,
    f.contact_method,
    f.followup_sent,
    f.resolved_date,
    f.resolved,
    f.days_to_resolve,
    f.notes
FROM patients p
JOIN followup_log_v2 f ON p.patient_id = f.patient_id
ORDER BY p.patient_id, f.missing_document, f.attempt_number;

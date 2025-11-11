/*
 This script analyzes community health indicators in Kericho County. 
 The analysis supports the County Government, the National Government, and development partners 
 in making data-driven decisions to promote equitable health services in line with the Universal Health Coverage (UHC) agenda.
 Note: The dataset used is synthetic and was generated using Python’s Faker library for demonstration purposes.
*/

/* ===========================================================================
	A. BASIC DATA EXPLORATION
=============================================================================== */ 
-- i. Geographic distribution of households

-- a. Count of households by sub-county
SELECT sub_county, COUNT(*) AS total_household_counts
FROM kericho_community_health_data
GROUP BY sub_county
ORDER BY total_household_counts DESC;

-- b. Count of households by sub_county and ward
SELECT sub_county, ward, COUNT(*) AS total_household_counts
FROM kericho_community_health_data
GROUP BY sub_county, ward
ORDER BY sub_county ASC;

-- 2. Summary Statistics
-- a. County level
SELECT
	'kericho county' AS county,
    AVG(household_size) AS avg_household_size,
    MIN(household_size) AS min_household_size,
    MAX(household_size) AS max_household_size,
    AVG(children_under5) AS avg_children_under_5,
    MIN(children_under5) AS min_children_under_5,
    MAX(children_under5) AS max_children_under_5,
    AVG(women_reproductive_age) AS avg_women_reproductive_age,
    MIN(women_reproductive_age) AS min_women_reproductive_age,
    MAX(women_reproductive_age) AS max_women_reproductive_age
FROM kericho_community_health_data;

-- b. By sub-county
SELECT
	sub_county AS county,
    AVG(household_size) AS avg_household_size,
    MIN(household_size) AS min_household_size,
    MAX(household_size) AS max_household_size,
    AVG(children_under5) AS avg_children_under_5,
    MIN(children_under5) AS min_children_under_5,
    MAX(children_under5) AS max_children_under_5,
    AVG(women_reproductive_age) AS avg_women_reproductive_age,
    MIN(women_reproductive_age) AS min_women_reproductive_age,
    MAX(women_reproductive_age) AS max_women_reproductive_age
FROM kericho_community_health_data
GROUP BY sub_county;


-- iii. Resource distribution
-- a. Water source types

-- -Overall
SELECT water_source,  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM kericho_community_health_data),2) AS percentage
FROM kericho_community_health_data
GROUP BY water_source;


-- -By sub_county
SELECT
    sub_county,
    water_source,
    ROUND(100.0 * count / total, 2) AS percentage
FROM (
    SELECT
        sub_county,
        water_source,
        COUNT(*) AS count,
        SUM(COUNT(*)) OVER (PARTITION BY sub_county) AS total
    FROM kericho_community_health_data
    GROUP BY sub_county, water_source
) AS subquery
ORDER BY sub_county, percentage DESC;

-- b. Toilet type
-- -Overall
SELECT toilet_type, ROUND(100.0 * COUNT(*)/(SELECT COUNT(*) FROM kericho_community_health_data),2) AS percentage
FROM kericho_community_health_data
GROUP BY toilet_type;

-- By sub_county
SELECT
    sub_county,
    toilet_type,
    ROUND(100.0 * count / total, 2) AS percentage
FROM (
    SELECT
        sub_county,
        toilet_type,
        COUNT(*) AS count,
        SUM(COUNT(*)) OVER (PARTITION BY sub_county) AS total
    FROM kericho_community_health_data
    GROUP BY sub_county, toilet_type
) AS subquery
ORDER BY sub_county, percentage DESC;


-- c. Handwashing facilities
-- Overall
SELECT handwashing_facility, ROUND(100.0 * COUNT(*)/(SELECT COUNT(*) FROM kericho_community_health_data),2) AS percentage
FROM kericho_community_health_data
GROUP BY handwashing_facility;

-- By sub_county
SELECT
    sub_county,
    handwashing_facility,
    ROUND(100.0 * count / total, 2) AS percentage
FROM (
    SELECT
        sub_county,
        handwashing_facility,
        COUNT(*) AS count,
        SUM(COUNT(*)) OVER (PARTITION BY sub_county) AS total
    FROM kericho_community_health_data
    GROUP BY sub_county, handwashing_facility
) AS subquery
ORDER BY sub_county, percentage DESC;

-- d. Distrubiton of safe and unsafe water by county and sub_county
-- Overall
SELECT
    CASE
        WHEN water_source IN ('piped', 'protected well') THEN 'Safe Water'
        ELSE 'Unsafe Water'
    END AS water_safety,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM kericho_community_health_data), 2) AS percentage
FROM kericho_community_health_data
GROUP BY water_safety
ORDER BY water_safety DESC;


-- By sub-county
SELECT
    sub_county,
    CASE
        WHEN water_source IN ('piped', 'protected well') THEN 'Safe Water'
        ELSE 'Unsafe Water'
    END AS water_safety,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM kericho_community_health_data WHERE sub_county = t.sub_county), 2) AS percentage
FROM kericho_community_health_data t
GROUP BY sub_county, water_safety
ORDER BY sub_county, water_safety DESC;


/* ================================================================================
	B. HEALTH SERVICE UTILIZATION
================================================================================== */

-- i. Distribution of pregnant women attending ANC visits

-- a. Overall
SELECT
    ROUND(100.0 * SUM(CASE WHEN anc_visits >= 1 THEN 1 ELSE 0 END) / 
    (SELECT SUM(pregnant_women) FROM kericho_community_health_data WHERE 1 > 0), 2) AS percentage_ANC_visits
FROM kericho_community_health_data
WHERE pregnant_women > 0;


-- ii. By sub_county
SELECT
    sub_county,
    ROUND(100.0 * SUM(CASE WHEN anc_visits >= 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentage_ANC_visits
FROM kericho_community_health_data
WHERE pregnant_women > 0
GROUP BY sub_county
ORDER BY sub_county;


-- ii. Distribution of skilled deliveries 
-- a. Overall
SELECT
    ROUND(100.0 * SUM(CASE WHEN skilled_delivery = 'Yes' THEN 1 ELSE 0 END) / 
    (SELECT COUNT(*) FROM kericho_community_health_data), 2) AS skilled_delivery_percentage
FROM kericho_community_health_data;

-- b. By sub_county
SELECT
	sub_county,
    ROUND(100.0 * SUM(CASE WHEN skilled_delivery = 'Yes' THEN 1 ELSE 0 END) / 
    COUNT(*), 2) AS skilled_delivery_percentage
FROM kericho_community_health_data
GROUP BY sub_county
ORDER BY sub_county;

-- iii. Distribution of postnatal visits
-- Overall
SELECT 
	ROUND(100.0 * SUM(CASE WHEN postnatal_visit >= 1 THEN 1 ELSE 0 END) / 
    (SELECT COUNT(*) FROM kericho_community_health_data),2) AS postnatal_visit_percentage
FROM kericho_community_health_data;

-- By sub_county
SELECT 
	sub_county,
	ROUND(100.0 * SUM(CASE WHEN postnatal_visit >= 1 THEN 1 ELSE 0 END) / COUNT(*),2) AS postnatal_visit_percentage
FROM kericho_community_health_data
GROUP BY sub_county
ORDER BY sub_county;

-- iv. Average immunization coverage rates 
-- Overall
SELECT 
	ROUND(AVG(immunization_coverage),2) AS avg_immunization_coverage
FROM kericho_community_health_data;

-- By sub_county
SELECT
	sub_county,
	ROUND(AVG(immunization_coverage),2) AS avg_immunization_coverage
FROM kericho_community_health_data
GROUP BY sub_county
ORDER BY sub_county;

-- v. Counts and rates of community health activities
SELECT
    sub_county,
    SUM(health_education_sessions) AS total_health_education_sessions,
    SUM(community_cleanups) AS total_community_cleanup_days,
    SUM(household_visits) AS total_household_visits,
    ROUND(AVG(health_education_sessions), 2) AS avg_health_education_sessions,
    ROUND(AVG(community_cleanups), 2) AS avg_community_cleanup_days,
    ROUND(AVG(household_visits), 2) AS avg_household_visits
FROM kericho_community_health_data
GROUP BY sub_county
ORDER BY sub_county;

/* ===================================================================================
	C. DISEASE INCIDENCE AND SCREENING
================================================================================== */
-- a. Malnution incidences 
-- Overall
SELECT
    SUM(malnutrition_cases) AS total_cases,
    SUM(children_under5) AS total_children_assessed,
    ROUND(((SUM(malnutrition_cases) / SUM(children_under5)) * 100), 2) AS malnutrition_rate_percent
FROM kericho_community_health_data;

-- By sub_county 
SELECT
	sub_county,
    SUM(malnutrition_cases) AS total_cases,
    SUM(children_under5) AS at_risk_population,
    ROUND(((SUM(malnutrition_cases) / SUM(children_under5)) * 100),2) AS malnutrition_rate_percent
FROM kericho_community_health_data
GROUP BY sub_county
ORDER BY sub_county;


-- b. Malaria incidences
-- Overall
SELECT
    (SUM(malaria_cases) / SUM(household_size)) * 1000 AS incidence_per_1000
FROM kericho_community_health_data;

-- By subcounty
SELECT
	sub_county,
    ROUND((SUM(malaria_cases) / SUM(household_size) * 1000),2) AS incidence_per_1000
FROM kericho_community_health_data
GROUP BY sub_county
ORDER BY sub_county;

-- c. TB screening rate
-- Overall
SELECT
    ROUND((SUM(tb_screened) / SUM(household_size)) * 100,2) AS screening_rate_percent
FROM kericho_community_health_data;

-- c. TB incidence rate 
-- By subcounty
SELECT
    ROUND((SUM(tb_suspected) / SUM(household_size) * 100000),2) AS incidence_per_100000
FROM kericho_community_health_data;


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

-- -By county
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
-- -By conty
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
-- By county
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
-- By county
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










-- 1. HOUSEHOLD DEMOGRAPHICS
-- Goal: Understand household composition and population distribution

-- i. Average household size by sub-county
SELECT sub_county, AVG(household_size) AS avg_household_size
FROM kericho_community_health_data
GROUP BY sub_county
ORDER BY avg_household_size DESC;

/* 
	Insight: 
		Londiani has the largest households and Bureti the smallest.
		This analysis can inform resource allocation decisions for community health programs. 
*/ 

-- ----------------------------------------------------------------------------------------- --
-- Drill-down
-- ii. Average household size by sub-county and ward 
SELECT sub_county, ward, AVG(household_size) AS avg_household_size
FROM kericho_community_health_data
GROUP BY sub_county, ward
ORDER BY sub_county, avg_household_size DESC;
/* 
	Insight: 
		Reveals wards with the largest and smallest household sizes, highlighting local demographic differences within sub-counties.​
        Identifies specific wards that may need more resources or targeted interventions based on higher household size.
        Helps design more precise community health and service delivery strategies for each ward.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------- --

-- iii. Average 
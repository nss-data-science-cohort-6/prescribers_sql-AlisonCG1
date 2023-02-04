--a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

--SELECT npi, SUM(total_claim_count) AS total
--FROM prescription
--GROUP BY npi
--ORDER BY total DESC
--LIMIT 1; 

-- the highest total number of claims is 99707

--b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.

--SELECT npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, SUM(total_claim_count) AS claims_provider
--FROM prescriber 
--FULL JOIN prescription 
--USING (npi)
--GROUP BY npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description
--ORDER BY claims_provider DESC; 

--2. a. Which specialty had the most total number of claims (totaled over all drugs)?

--SELECT specialty_description, SUM(total_claim_count) AS total_specialty
--FROM prescriber 
--FULL JOIN prescription 
--USING (npi)
--GROUP BY specialty_description
--ORDER BY total_specialty; 

--b. Which specialty had the most total number of claims for opioids?

--SELECT specialty_description, SUM(total_claim_count) as total_claim
--FROM prescription 
--LEFT JOIN prescriber 
--USING(npi)
--LEFT JOIN drug 
--USING(drug_name)
--WHERE opioid_drug_flag = 'Y'
--GROUP BY specialty_description
--ORDER BY total_claim DESC
--LIMIT 10;


--c. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
--SELECT specialty_description, SUM(total_claim_count) AS total_specialty
--FROM prescriber 
--FULL JOIN prescription 
--USING (npi)
--WHERE total_claim_count IS NULL
--GROUP BY specialty_description
--ORDER BY total_specialty; 

--d. Difficult Bonus: Do not attempt until you have solved all other problems! For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?
-- I need two numbers: Total opioids by specialty and Total claims by specialty 
-- Divide first number with the second. * 100

--SELECT specialty_description, SUM(total_claim_count) AS total_opioid_claim
--FROM prescription 
--LEFT JOIN prescriber 
--USING(npi)
--LEFT JOIN drug 
--USING(drug_name)
--WHERE opioid_drug_flag = 'Y'
--GROUP BY specialty_description
--ORDER BY total_claim DESC
--LIMIT 10;
--INTERSECT 
--SELECT specialty_description, SUM(total_claim_count) AS total_specialty
--FROM prescription 
--LEFT JOIN prescriber 
--USING(npi)
--LEFT JOIN drug 
--USING(drug_name)
--GROUP BY specialty_description

SELECT t1.specialty_description, t1.total_opioid_claim, t2.total_specialty, ROUND(t1.total_opioid_claim * 100.0 / t2.total_specialty, 1) AS Percent
FROM 
    (SELECT specialty_description, SUM(total_claim_count) AS total_opioid_claim
FROM prescription 
LEFT JOIN prescriber 
USING(npi)
LEFT JOIN drug 
USING(drug_name)
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description) AS t1
LEFT JOIN
    (SELECT specialty_description, SUM(total_claim_count) AS total_specialty
FROM prescription 
LEFT JOIN prescriber 
USING(npi)
LEFT JOIN drug 
USING(drug_name)
GROUP BY specialty_description) AS t2
ON (t1.specialty_description = t2.specialty_description);

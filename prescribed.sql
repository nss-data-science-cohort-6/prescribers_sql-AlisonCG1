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

SELECT opioid_drug_flag AS opioids, specialty_description AS specialty
FROM prescriber
INNER JOIN  drug
ON
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description 

--ORDER BY total_specialty; 
--a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

--SELECT npi, SUM(total_claim_count) AS total
--FROM prescription
--GROUP BY npi
--ORDER BY total DESC
--LIMIT 1; 

-- the highest total number of claims is 99707

--b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.

--SELECT nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, SUM(total_claim_count) AS claims_provider
--FROM prescriber 
--INNER JOIN prescription 
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
-- Solution 1
--SELECT specialty_description, COUNT(total_claim_count) AS total_specialty
--FROM prescriber 
--LEFT JOIN prescription 
--USING (npi)
--WHERE total_claim_count IS NULL
--GROUP BY specialty_description;

-- Solution 2
--SELECT DISTINCT specialty_description  
--FROM prescriber
--WHERE specialty_description NOT IN
--		(
--			select distinct specialty_description  
--			from prescriber pr
--			inner join prescription pn 
--			on pr.npi= pn.npi 
--		)
--ORDER BY specialty_description;

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

--SELECT t1.specialty_description, t1.total_opioid_claim, t2.total_specialty, ROUND(t1.total_opioid_claim * 100.0 / t2.total_specialty, 1) AS Percent
--FROM 
--  (SELECT specialty_description, SUM(total_claim_count) AS total_opioid_claim
--	FROM prescription 
--	LEFT JOIN prescriber 
--	USING(npi)
--	LEFT JOIN drug 
--	USING(drug_name)
--	WHERE opioid_drug_flag = 'Y'
--	GROUP BY specialty_description) AS t1
--LEFT JOIN
--    (SELECT specialty_description, SUM(total_claim_count) AS total_specialty
--	FROM prescription 
--	LEFT JOIN prescriber 
--	USING(npi)
--	LEFT JOIN drug 
--	USING(drug_name)
--	GROUP BY specialty_description) AS t2
--ON (t1.specialty_description = t2.specialty_description)
--ORDER BY Percent DESC;

--3.a. Which drug (generic_name) had the highest total drug cost?
--SELECT drug_name, SUM(total_drug_cost) AS highest_drug_cost
--FROM prescription
--INNER JOIN drug
--USING (drug_name)
--GROUP BY drug_name
--ORDER BY highest_drug_cost DESC; 

--b. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.
--SELECT
--	generic_name,
--	SUM(total_drug_cost)::money AS total_cost,
--	SUM(total_day_supply) AS total_supply,
--	SUM(total_drug_cost)::money / SUM(total_day_supply) AS cost_per_day
--FROM prescription
--INNER JOIN drug
--USING(drug_name)
--GROUP BY generic_name
--ORDER BY cost_per_day DESC;

--SELECT 
--	  generic_name,
--	ROUND(SUM(total_drug_cost)/SUM(total_day_supply), 2) AS perday_cost
--FROM prescription AS A
--INNER JOIN drug AS B
--ON A.drug_name = B.drug_name
--GROUP BY generic_name 
--ORDER BY perday_cost DESC;

--4. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.
--SELECT generic_name, CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- ELSE 'neither'
-- END AS drug_type	
--FROM drug
--ORDER BY drug_type;

	
--b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.
--SELECT generic_name,
--	CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
--	 WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
--	 ELSE 'neither'END AS drug_type,
-- (total_drug_cost::money) AS drug_cost
  
--FROM drug
--LEFT JOIN prescription
--USING(drug_name)
--ORDER BY drug_type
--GROUP BY drug_type;

--5.
 -- a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.
--SELECT COUNT(cbsa)
--FROM cbsa
--WHERE cbsaname LIKE '%TN';

--  b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
--SELECT cbsaname, SUM(population) AS total_population
--FROM cbsa
--INNER JOIN population
--USING(fipscounty)
--WHERE state = "TN"
--GROUP BY cbsaname
--ORDER BY total_population DESC;

--  c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
--SELECT county, population
--FROM fips_county
--INNER JOIN population
--USING(fipscounty)
--WHERE fipscounty NOT IN 
--                       (SELECT fipscounty
--					    FROM cbsa)
--GROUP BY county, population
--ORDER BY population DESC;


--6.a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
--SELECT drug_name, total_claim_count
--FROM prescription
--WHERE total_claim_count >= 3000;

--b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
--SELECT drug_name, total_claim_count, opioid_drug_flag AS opioid
--FROM prescription
--INNER JOIN drug
--USING(drug_name)
--WHERE total_claim_count >= 3000
--	AND opioid_drug_flag = 'Y' OR opioid_drug_flag = 'N'
--ORDER BY opioid DESC;
	
--c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
--SELECT drug_name, total_claim_count, opioid_drug_flag AS opioid, nppes_provider_last_org_name, nppes_provider_first_name
--FROM prescription 
--LEFT JOIN prescriber 
--USING(npi)
--LEFT JOIN drug 
--USING(drug_name)
--WHERE total_claim_count >= 3000
--	AND opioid_drug_flag = 'Y'OR opioid_drug_flag = 'N'
--ORDER BY opioid DESC
--LIMIT 10;

--7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. Hint: The results from all 3 parts will have 637 rows.
--SELECT npi, drug_name
--FROM prescriber, drug
--WHERE specialty_description = 'Pain Management' AND nppes_provider_city = 'NASHVILLE' AND opioid_drug_flag = 'Y'

--b.Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
--SELECT p.npi, d.drug_name, total_claim_count
--FROM prescriber as p
--CROSS JOIN drug AS d
--FULL JOIN prescription 
--USING(npi, drug_name)
--WHERE p.specialty_description = 'Pain Management' AND
--	p.nppes_provider_city = 'NASHVILLE' AND
--	d.opioid_drug_flag = 'Y';


--c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.









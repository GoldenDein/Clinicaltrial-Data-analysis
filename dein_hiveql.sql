-- Databricks notebook source
-- DBTITLE 1,TABLES FOR ALL FILES WERE CREATED WITH THE IMPORT UI
--TABLES FOR ALL FILES WERE CREATED WITH THE IMPORT UI, TABLE IMPORT IS REQUIRED TO RUN

-- COMMAND ----------

SELECT *
FROM clinicaltrial_2021 
LIMIT 5

-- COMMAND ----------

-- DBTITLE 1,Question 1 - Number of Studies
--CASE 1 -> Number of Studies
SELECT COUNT(*) as Number_of_studies
FROM clinicaltrial_2021 

-- COMMAND ----------

-- DBTITLE 1,Question 2 - Types of Studies
--CASE 2 -> Types of Studies
SELECT type, COUNT(type) AS Frequency 
FROM clinicaltrial_2021
GROUP BY type
ORDER BY 2 DESC

-- COMMAND ----------

-- DBTITLE 1,Question 3 -> Top 5 Conditions
--CASE 3 -> Top 5 Conditions
SELECT top_5_condtions, COUNT(top_5_condtions) AS Frequency
FROM clinicaltrial_2021 LATERAL VIEW explode(split(conditions,',')) t1 as top_5_condtions
GROUP BY top_5_condtions
ORDER BY 2 DESC
LIMIT 5

-- COMMAND ----------

-- DBTITLE 1,Question 4 - 5 most frequent roots
--CASE 4 -> 5 most frequent roots
WITH t1 as (
SELECT term, substring(tree, 1,3) as Roots
FROM mesh ),
t2 AS (
SELECT all_conditions
FROM clinicaltrial_2021 LATERAL VIEW explode(split(conditions,',')) t3 as all_conditions
)
SELECT Roots, count(Roots) as Frequency
FROM t1
JOIN t2
ON t1.term = t2.all_conditions
GROUP BY roots
ORDER BY 2 DESC
LIMIT 5

-- COMMAND ----------

-- DBTITLE 1,Question 5 - 10 most common Sponsors (excluding pharmaceutical companies)
--CASE 5 -> 10 most common Sponsors (excluding pharmaceutical companies)
WITH t1 as (
SELECT Sponsor
FROM clinicaltrial_2021),
t2 AS (
SELECT parent_company
FROM pharma
)
SELECT Sponsor, count(Sponsor) as Clinical_Trials
FROM t1
LEFT ANTI JOIN t2
ON t1.Sponsor = t2.parent_company
GROUP BY Sponsor
ORDER BY 2 DESC
LIMIT 10

-- COMMAND ----------

-- DBTITLE 1,Question 6 - Number of completed studies each month of 2021
--CASE 6 -> Number of completed studies each month of 2021
SELECT SUBSTRING(Completion,1,3) AS Month, count(Completion) AS Number_of_studies
FROM clinicaltrial_2021
WHERE status = 'Completed' and Completion LIKE '%2021%'
GROUP BY Completion
ORDER BY unix_timestamp(SUBSTR(Completion,1,3), 'MMM') 

-- COMMAND ----------



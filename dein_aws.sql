-- AWS IMPLEMENTATION


-- COMMAND ----------

--Question 1 - Number of Studies
SELECT COUNT(*) AS Number_of_studies FROM "clinicaltrial_2021" 
WHERE id <> 'Id'

-- COMMAND ----------

--Question 2 - Types of Studies
SELECT type, COUNT(type) AS Frequency
FROM clinicaltrial_2021
GROUP BY type
ORDER BY 2 DESC
LIMIT 4

-- COMMAND ----------

---Question 3 -> Top 5 Conditions
WITH t AS (
SELECT conditions FROM clinicaltrial_2021
WHERE conditions <> '' )
SELECT top_5_conditions, COUNT(*) AS Frequency
FROM t
CROSS JOIN UNNEST(split(t.conditions, ',')) AS x(top_5_conditions)
GROUP BY top_5_conditions
ORDER BY 2 DESC
LIMIT 5

-- COMMAND ----------

--Question 4 - 5 most frequent roots
SELECT roots, COUNT(*) as frequency
FROM
(SELECT *
FROM (SELECT term, substring(tree, 1,3) as roots FROM mesh)) r 
JOIN
(SELECT*FROM(
WITH t AS (
SELECT conditions FROM clinicaltrial_2021
WHERE conditions <> '' )
SELECT cond
FROM t
CROSS JOIN UNNEST(split(t.conditions, ',')) AS x(cond))) c
ON r.term = c.cond
GROUP BY roots
ORDER BY 2 DESC
LIMIT 5

-- COMMAND ----------

--Question 5 - 10 most common Sponsors (excluding pharmaceutical companies)
WITH t1 as (
SELECT Sponsor
FROM clinicaltrial_2021),
t2 AS (
SELECT parent_company
FROM pharma
)
SELECT Sponsor, count(Sponsor) as Clinical_Trials
FROM t1
LEFT OUTER JOIN t2
ON t1.Sponsor = t2.parent_company
WHERE Sponsor NOT IN ('GlaxoSmithKline','AstraZeneca','Pfizer', 'Boehringer Ingelheim' )
GROUP BY Sponsor
ORDER BY 2 DESC
LIMIT 10

-- COMMAND ----------

--Question 6 - Number of completed studies each month of 2021
SELECT SUBSTRING(Completion,1,3) AS Month, count(Completion) AS Number_of_studies
FROM clinicaltrial_2021
WHERE status = 'Completed' and Completion LIKE '%2021%'
GROUP BY Completion
ORDER BY CASE  
            when SUBSTRING(Completion, 1, 3) = 'Jan' then 0 
            when SUBSTRING(Completion, 1, 3) = 'Feb' then 1
            when SUBSTRING(Completion, 1, 3) = 'Mar' then 2
            when SUBSTRING(Completion, 1, 3) = 'Apr' then 3
            when SUBSTRING(Completion, 1, 3) = 'May' then 4
            when SUBSTRING(Completion, 1, 3) = 'Jun' then 5
            when SUBSTRING(Completion, 1, 3) = 'Jul' then 6
            when SUBSTRING(Completion, 1, 3) = 'Aug' then 7
            when SUBSTRING(Completion, 1, 3) = 'Sep' then 8
            when SUBSTRING(Completion, 1, 3) = 'Oct' then 9
            when SUBSTRING(Completion, 1, 3) = 'Nov' then 10
            when SUBSTRING(Completion, 1, 3) = 'Dec' then 11
           END
ASC

-- COMMAND ----------



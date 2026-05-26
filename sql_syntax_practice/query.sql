SELECT 
  job_title,
  job_location,
  job_posted_date
FROM job_postings_fact
LIMIT 100;

SELECT 
  job_title,
  job_location,
  job_posted_date::DATE  
FROM job_postings_fact
LIMIT 100;

SELECT 
  job_title,
  job_location,
  job_posted_date AT TIME ZONE 'Pacific/auckland',
FROM job_postings_fact
LIMIT 100;

SELECT 
  job_title,
  job_location,
  job_posted_date AT TIME ZONE 'EST' AT TIME ZONE 'NZDT'
FROM job_postings_fact
LIMIT 100;

SELECT 
  job_title,
  job_location,
  job_posted_date AT TIME ZONE 'EST' AT TIME ZONE 'NZDT',
  EXTRACT (DAY FROM job_posted_date) AS month_date
FROM job_postings_fact
LIMIT 100;

/* result defaults to the orignal time stamp,,
so everything works except hour: req to include the extra info 
about Time stamp change in the EXTRACT function
to get correct result as below */


SELECT 
  job_title,
  job_location,
  job_posted_date AT TIME ZONE 'EST' AT TIME ZONE 'NZDT',
  EXTRACT 
  (hour FROM job_posted_date AT TIME ZONE 'EST' 
   AT TIME ZONE 'NZDT') AS month_date
FROM job_postings_fact
LIMIT 100;

--............EXTRACT>>>only have grouped items in select>>>>>>>>>>>>
----GROUP BY EXTRACT(MONTH FROM job_posted_date):: works universaly..
--postgres allows this maybe not some other sql----
--carefull using Group with non text not aggragated as syntax may not 
--**show error n only pick randon error...

SELECT
  COUNT (job_id),
  EXTRACT (MONTH FROM job_posted_date) AS job_month
FROM job_postings_fact
GROUP BY job_month 

---group by accepts alias but surprisingly Having doesnt..
-----*******Group by:all listed in Select must have aggragate 
--..**OR the one used for GrOUp by can be the exeption if its an 
--** string as text cant be aggragated if not in GRoupby--

SELECT
  COUNT (job_id) as jpm,
  EXTRACT (MONTH FROM job_posted_date) AS job_month
FROM job_postings_fact
GROUP BY job_month
HAVING COUNT (job_id) > 70000


SELECT
  COUNT (job_id) as jpm,
  EXTRACT (MONTH FROM job_posted_date) AS job_month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY job_month
HAVING COUNT (job_id) > 100
ORDER BY jpm



---............creating jan feb march.....

SELECT *
FROM job_postings_fact
WHERE EXTRACT (MONTH FROM job_posted_date) <=3
LIMIT 100;

CREATE TABLE jobs_posted_jan AS 
  SELECT *
  FROM job_postings_fact
  WHERE EXTRACT (MONTH FROM job_posted_date) =1
  LIMIT 100; 

CREATE TABLE jobs_posted_feb AS 
  SELECT *
  FROM job_postings_fact
  WHERE EXTRACT (MONTH FROM job_posted_date) =2
  LIMIT 100;

CREATE TABLE jobs_posted_march AS 
  SELECT *
  FROM job_postings_fact
  WHERE EXTRACT (MONTH FROM job_posted_date) =3
  LIMIT 100;

--........CASE create new column with specific conditions.

SELECT
  COUNT(job_id),
  CASE 
    WHEN job_country = 'New Zealand' THEN 'ANZ'
    WHEN job_country = 'Australia' THEN 'ANZ'
    WHEN job_country = 'United States' THEN 'N_America'
    WHEN job_country = 'Canada' THEN 'N_America'
    ELSE 'Rest_of_world'
    END AS job_location_category
FROM job_postings_fact
WHERE job_title like 'Data Analyst'
GROUP BY job_location_category

SELECT
  COUNT(job_id),
  CASE 
    WHEN job_country = 'New Zealand' THEN 'ANZ'
    WHEN job_country = 'Australia' THEN 'ANZ'
    WHEN job_country = 'United States' THEN 'N_America'
    WHEN job_country = 'Canada' THEN 'N_America'
    ELSE 'Rest_of_world'
    END AS job_location_category
FROM job_postings_fact
WHERE job_title like '%ython%'
GROUP BY job_location_category;

select 
 job_id,
 job_title_short,
 salary_year_avg,
  CASE
  WHEN salary_year_avg > 130000 THEN 'HIGH'
  WHEN salary_year_avg BETWEEN 80000 and 130000 THEN 'STANDARD'
  ELSE 'LOW'
  END AS salary_categorization 
from job_postings_fact
WHERE job_title = 'Data Analyst' 
AND salary_year_avg IS NOT NULL
ORDER by salary_year_avg DESC;

select 
 COUNT(job_id),
 AVG (salary_year_avg) AS avg_sal_category,
  CASE
  WHEN salary_year_avg > 130000 THEN 'HIGH'
  WHEN salary_year_avg BETWEEN 80000 and 130000 THEN 'STANDARD'
  ELSE 'LOW'
  END AS salary_categorization 
from job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY salary_categorization
ORDER by avg_sal_category

---subuery select from where--------------------
SELECT *
FROM
   (SELECT *
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) =1
    LIMIT 100);

---CTE-----------------------

WITH january_jobs AS 
  (SELECT 
  job_id,
  job_posted_date
  FROM job_postings_fact
  WHERE EXTRACT (MONTH FROM job_posted_date) =1
  LIMIT 100)
SELECT *
FROM january_jobs;

select *
from skills_dim

limit 100

select count(job_id) as no_ofjobs_skill,
       skill_id
from skills_job_dim
group by skill_id
limit 5

SELECT 
    sd.skills,
    COUNT(sjd.job_id) AS no_ofjobs_skill
FROM skills_job_dim AS sjd
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
GROUP BY sjd.skill_id,sd.skills
LIMIT 5;

SELECT
    skills.skills,
    skills_count.no_ofjobs_skill
FROM (
    SELECT 
        skill_id,
        COUNT(job_id) AS no_ofjobs_skill
    FROM skills_job_dim
    GROUP BY skill_id
) AS skills_count
LEFT JOIN skills_dim AS skills
    ON skills_count.skill_id = skills.skill_id
LIMIT 5;


SELECT 
skills_dim.skills,
skills_dim.skill_id,
skills_count.no_ofjobs_skill

FROM
  (select 
    count(job_id) as no_ofjobs_skill,
    skill_id
  from skills_job_dim
  group by skill_id
  limit 5) 
  as skills_count
LEFT JOIN skills_dim
  ON skills_count.skill_id = skills_dim.skill_id;


select 
  cd.name,
  count(job_id) as total_jobs,
  CASE 
  WHEN count(job_id) < 10 THEN 'LOW'
  WHEN count(job_id) BETWEEN 10 and 50 THEN 'MEDIUM'
  ELSE 'HIGH'
  END as job_vol_company
from job_postings_fact jpf

left join company_dim cd
on jpf.company_id = cd.company_id
group by cd.name
order by total_jobs DESC

-------------

   
SELECT 
  company_dim.name as company_name,
  company_info.total_jobs,
  company_info.job_vol_rating
FROM
    (SELECT
      count(job_id) as total_jobs,
      company_id,
      CASE 
      WHEN count(job_id) < 10 THEN 'LOW'
      WHEN count(job_id) BETWEEN 10 and 50 THEN 'MEDIUM'
      ELSE 'HIGH'
      END as job_vol_rating
    FROM job_postings_fact 
    GROUP BY company_id) as company_info
LEFT JOIN company_dim
 ON company_info.company_id = company_dim.company_id
 order by total_jobs DESC;

-------------------------------

SELECT
sjd.skill_id,
sd.skills,
count (jpf.job_id) as skills_count

FROM job_postings_fact jpf
JOIN skills_job_dim sjd
ON jpf.job_id = sjd.job_id
JOIN skills_dim sd
ON sjd.skill_id = sd.skill_id
WHERE jpf.job_work_from_home = TRUE
GROUP By sjd.skill_id,sd.skills
ORDER by skills_count DESC
LIMIT 100;




WITH remote_job_skill AS (
  SELECT
    sjd.skill_id,
    count (jpf.job_id) as skills_count
  FROM job_postings_fact jpf
  JOIN skills_job_dim sjd
  using (job_id)
  WHERE jpf.job_work_from_home = TRUE
  GROUP By sjd.skill_id)

SELECT 
sd.skill_id,
sd.skills,
rjs.skills_count
FROM remote_job_skill as rjs
JOIN skills_dim sd
USING (skill_id)
ORDER BY skills_count DESC
LIMIT 5;

-------
WITH remote_job_skill AS (
  SELECT
    sjd.skill_id,
    count (jpf.job_id) as skills_count
  FROM job_postings_fact jpf
  JOIN skills_job_dim sjd
  using (job_id)
  WHERE jpf.job_work_from_home = TRUE
  AND jpf.job_title = 'Data Analyst'
  GROUP By sjd.skill_id)

SELECT 
sd.skill_id,
sd.skills,
rjs.skills_count
FROM remote_job_skill as rjs
JOIN skills_dim sd
USING (skill_id)
ORDER BY skills_count DESC
LIMIT 5;

---------------------------------------------

SELECT 
job_title_short,
job_work_from_home,
job_posted_date::DATE,
salary_year_avg,
job_location
 FROM jobs_posted_jan
UNION ALL
SELECT 
job_title_short,
job_work_from_home,
job_posted_date::DATE,
salary_year_avg,
job_location
 FROM jobs_posted_feb
UNION ALL
SELECT 
job_title_short,
job_work_from_home,
job_posted_date::DATE,
salary_year_avg,
job_location
 FROM jobs_posted_march;


--..............................................
CREATE TABLE jobs_posted_feb AS (
  SELECT *
  FROM job_postings_fact
  WHERE EXTRACT (MONTH FROM job_posted_date) = 2)


INSERT INTO jobs_posted_march
SELECT *
FROM job_postings_fact
WHERE EXTRACT (MONTH FROM job_posted_date) = 3
AND job_id NOT IN (
    SELECT job_id
    FROM jobs_posted_march
);
---------------------------------
 

SELECT 
job_title_short,
job_work_from_home,
job_posted_date::DATE,
salary_year_avg,
job_location
FROM
(
  SELECT * FROM jobs_posted_jan
  UNION ALL
  SELECT * FROM jobs_posted_feb
  UNION ALL
  SELECT * FROM jobs_posted_march) AS first_quater_jobs
  WHERE salary_year_avg >65000
  AND job_title LIKE '%Data Analyst'










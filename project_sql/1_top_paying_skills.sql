/* 
-------------------------------------------------------------------
--Main objective
  1)What are the top paying jobs for data Analyst?
  2)What are the skills required for these high paying jobs?
  3)What are the most in demand skills for Data Analyst?
  4)What are the top skills based on salary from Data Analyst?
  5)What are the most optimal skills to learn?
        i.e High Demand & High Salary
--------------------------------------------------------------------


 *****1) What are the top paying jobs for data Analyst?

        --What are the top paying Data Analyst jobs?
        --Identify the top 10 highest paying Data Analyst 
          roles that are available remotely.
        -- Focus on job postings with specified salaries.
        --Why? Highlight the top paying opportuniteis for 
          Data Analysts, offering insights into 
          highest paid roles
        */

SELECT
    job_id,
    job_title,
    job_location,
    salary_year_avg,
    name as company_name
FROM
    job_postings_fact jpf
LEFT JOIN company_dim cd
    ON jpf.company_id = cd.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

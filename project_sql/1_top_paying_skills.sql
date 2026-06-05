/* 
-------------------------------------------------------------------
--Main objective
  1)What are the top paying remote jobs for data Analyst?
  2)What are the skills required for these high paying jobs?
  3)What are the most in demand skills for Data Analyst?
  4)What are the top skills based on salary from Data Analyst?
  5)What are the most optimal skills to learn?i.e High Demand & High Salary
--------------------------------------------------------------------


 *****1) What are the top paying remote jobs for data Analyst?

        --What are the top 10 paying remote Data Analyst jobs?
        -- Focus on job postings where location is "Anyehere" with specified salaries.
        --Why? Highlight the top paying opportuniteis for Data Analysts, offering 
          insights into highest paid roles.
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


/*
--Key Observations:

--Top-paying remote Data Analyst roles offer salaries ranging from $184K to $650K annually.
--The highest-paying position is titled "Data Analyst" at Mantys with a salary of $650K, 
  though the title alone may not fully reflect the role's seniority, responsibilities, or 
  specialized requirements.
--Most of the other highest-paying positions are senior or leadership-level roles, such as 
  Director and Principal Data Analyst positions.
--This suggests that advanced expertise, specialized skills, and leadership responsibilities 
  are often associated with higher compensation in data analytics roles.
  */
  
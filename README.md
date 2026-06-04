# Introduction
This project analyzes the Data Analyst job market, examining which skills are most in demand and which are associated with higher average salaries within Data Analyst roles. By evaluating both demand and salary trends, the analysis identifies the skills that offer the strongest combination of job opportunities and earning potential for career development in data analytics.
# Background
[SQL Project Data](/project_sql/)
# Tools I used
- **SQL** – Used to query, clean, and analyze data by extracting insights from databases.
- **PostgreSQL** – Served as the primary database management system for storing and querying project data.
- **SQLite** – Used during the initial stages of the project for lightweight database practice and testing.
- **VS Code** – Main development environment used to write, run, and manage SQL scripts and project files.
- **Git** – Used for version control to track changes and manage project development.
- **GitHub** – Used to publish the project, store code remotely, and showcase results in a portfolio repository.
# The Analysis
The analysis was conducted with a focus on the following five core objectives:
  ## 1) What are the top paying jobs for data Analyst?
  Analyzed remote Data Analyst job postings to identify the top 10 highest-paying roles. Positions without salary information were excluded to ensure accurate salary comparisons and to gain insights into the roles offering the highest compensation.

  | Job Title | Salary Year Avg | Company Name |
|-----------|----------------|--------------|
| Data Analyst | 650,000.0 | Mantys |
| Director of Analytics | 336,500.0 | Meta |
| Associate Director- Data Insights | 255,829.5 | AT&T |
| Data Analyst, Marketing | 232,423.0 | Pinterest Job Advertisements |
| Data Analyst (Hybrid/Remote) | 217,000.0 | Uclahealthcareers |
| Principal Data Analyst (Remote) | 205,000.0 | SmartAsset |
| Director, Data Analyst - HYBRID | 189,309.0 | Inclusively |
| Principal Data Analyst, AV Performance Analysis | 189,000.0 | Motional |
| Principal Data Analyst | 186,000.0 | SmartAsset |
| ERM Data Analyst | 184,000.0 | Get It Recruit - Information Technology |
<br><br><br>

{*I did a query to pull the top 10 highest-paying remote Data Analyst jobs, joining company data to get company names, filtering out missing salaries, and sorting everything in descending order by average salary.*}
```sql
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
```

  ## 2) What are the skills required for these high paying jobs?

This analysis builds on the previous table of the top 10 highest-paying remote Data Analyst roles by incorporating the associated technical skill requirements, highlighting the key competencies linked to higher salaries and helping job seekers prioritize the most in-demand skills for career growth.

 | Job Title | Avg Salary | Skills |
|----------|------------|--------|
| Data Analyst | 650000.0 |  |
| Director of Analytics | 336500.0 |  |
| Associate Director- Data Insights | 255829.5 | sql, python, r, azure, databricks, aws, pandas, pyspark, jupyter, excel, tableau, power bi, powerpoint |
| Data Analyst, Marketing | 232423.0 | sql, python, r, hadoop, tableau |
| Data Analyst (Hybrid/Remote) | 217000.0 | sql, crystal, oracle, tableau, flow |
| Principal Data Analyst (Remote) | 205000.0 | sql, python, go, snowflake, pandas, numpy, excel, tableau, gitlab |
| Director, Data Analyst - HYBRID | 189309.0 | sql, python, azure, aws, oracle, snowflake, tableau, power bi, sap, jenkins, bitbucket, atlassian, jira, confluence |
| Principal Data Analyst, AV Performance Analysis | 189000.0 | sql, python, r, git, bitbucket, atlassian, jira, confluence |
| Principal Data Analyst | 186000.0 | sql, python, go, snowflake, pandas, numpy, excel, tableau, gitlab |
| ERM Data Analyst | 184000.0 | sql, python, r |

<br><br><br>
*{I did this analysis using a CTE to first extract the top 10 highest-paying remote Data Analyst roles, then used a LEFT JOIN instead of an INNER JOIN to highlight that the top two roles have NULL skill values. I then refined the output using STRING_AGG to consolidate skills into a single column, reducing row duplication and avoiding repetition of job title and average salary values.}*

```sql
WITH top_paying_skills AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    cd.name as company_name
FROM
    job_postings_fact jpf
LEFT JOIN company_dim cd
    ON jpf.company_id = cd.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10)

SELECT 
    top_paying_skills.*,
    sd.skills
FROM top_paying_skills
LEFT JOIN skills_job_dim sjd
USING (job_id) 
LEFT JOIN skills_dim sd
ON sjd.skill_id = sd.skill_id
ORDER BY salary_year_avg DESC;


--using String agg results can be compressed into 10 rows avoiding repetteion 


WITH top_paying_skills AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    cd.name as company_name
FROM
    job_postings_fact jpf
LEFT JOIN company_dim cd
    ON jpf.company_id = cd.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10)
SELECT 
    tps.job_title,
    tps.salary_year_avg,
    STRING_AGG(sd.skills, ', ') AS skills
FROM top_paying_skills tps
LEFT JOIN skills_job_dim sjd
    USING (job_id)
LEFT JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
GROUP BY 
    tps.job_title,
    tps.salary_year_avg
ORDER BY tps.salary_year_avg DESC;
```
  
  ## 3) What are the most in demand skills for Data Analyst?
  I looked at all job postings, not just remote ones, to find the top 10 most in-demand data analysis skills based on how often they appear. This gives a clearer view of the most commonly required skills in the overall job market and what job seekers should focus on.
  ![Most in demand Data Analysis skills](/Users/desk/sql_project_data/project_sql/images)
  ## 4) What are the top skills based on salary from Data Analyst?
  ## 5) What are the most optimal skills to learn? i.e High Demand & High Salary
# What I learned
# Conclusions 

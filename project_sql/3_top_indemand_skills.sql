/*
***** 3)What are the most in demand skills for Data Analyst?

    What are the most in demand skills for data analysis?
    Identify the top 10 in demand skills
    Focus on all job postings
    Why? Retreives the top 10 skills with highest demand providing
    insight into most valuable skills */




      --OR |alt could use only two tables skills_dim & skills_job_dim but since
      --further filtering is req to filter Data analyst roles so not applicable|-

            SELECT 
                skills,
                COUNT (skills_job_dim.job_id) AS demand_count
            FROM  skills_job_dim
            LEFT JOIN skills_dim USING (skill_id)
            GROUP BY skills
            ORDER BY demand_count DESC
            LIMIT 5 


      ----------

SELECT 
    skills,
    COUNT (skills_job_dim.job_id) AS demand_count
FROM job_postings_fact 
LEFT JOIN skills_job_dim USING (job_id) 
LEFT JOIN skills_dim USING (skill_id)
WHERE job_title_short = 'Data Analyst'
--AND job_no_degree_mention IS TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10;


/*
--Key findings:

--SQL was the most in-demand skill, appearing in 92,628 job postings, making it the core 
  technical skill for Data Analyst roles.
--Excel and Python ranked second and third, highlighting the continued importance of 
  spreadsheet analysis alongside programming and automation capabilities.
--Tableau and Power BI were also highly sought after, demonstrating strong demand for 
  data visualization and business intelligence skills.
--R and SAS remained relevant analytical tools, though they appeared less frequently than Python.
--Business-oriented tools such as PowerPoint, Word, and SAP also featured among the top skills, 
  indicating that communication, reporting, and enterprise system knowledge are valuable 
  complements to technical expertise.
--Overall, the most in-demand Data Analyst skill set combines data querying (SQL), analysis and 
  automation (Python, Excel), visualization (Tableau, Power BI), and business communication tools.

*/



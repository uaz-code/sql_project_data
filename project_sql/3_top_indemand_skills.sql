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


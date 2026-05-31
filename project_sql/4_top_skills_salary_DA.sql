/* **** 4)What are the top skills based on salary from Data Analyst?

Look at avg salary associated with each skill for Data analyst
Focus on roles with specified salary regardless of location
Why? It will reveal how skills effect salary level and help 
identify most financially rewarding skill for Data Analyst
*/

SELECT 
    skills,
    ROUND (AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact 
LEFT JOIN skills_job_dim USING (job_id) 
LEFT JOIN skills_dim USING (skill_id)
WHERE job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
--AND job_work_from_home IS TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 100

/*
--Key Findings from the Highest-Paying Skills Analysis
--Average salary can be misleading. Skills such as SVN ($400k) and
  Solidity ($179k) likely appear in very few jobs. A small number of 
  high-paying roles can significantly inflate the average salary.
--Cloud and data engineering skills are highly rewarded. Snowflake ($112k),
  Databricks ($113k), Spark/PySpark ($113k–114k), and cloud platforms such
  as AWS ($106k) and Azure ($105k) are all associated with above-average salaries.
--Machine learning skills command strong salaries. Tools such as PyTorch ($125k),
  TensorFlow ($121k), and Keras ($127k) suggest that advanced analytical and 
  AI-related skills can increase earning potential.
--Python skills outperform traditional BI tools. Python ($102k), Pandas ($111k),
  and NumPy ($107k) have higher average salaries than Tableau ($98k) and Power BI 
  ($92k).
--SQL remains essential. Although SQL ($96k) is not the highest-paying skill, it is
  a core requirement for many Data Analyst roles and serves as a foundation for 
  higher-level skills.
--Office productivity tools rank lower. Skills such as Excel ($86k), PowerPoint ($88k),
  and Word ($83k) appear more often in lower-paying roles and are less likely to 
  drive salary growth.

Recommendation
Focus first on SQL, Python, and Tableau/Power BI to build a strong analytics 
foundation. Then expand into Snowflake, AWS/Azure, Spark, PySpark, and Databricks
 to access higher-paying opportunities. When evaluating skills, consider both 
 salary and demand—a skill with a very high average salary but few job postings 
 may offer fewer opportunities than widely requested skills such as SQL and Python.
 */
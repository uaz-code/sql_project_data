/*
        ****5)What are the most optimal skills to learn?

What are the most optimal skills for Data Analyst i.e most demand count and avg_salary
Concentrate on all positions and then filter further to remote positions with specified salaries
Why? It will showcase high demand jobs (job security and Financial reward(avg_salary)
Provide useful info for Data Analyst career developement
*/

--(ALL Postions)
WITH skills_demand AS 
    (SELECT 
        skills,
        skill_id,
        COUNT (skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact 
    LEFT JOIN skills_job_dim USING (job_id) 
    LEFT JOIN skills_dim USING (skill_id)
    WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    --AND job_work_from_home IS TRUE
    GROUP BY skill_id,skills
    ORDER BY demand_count DESC
    ),

    avg_salary_skill AS
    (SELECT 
        skills,  
        skill_id,
        ROUND (AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact 
    LEFT JOIN skills_job_dim USING (job_id) 
    LEFT JOIN skills_dim USING (skill_id)
    WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    --AND job_work_from_home IS TRUE
    GROUP BY skill_id,skills
    ORDER BY avg_salary DESC
    )
  --note here columns exist only in CTE so prefix to CTE table name when needed 
SELECT
   --skills_demand.skill_id,
   avg_salary_skill.skills,
   demand_count,
   avg_salary
FROM skills_demand
INNER JOIN avg_salary_skill
USING (skill_id)
WHERE demand_count > 20
ORDER BY demand_count DESC,
         avg_salary DESC
LIMIT 15;  

-----------------------------------------------

--(REMOTE poistions only)
WITH skills_demand AS 
    (SELECT 
        skills,
        skill_id,
        COUNT (skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact 
    LEFT JOIN skills_job_dim USING (job_id) 
    LEFT JOIN skills_dim USING (skill_id)
    WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home IS TRUE
    GROUP BY skill_id,skills
    ORDER BY demand_count DESC
    ),

    avg_salary_skill AS
    (SELECT 
        skills,  
        skill_id,
        ROUND (AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact 
    LEFT JOIN skills_job_dim USING (job_id) 
    LEFT JOIN skills_dim USING (skill_id)
    WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home IS TRUE
    GROUP BY skill_id,skills
    ORDER BY avg_salary DESC
    )
  --note here columns exist only in CTE so prefix to CTE table name when needed 
SELECT
   --skills_demand.skill_id,
   avg_salary_skill.skills,
   demand_count,
   avg_salary
FROM skills_demand
INNER JOIN avg_salary_skill
USING (skill_id)
WHERE demand_count > 20
ORDER BY demand_count DESC,
         avg_salary DESC
LIMIT 10;

--note if two orderby metrics then second one takes effect if first
--one is same

--This can be replicated by using double JOIN instead of CTE and syntax 
--will be shorter

/* KEY findings
--SQL is the most valuable core skill for Data Analysts, with the highest demand (398 remote and 3083 overall postings) 
  and a strong average salary ($97,237), making it the best combination of market demand and 
  compensation.
--Python ($101,397), Tableau ($99,288), and R ($100,499) also offer an excellent balance of demand
  and salary, making them strong investments for aspiring Data Analysts.
--Excel remains one of the most requested skills (256 postings) but has a lower average salary 
  ($87,288), suggesting it is a baseline expectation rather than a premium skill.
--Go has the highest average salary ($115,320) among the listed skills, followed by Hadoop ($113,193)
   and Snowflake ($112,948). However, their relatively low demand (22–37 postings) indicates they are 
   specialized skills that can boost earnings but are not core requirements for most Data Analyst positions.
--The optimal career strategy is to first master high-demand skills such as SQL, Python, and 
    Tableau/Power BI, then expand into higher-paying niche technologies like Snowflake, Hadoop, AWS, 
    Azure, or Go to differentiate yourself and increase earning potential. 
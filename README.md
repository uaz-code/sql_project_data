# **📊 Introduction**
This project analyzes the Data Analyst job market, examining which skills are most in demand and which are associated with 💰higher average salaries within Data Analyst roles. By evaluating both 🚀demand and salary trends, the analysis identifies the 🍳skills that offer the strongest combination of job opportunities and earning potential for career development in Data Analytics.

SQL queries -> [Project Data](/project_sql/)

Dataset used for this project -> [SQL Course](https://lukebarousse.com/sql)

The main objectives of this project are to explore the Data Analyst job market and answer the following key questions:

  1. 💰What are the top paying jobs for Data Analyst?
  2. 🍳What are the skills required for these high paying jobs?
  3. What are the most in demand skills for Data Analyst?
  4. What are the top skills based on salary from Data Analyst?
  5. What are the most optimal skills to learn (i.e., high demand and high salary)?

<br><br><br>


# **⚙️ Tools I used**

- **SQL** – Used to query and clean data, and extract insights from databases.
- **PostgreSQL** – Served as the primary database management system for storing and querying project data.
- **SQLite** – Used during the initial stages of the project for lightweight database practice and testing.
- **VS Code** – Main development environment used to write, run, and manage SQL scripts and project files.
- **Git** – Used for version control to track changes and manage project development.
- **GitHub** – Used to publish the project, store code remotely, and showcase results in a portfolio repository.
- **ChatGPT** – Used to support learning, SQL query development, debugging, and data analysis. It assisted with understanding concepts, resolving errors, exploring alternative solutions, validating logic, and accelerating syntax reference and problem-solving throughout the project.

<br><br><br>


# **🔍 The Analysis**
The analysis was conducted with a focus on the following five core objectives:

  ### 1. What are the top-paying jobs for Data Analyst?
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

<br><br>

*I ran a query to pull the top 10 highest-paying remote Data Analyst jobs, joining company data to get company names, filtering out missing salaries, and sorting everything in descending order by average salary.*
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
<br><br>

  ### 2. What are the skills required for these high paying jobs?

- This analysis builds on the previous table of the top 10 highest-paying remote Data Analyst roles by incorporating the associated technical skill requirements, highlighting the key competencies linked to higher salaries and helping job seekers prioritize skills for career growth.

- The two highest-paying jobs in the dataset ($650,000 and $336,500) had no associated skill records, so their requirements could not be analyzed and may have involved leadership, domain expertise, or other responsibilities not captured in the skills data.


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

<br><br>
*I used a CTE to extract the top 10 highest-paying remote Data Analyst roles, then applied a LEFT JOIN instead of an INNER JOIN to highlight missing skill data. I then refined the output using STRING_AGG to consolidate skills into a single column, reducing row duplication and avoiding repetition of job title and average salary values.*



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
<br><br>



  ### 3. What are the most in demand skills for Data Analyst?
  I looked at all job postings, not just remote ones, to find the top 10 most in-demand data analysis skills based on how often they appear. This gives a clearer view of the most commonly required skills in the overall job market and what job seekers should focus on.

  
  ![Most in demand Data Analysis skills](/project_sql/images/top10skills.png)

<br><br>

*I ran this SQL query to analyze the most in-demand skills for Data Analyst roles. I joined the job postings table with the skills mapping tables to link each job to its required skills, then counted how often each skill appears across all Data Analyst job listings. After grouping by skill and sorting by demand count in descending order, I limited the results to the top 10 most frequently requested skills.*

```sql
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
  ```

<br><br>

### 4. What are the top skills based on salary for Data Analyst roles?
- I analyzed the average salary associated with each skill for Data Analyst roles, focusing only on positions with specified salary data, regardless of location. This helps reveal how different skills influence salary levels and identifies the most financially rewarding skills in the field. The results are limited to the top 10 highest-paying skills.
- Average salary can be misleading. Top paying skills appear in very few jobs. A small number of high-paying roles can significantly inflate the average salary.

| skills     | avg_salary | job_count |
|------------|------------|-------|
| svn        | 400000     | 1     |
| solidity   | 179000     | 1     |
| couchbase  | 160515     | 1     |
| datarobot  | 155486     | 1     |
| golang     | 155000     | 2     |
| mxnet      | 149000     | 2     |
| dplyr      | 147633     | 3     |
| vmware     | 147500     | 1     |
| terraform  | 146734     | 3     |
| twilio     | 138500     | 2     |

<br><br>
*I used this SQL query to find which skills are linked to the highest average salaries for Data Analyst roles. Job postings were joined with the skills tables to map each job to its required skills, and records with NULL salary values were excluded. The average salary per skill was then calculated along with the number of job postings. Results were grouped by skill, sorted by highest average salary, and limited to the top 10 highest-paying skills.*

```sql
SELECT 
    skills,
    ROUND (AVG(salary_year_avg), 0) AS avg_salary,
    COUNT (job_id) AS job_count
FROM job_postings_fact 
LEFT JOIN skills_job_dim USING (job_id) 
LEFT JOIN skills_dim USING (skill_id)
WHERE job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
--AND job_work_from_home IS TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 10;
```

<br><br>

### 5. What are the most optimal skills to learn? i.e High Demand & High Salary
I used this analysis to identify the most optimal skills for Data Analyst roles by combining demand (job count) and average salary. The data was filtered in two ways:

- All positions were analyzed to get a broad view of in-demand skills
- Remote positions with specified salaries were then used for a deeper focus on high-value opportunities

This helps highlight skills that offer both strong job security and higher financial reward, providing useful insight for Data Analyst career development.

- All positions (results limited to top 15)

    | skills      | demand_count | avg_salary |
    |-------------|-------------|------------|
    | sql         | 3083        | 96435      |
    | excel       | 2143        | 86419      |
    | python      | 1840        | 101512     |
    | tableau     | 1659        | 97978      |
    | r           | 1073        | 98708      |
    | power bi    | 1044        | 92324      |
    | word        | 527         | 82941      |
    | powerpoint  | 524         | 88316      |
    | sas         | 500         | 93707      |
    | sas         | 500         | 93707      |
    | sql server  | 336         | 96191      |
    | oracle      | 332         | 100964     |
    | azure       | 319         | 105400     |
    | aws         | 291         | 106440     |
    | go          | 288         | 97267      |


- Remote  Positions only  (results limited to top 10).

    This comparison highlights how skill demand changes when focusing only on remote roles. The demand_count reduces drastically as expected but the order of skills in demand stays relatively similar with only "looker" skill appearing in top 10 remote only roles which was missing from the above list of all positions.

    | skills     | demand_count | avg_salary |
    |------------|-------------|------------|
    | sql        | 398         | 97237      |
    | excel      | 256         | 87288      |
    | python     | 236         | 101397     |
    | tableau    | 230         | 99288      |
    | r          | 148         | 100499     |
    | power bi   | 110         | 97431      |
    | sas        | 63          | 98902      |
    | sas        | 63          | 98902      |
    | powerpoint | 58          | 88701      |
    | looker     | 49          | 103795     |

<br><br>

![Optimal Skills Remote](/project_sql/images/optimalskills_remote.png)

<br><br><br>

# 💡 What I learned

- Applied analytical thinking to understand business questions, interpret requirements, and develop effective query strategies.
- Developed a strong understanding of database schemas and how tables relate to one another.
- Learned how different SQL commands can be used to retrieve, filter, and refine data to answer specific questions.
- Gained experience using Common Table Expressions (CTEs) and subqueries to solve more complex problems involving multiple tables and datasets.
- Improved my understanding of aggregate and mathematical functions, and how they can be combined with other SQL functions to transform and analyze data.
- Learned how to create, modify, and alter database tables, while understanding the differences between structural changes (e.g., modifying table definitions) and non-structural changes (e.g., updating data).
- Developed an understanding of data types and how columns are defined when creating tables, including strings, numeric values, dates, timestamps, and other data formats.
- Gained practical experience with Git and GitHub, including version control, repository management, and synchronizing project files and updates between a local environment and GitHub.

<br><br><br>



# 📌 Conclusions 

1) What are the top paying jobs for Data Analyst?

    The top 10 highest-paying Data Analyst roles ranged from $184,000 to $650,000 per year. The highest-paying position offered $650,000, but its job title was listed simply as "Data Analyst", suggesting that some information may be missing from the posting. The unusually high salary indicates that the role may have included additional responsibilities, seniority, or specialized requirements that were not reflected in the job title alone.

2) What are the skills required for these high paying jobs?
    SQL (8 mentions), Python (7), and Tableau (6) were the most common skills among the highest-paying Data Analyst roles, highlighting the importance of database querying, programming, and data visualization. R appeared 4 times, while Snowflake, Pandas, and Excel each appeared 3 times, demonstrating the value of statistical analysis, modern data platforms, and spreadsheet skills. Cloud technologies such as Azure and AWS, along with tools like Power BI and Oracle, were also frequently requested. Notably, the two highest-paying jobs ($650,000 and $336,500) had no associated skill records, making their requirements difficult to assess.
3) What are the most in demand skills for Data Analyst?

    SQL was by far the most in-demand skill, followed by Excel, Python, Tableau, and Power BI, highlighting the importance of database querying, analysis, and visualization in Data Analyst roles. Traditional business tools such as PowerPoint and Word also appeared among the top skills, while R, SAS, and SAP remained valuable for statistical analysis and enterprise environments. Overall, the results suggest that a combination of technical, analytical, and business communication skills is highly sought after in the job market.

4) What are the top skills based on salary from Data Analyst?

    Average salary can be misleading. Skills such as SVN ($400k) and Solidity ($179k) likely appear in very few jobs. A small number of high-paying roles can significantly inflate the average salary.

5) What are the most optimal skills to learn? i.e High Demand & High Salary.

    SQL is the most important core skill for Data Analysts, showing the highest demand and strong average salary, making it the best overall combination of job availability and pay. Python, Tableau, and R also provide a strong balance of demand and salary, making them key skills for career growth. Excel is highly demanded but offers lower pay, indicating it is more of a baseline requirement. Higher-paying niche skills like Go, Hadoop, Snowflake, AWS, and Azure offer better salaries but appear in fewer roles, making them specialized rather than essential. Overall, the best strategy is to master core tools first, then build niche cloud and big data skills to increase earning potential.

    ### Final Recommendation

    To succeed as a Data Analyst, the best approach is to first build a strong foundation in core, high-demand skills such as SQL, Python, Tableau/Power BI, and Excel, as these consistently appear across the majority of job postings and ensure strong employability. Once these fundamentals are in place, focus on expanding into higher-paying and more specialized areas like cloud platforms (AWS, Azure), big data tools (Snowflake, Hadoop, Spark), and niche programming skills, which can significantly boost earning potential. Combining strong core analytics skills with modern data engineering and cloud technologies provides the best balance of job security, demand, and salary growth in the Data Analyst career path.


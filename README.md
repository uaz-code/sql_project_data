# **📊 Introduction**

This project analyzes the **Data Analyst job market**, examining which skills are most in demand and which are associated with 💰 **higher average salaries** within Data Analyst roles. By evaluating both 🚀 **demand** and salary trends, the analysis identifies the 🍳 **skills** that offer the strongest combination of job opportunities and earning potential for career development in Data Analytics.

SQL queries: [Project Data](/project_sql/)

Dataset used for this project: [SQL Course](https://lukebarousse.com/sql)

The main objectives of this project are to explore the Data Analyst job market and answer the following key questions:

  1. 💰What are the **top paying** jobs for Data Analyst?
  2. 🍳What are the **skills** required for these high paying jobs?
  3. What are the most **🔥in demand skills** for Data Analyst?
  4. What are the **top skills based on salary** from Data Analyst?
  5. What are the most **optimal skills** to learn (i.e., high demand and high salary)?

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
The analysis was conducted with a focus on the following **five core objectives:**

  ### 1. What are the top-paying remote jobs for Data Analyst?

  Analyzed Data Analyst job postings to identify the top **10 highest-paying** remote roles. Positions without salary information were excluded to ensure accurate salary comparisons and to gain insights into the roles offering the highest compensation.

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

#### 🧾 Query Summary
*I ran a query to pull the top 10 highest-paying Data Analyst jobs, joining company data to get company names, filtering out missing salaries, and sorting everything in descending order by average salary.*

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
<br>

#### Key Observations

- **Top-paying remote Data Analyst roles** offer salaries ranging from $184K to $650K annually.
- The highest-paying position is titled "Data Analyst" at Mantys with a salary of $650K, though the title alone may not fully reflect the role's seniority, responsibilities, or specialized requirements.
- Most of the other highest-paying positions are **senior or leadership-level** roles, such as Director and Principal Data Analyst positions.
- This suggests that advanced **expertise, specialized skills, and leadership** responsibilities are often associated with higher compensation in data analytics roles.**

<br><br>

  ### 2. What are the skills required for these high paying jobs?

This analysis builds on the previous table of the top 10 highest-paying remote Data Analyst roles by incorporating the associated **technical skill requirements**, highlighting the key competencies linked to **higher salaries** and helping job seekers prioritize skills for career growth.


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

#### 🧾 Query Summary
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
<br>

#### Key Observations

- **SQL, Python, and Tableau** were the most common skills among the **highest-paying Data Analyst roles**, highlighting the importance of data querying, programming,
    and visualization expertise.

- **R, Snowflake, Pandas, and Excel** also appeared frequently, showing the value of statistical analysis, modern data platforms, and spreadsheet proficiency.

- Cloud-related tools such as **Azure and AWS, along with Power BI and Oracle**,
    were present in several high-paying roles, indicating growing demand for data
    infrastructure and cloud skills.

- **The two highest-paying jobs ($650K and $336.5K)** had no associated skill records, so their compensation may have been influenced by factors not captured in the dataset, such as leadership responsibilities or specialized domain expertise.

<br><br>



  ### 3. What are the most in demand skills for Data Analyst?

  I looked at **all job postings**, not just remote ones, to find the **top 10 most in-demand data analysis skills** based on how often they appear. This gives a clearer view of the most commonly required **skills** in the overall job market and what job seekers should focus on.

  
#### Most in demand Data Analysis skills
![Most in demand Data Analysis skills](/project_sql/images/top10skills.png)

<br><br>

#### 🧾 Query Summary
*I ran this SQL query to analyze the most in-demand skills for Data Analyst roles. I joined the job postings table with the skills mapping tables to link each job to its required skills, then counted how often each skill appears across all Data Analyst job listings. After grouping by skill and sorting by demand count in descending order, I limited the results to the top 10 most frequently requested skills.*

```sql
SELECT 
    skills,
    COUNT (skills_job_dim.job_id) AS demand_count
FROM job_postings_fact 
LEFT JOIN skills_job_dim USING (job_id) 
LEFT JOIN skills_dim USING (skill_id)
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10;
```
<br>

#### Key Observations

- **SQL was the most in-demand skill**, appearing in 92,628 postings, making it a fundamental requirement for Data Analyst roles.
- **Excel and Python** were also highly sought after, highlighting the importance of data analysis and automation skills.
- **Tableau and Power BI** ranked among the top skills, reflecting strong demand for data visualization and reporting capabilities.
- Overall, employers value a combination of **querying, analysis, visualization, and business communication skills**.

<br><br>

### 4. What are the top skills based on salary for Data Analyst roles?

- I analyzed the **average salary** associated with each skill for Data Analyst roles, focusing only on positions with specified salary data, regardless of location. This helps reveal how different skills influence salary levels and identifies the most financially rewarding skills in the field. The results are limited to **the top 10 highest-paying skills**.


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

#### 🧾 Query Summary
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
<br>

#### Key Observations

- **Average salary** can be misleading, as niche skills like **SVN and Solidity** may have high averages due to very few job postings.
- Cloud and data engineering tools **(Snowflake, Databricks, Spark, AWS, Azure)** are strongly associated with higher salaries.
- Machine learning skills **(PyTorch, TensorFlow, Keras)** show strong earning potential in advanced analytics roles.
- **Python and its ecosystem (Pandas, NumPy)** generally outperform traditional BI tools like Tableau and Power BI in salary impact.
- **SQL remains a core foundational skill**, while office tools like **Excel, Word, and PowerPoint** are linked to lower-paying roles.

<br><br>

### 5. What are the most optimal skills to learn? i.e High Demand & High Salary

I used this analysis to identify the most **optimal skills for Data Analyst roles** by combining demand (job count) and average salary. The data was filtered in two ways:

- **All positions** with **specified salaries** were analyzed to get a broad view of in-demand skills
- **Remote positions** with **specified salaries** were then used for a deeper focus on high-value opportunities

This helps highlight **skills** that offer both **strong job security and higher financial reward**, providing useful insight for **Data Analyst career development**.

<br>

⚠️ IMPORTANT NOTE

Applying the filter 'salary_year_avg IS NOT NULL' significantly reduces the dataset size, as many job postings do not disclose salary information [Jump to Most in demand Data Analysis skills](#most-in-demand-data-analysis-skills). This results in lower overall demand counts and slightly different skill distributions compared to the full dataset. Therefore, salary-based analyses represent a filtered subset of the market focused only on postings with available yearly salary data. However, based on a comparison of skill rankings in both the full and filtered datasets, the overall order of top skills remains largely consistent.

- **All positions** (results limited to top 15)

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


- **Remote  Positions** only  (results limited to top 10).

    This comparison highlights how **skill** demand changes when focusing only on remote roles. The demand_count reduces drastically as expected but the order of skills in demand stays relatively similar with only **"looker"** skill appearing in top 10 remote only roles which was missing from the above list of all positions.

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

<br><br>

#### 🧾 Query Summary
*I used this query to analyze Data Analyst skills for all positions (top 15 results) and separately for remote-only roles (top 10 results). It calculates skill demand and average salary using two CTEs, then joins them to identify skills with strong demand and pay. The results are ranked by demand and salary to compare overall market trends with remote job trends.*


```sql
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
```
<br>

#### Key Observations

- **SQL is the most valuable core skill**, with the highest demand in both remote and overall roles and a strong average salary (~$97K), making it the best all-round skill.
- **Python, Tableau, and R** provide a strong balance of demand and salary, making them key complementary skills for Data Analysts.
- **Excel** is highly demanded but **lower paid**, indicating it is a baseline requirement rather than a high-value differentiator.
- Specialized skills like **Go, Hadoop, and Snowflake** offer the highest salaries, but have **low demand**, making them niche but lucrative.
- **The best strategy** is to focus first on **SQL + Python + BI tools**, then expand into cloud and big data technologies for higher earning potential.




<br><br><br>

# 💡 What I learned

- **Applied analytical thinking** to understand business questions, interpret requirements, and develop **effective query strategies**.
- Developed a strong understanding of **database schemas** and how tables **relate** to one another.
- Learned how different SQL commands can be used to **retrieve, filter, and refine data** to answer specific questions.
- Gained experience using Common Table Expressions **(CTEs) and subqueries** to solve more complex problems involving multiple tables and datasets.
- Improved my understanding of **aggregate and mathematical functions**, and how they can be combined with other **SQL functions** to transform and analyze data.
- Learned how to **create, modify, and alter database tables**, while understanding the differences between structural changes (e.g., modifying table definitions) and non-structural changes (e.g., updating data).
- Developed an understanding of **data types** and how columns are defined when creating tables, including **strings, integer, numeric values, dates, timestamps, and other data formats**.
- Gained practical experience with **Git and GitHub**, including version control, repository management, and synchronizing project files and updates between **a local environment and GitHub.**

<br><br><br>



# 📌 Conclusions 

**1) What are the top paying remote jobs for Data Analyst?**

 **The top 10 highest-paying remote Data Analyst** roles ranged from $184,000 to $650,000 per year. The **highest-paying position offered $650,000**, but its job title was listed simply as "Data Analyst", suggesting that some information may be missing from the posting. The unusually high salary indicates that the role may have included additional responsibilities, seniority, or specialized requirements that were not reflected in the job title alone.

**2) What are the skills required for these high paying jobs?**

 **SQL (8 mentions), Python (7), and Tableau (6)** were the most common skills among **the highest-paying Data Analyst roles**, highlighting the importance of database querying, programming, and data visualization. **R appeared 4 times, while Snowflake, Pandas, and Excel each appeared 3 times**, demonstrating the value of statistical analysis, modern data platforms, and spreadsheet skills. Cloud technologies such as **Azure and AWS, along with tools like Power BI and Oracle**, were also frequently requested. Notably, the two highest-paying jobs ($650,000 and $336,500) had no associated skill records, making their requirements difficult to assess.

**3) What are the most in demand skills for Data Analyst?**

 **SQL was by far the most in-demand skill, followed by Excel, Python, Tableau, and Power BI**, highlighting the importance of database querying, analysis, and visualization in Data Analyst roles. Traditional business tools such as **PowerPoint and Word** also appeared among the top skills, while **R, SAS, and SAP** remained valuable for statistical analysis and enterprise environments. Overall, the results suggest that a combination of **technical, analytical, and business communication skills** is highly sought after in the job market.

**4) What are the top skills based on salary from Data Analyst?**

 **Average salary** can be misleading. Skills such as **SVN ($400k) and Solidity ($179k)** likely appear in very few jobs. A small number of high-paying roles can significantly **inflate** the average salary.

**5) What are the most optimal skills to learn? i.e High Demand & High Salary.**

 **SQL is the most important core skill for Data Analysts**, showing the **highest demand and strong average salary**, making it the **best overall combination** of job availability and pay. **Python, Tableau, and R** also provide a strong balance of demand and salary, making them key skills for career growth. **Excel** is highly demanded but offers lower pay, indicating it is more of a baseline requirement. Higher-paying niche skills like **Go, Hadoop, Snowflake, AWS, and Azure** offer better salaries but appear in fewer roles, making them specialized rather than essential. **Overall, the best strategy** is to master **core tools first, then build niche cloud and big data skills** to increase earning potential.

<br>

### Final Recommendation

- **Build a strong core foundation** first by mastering essential Data Analyst skills such as **SQL, Python, Tableau/Power BI, and Excel**, since these appear most frequently across job postings and ensure strong employability across industries.
- Strengthen your data analysis and visualization capability by becoming proficient in tools like **Python libraries (Pandas, NumPy), Tableau, and Power BI**, which help translate raw data into meaningful insights for business decision-making.
- Once core skills are solid, move into high-demand cloud and data engineering tools such as **AWS, Azure, Snowflake, Spark, and Hadoop**, as these are strongly associated with **higher salaries** and more advanced analytics roles.
- Develop exposure to specialized or **niche** technologies like **Go, Databricks, and advanced big data frameworks**, which may have lower job volume but significantly **increase earning potential** in competitive roles.
- Focus on building a **balanced skill portfolio** combining core analytics + cloud + data engineering, as this combination offers the best mix of **job availability, salary growth, and long-term career** stability in the **Data Analyst field.**

<br><br><br>




 ## ⚠️ IMPORTANT NOTE

 - **A separate validation analysis** below was carried out **after noticing that applying the salary filter (salary_year_avg IS NOT NULL)** significantly reduced the dataset size. This led me to further explore the effect of this filtering using the skills and techniques developed earlier in the analysis, specifically to examine whether it introduced any noticeable divergence in skill demand patterns.

 - A key consideration in this analysis is the impact of filtering out records with **missing salary data (salary_year_avg IS NOT NULL)**. Since a significant portion of job postings do not include salary information, this **reduces the dataset size** and introduces a filtered view of the overall market.

- However, based on a comparison of skill rankings in both the full and filtered datasets, **the overall order of top skills remains largely consistent**. This suggests that missing salary values are likely distributed in **a relatively uniform manner**. A separate analysis** below further examines this distribution stability in depth to confirm whether the observed trends hold after filtering.

<br>

# Impact of Missing Salary Values on Skill Rankings

## ⚠️ Aim of This Validation Analysis

- To assess the impact of filtering job postings with missing salary data (**salary_year_avg IS NOT NULL**) on dataset size, composition, and overall structure.

- To determine whether removing salary-null records introduces **bias in skill demand rankings** or changes the overall skill hierarchy.

- To validate whether **high-demand and high-salary skill insights remain consistent** after filtering, ensuring conclusions are not affected by data exclusion.

- To check if missing salary values are **randomly distributed or concentrated in specific skill groups**, potentially skewing market interpretation.

- To compare skill distributions using **percentage-based normalization (SQL demand = 100% baseline)** and confirm whether skill rankings remain stable after adjustment.

<br><br>

### Skill Demand Comparison: Full vs Salary-Specified Jobs

| skills     | total_jobs | specified_jobs | relative_total (%) | relative_specified (%) |
|------------|------------|----------------|--------------------|-------------------------|
| sql        | 92628      | 3083           | 100.00             | 100.00                  |
| excel      | 67031      | 2143           | 72.37              | 69.51                   |
| python     | 57326      | 1840           | 61.89              | 59.68                   |
| tableau    | 46554      | 1659           | 50.26              | 53.81                   |
| r          | 30075      | 1073           | 32.47              | 34.80                   |
| power bi   | 39468      | 1044           | 42.61              | 33.86                   |
| sas        | 28068      | 1000           | 30.30              | 32.44                   |
| word       | 13591      | 527            | 14.67              | 17.09                   |
| powerpoint | 13848      | 524            | 14.95              | 17.00                   |

<br>

### Total jobs vs salary specified jobs
![Relative-total and relative_specified](/project_sql/images/relative_percentile.png)

<br><br>

### 🧾 Query Summary

*I reused and structured previous query outputs into two CTEs to compare skill demand across the full dataset and the salary-specified dataset.*

*I then joined both results on **skills** and added two additional columns — **relative_total** and **relative_specified** — by applying arithmetic SQL calculations to convert raw counts into percentage values, using **SQL as the reference baseline for relative comparisons**.*

*This was done to compare both **absolute counts and normalized percentages side by side**, allowing a clearer understanding of skill demand and any potential divergence between the two datasets.*

```sql
WITH all_jobs_total AS 
    (
    SELECT 
    skills,
    COUNT (DISTINCT skills_job_dim.job_id) AS total_jobs
    FROM job_postings_fact 
    LEFT JOIN skills_job_dim USING (job_id) 
    LEFT JOIN skills_dim USING (skill_id)
    WHERE job_title_short = 'Data Analyst'
    --AND job_no_degree_mention IS TRUE
    GROUP BY skills
    ORDER BY total_jobs DESC
    LIMIT 10
    ),

    jobs_with_salary_specified AS
    (
    SELECT 
    sd.skills,
    COUNT (DISTINCT sj.job_id) AS specified_jobs
    FROM job_postings_fact jpf
    LEFT JOIN skills_job_dim sj USING (job_id)
    LEFT JOIN skills_dim sd USING (skill_id)
    WHERE jpf.job_title_short = 'Data Analyst'
    AND jpf.salary_year_avg IS NOT NULL
    GROUP BY sd.skills
    ORDER BY specified_jobs DESC
    LIMIT 10
    )
SELECT
   all_jobs_total.skills,
   --all_jobs_total.total_jobs,
   --jobs_with_salary_specified.specified_jobs,
   ROUND ((all_jobs_total.total_jobs::NUMERIC / 92628) * 100, 2) AS relative_total,
   ROUND ((jobs_with_salary_specified.specified_jobs::NUMERIC / 3083) * 100, 2) AS relative_specified
FROM all_jobs_total
INNER JOIN jobs_with_salary_specified
USING (skills)
LIMIT 10; 
```
<br><br>

## Key Findings

- **The overall skill hierarchy remains largely stable** after applying the `salary_year_avg IS NOT NULL` filter. The top four skills (**SQL, Excel, Python, and Tableau**) retain the same ranking in both the full dataset and the salary-filtered dataset, suggesting that the filter does not fundamentally alter the highest-demand skills. 
- As is evident from the line graph above, a noticeable divergence can be seen only around the **‘Power BI’** skill, while for the rest of the skills the divergence is negligible.

- When demand is normalized using **SQL as a 100% baseline**, most skills maintain similar relative proportions. For example, **Excel** decreases only slightly from **72.37%** to **69.51%**, while **Python** changes from **61.89%** to **59.68%**, indicating strong consistency between the two datasets.

- **Power BI represents the most notable divergence.** In the full dataset, Power BI demand is **42.61%** of SQL demand, making it substantially more common than **R (32.47%)**. However, in the salary-filtered dataset, **Power BI drops to 33.86% while R increases to 34.80%**, resulting in **R overtaking Power BI** in the rankings. This is the largest shift observed and suggests that salary disclosure rates may differ across these skill categories.

- **Tableau** becomes slightly more prominent after filtering, increasing from **50.26%** to **53.81%** relative to SQL demand. Similarly, **SAS** rises from **30.30%** to **32.44%**, indicating a modest increase in representation among postings with available salary information.

- **Word** and **PowerPoint** show small increases in relative representation after filtering, rising from **14.67% → 17.09%** and **14.95% → 17.00%** respectively. While noticeable, these changes are not large enough to materially affect the overall skill hierarchy.

- Despite the substantial reduction in dataset size, **most skills preserve similar rankings and relative demand proportions**, providing evidence that missing salary values are not heavily concentrated within a small number of skill categories.

## Conclusion

- Although filtering for non-null salary values removes a significant portion of job postings, the resulting dataset continues to reflect the broader skill demand landscape reasonably well. 
- Apart from the **Power BI / R ranking reversal**, the relative demand patterns remain highly consistent. This suggests that the salary-filtered dataset is a **reasonably representative subset of the overall market**.
- The conclusions drawn from the optimal skills analysis remain **largely reliable and not significantly distorted by the exclusion of salary-null records**.



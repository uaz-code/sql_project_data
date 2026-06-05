
/*
⚠️ Aim of This Validation Analysis
- To evaluate the impact of filtering job postings with missing salary data using salary_year_avg
  IS NOT NULL, and understand how this reduces dataset size and changes overall data composition.
- To check whether removing salary-null records introduces bias in skill demand rankings, or if the 
  overall skill hierarchy remains stable compared to the full dataset.
- To validate whether the optimal skills identified (high demand + high salary) remain consistent 
  after filtering, ensuring the conclusions are not distorted by data exclusion.
- To assess if missing salary values are randomly distributed across skills or concentrated in 
  specific skill groups, which could skew interpretation of market demand.
- To compare skill distributions between full and filtered datasets using a percentage-based
  normalization approach, where SQL demand is set as a 100% baseline and other skills are measured
  relative to it.
- To determine whether this percentile-based comparison reveals any meaningful shifts in ranking 
  or whether the skill order remains largely stable even after normalization.
- To ensure the final insights on high-demand and high-value skills are robust, scalable, and not 
  dependent on absolute dataset size differences.
  */



WITH all_jobs_total AS 
    (
    SELECT 
    skills,
    COUNT (skills_job_dim.job_id) AS total_jobs
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
    COUNT(sj.job_id) AS specified_jobs
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



/*
Key Validation Findings
- The overall skill hierarchy remains largely stable after applying the salary_year_avg IS NOT NULL filter. 
  The top four skills (SQL, Excel, Python, and Tableau) retain the same ranking in both the full dataset and 
  the salary-filtered dataset, suggesting that the filter does not fundamentally alter the highest-demand skills.
- When demand is normalized using SQL as a 100% baseline, most skills maintain similar relative proportions. 
  For example, Excel decreases only slightly from 72.37% to 69.51%, while Python changes from 61.89% to 59.68%,
  indicating strong consistency between the two datasets.
- Power BI represents the most notable divergence. In the full dataset, Power BI demand is 42.61% of SQL demand, 
  making it substantially more common than R (32.47%). However, in the salary-filtered dataset, Power BI drops 
  to 33.86% while R increases to 34.80%, causing R to overtake Power BI in the rankings. This is the largest shift
  observed and suggests that salary disclosure rates may differ across these skill categories.
- Tableau becomes slightly more prominent after filtering, increasing from 50.26% to 53.81% relative to SQL demand.
  Similarly, SAS rises from 30.30% to 32.44%, indicating a modest increase in representation among postings with 
  available salary information.
- Word and PowerPoint show small increases in relative representation after filtering, rising from 14.67% → 17.09% 
  and 14.95% → 17.00% respectively. While noticeable, these changes are not large enough to materially affect the 
  overall skill hierarchy.
- Despite the substantial reduction in dataset size, most skills preserve similar rankings and relative demand 
  proportions, providing evidence that missing salary values are not heavily concentrated within a small number
  of skill categories.

Conclusion
Although filtering for non-null salary values removes a significant portion of job postings, the resulting dataset 
continues to reflect the broader skill demand landscape reasonably well. Apart from the Power BI / R ranking 
reversal, the relative demand patterns remain highly consistent. This suggests that the salary-filtered dataset 
is a reasonably representative subset of the overall market, and that the conclusions drawn from the optimal skills
analysis remain largely reliable and not significantly distorted by the exclusion of salary-null records.
*/

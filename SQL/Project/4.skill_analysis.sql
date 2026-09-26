--Q14. What are the most demanded skills?
SELECT
    s.skill,
    COUNT(js.skill_id) AS demand_count
FROM job_skills AS js
JOIN skills_dim AS s ON js.skill_id = s.skill_id
GROUP BY s.skill
ORDER BY demand_count DESC

--Q15. What are the most demanded skill categories?
SELECT
    s.skill_category,
    COUNT(js.skill_id) AS demand_count
FROM job_skills js
JOIN skills_dim s
ON js.skill_id = s.skill_id
GROUP BY s.skill_category
ORDER BY demand_count DESC;

--Q16. Which skills are associated with the highest salaries?
SELECT
    s.skill,
    COUNT(js.skill_id) AS skill_count,
    ROUND(AVG(jp.salary_avg), 2) AS avg_salary
FROM job_skills js
JOIN skills_dim s ON js.skill_id = s.skill_id
JOIN job_posting jp ON js.job_id = jp.job_id
GROUP BY s.skill
HAVING COUNT(js.skill_id) >= 3
ORDER BY avg_salary DESC;

SELECT * FROM skills_dim
SELECT * FROM job_skills
SELECT * FROM job_posting


--Q17. Which skill are most common for each job level?

WITH skills_count AS (
    SELECT
        jp.job_level,
        s.skill,
        COUNT(js.skill_id) AS job_count
    FROM job_skills js
    JOIN skills_dim s ON js.skill_id = s.skill_id
    JOIN job_posting jp ON js.job_id = jp.job_id
    GROUP BY jp.job_level, s.skill
)
SELECT
    job_level,
    skill,
    job_count
FROM (
    SELECT
        job_level,
        skill,
        job_count,
        ROW_NUMBER() OVER (PARTITION BY job_level ORDER BY job_count DESC) AS rank
FROM skills_count
)ranked
WHERE rank = 1;

-
--Q18. What skills are most associated with Data Analyst jobs?

SELECT
    s.skill,
    COUNT(js.skill_id) AS skill_count
FROM job_skills js
JOIN skills_dim s ON js.skill_id = s.skill_id
JOIN job_posting jp ON js.job_id = jp.job_id
WHERE job_short_title = 'Data Analyst'
GROUP BY s.skill
ORDER BY skill_count DESC

--Q18. What skills are most associated with Data Scientist jobs?

SELECT
    s.skill,
    COUNT(js.skill_id) AS skill_count
FROM job_skills js
JOIN skills_dim s ON js.skill_id = s.skill_id
JOIN job_posting jp ON js.job_id = jp.job_id
WHERE job_short_title = 'Data Scientist'
GROUP BY s.skill
ORDER BY skill_count DESC

--Q19. What skills are most associated with Data Analyst and Data Scientist jobs?
WITH role_skills AS (
    SELECT
        jp.job_short_title,
        s.skill,
        COUNT(DISTINCT js.job_id) AS job_count
    FROM job_posting jp
    JOIN job_skills js ON jp.job_id = js.job_id
    JOIN skills_dim s ON js.skill_id = s.skill_id
    WHERE jp.job_short_title IN ('Data Analyst', 'Data Scientist')
    GROUP BY jp.job_short_title, s.skill
),

role_counts AS (
    SELECT
        job_short_title,
        COUNT(*) AS total_jobs
    FROM job_posting
    WHERE job_short_title IN ('Data Analyst', 'Data Scientist')
    GROUP BY job_short_title
)

SELECT
    rsc.job_short_title,
    rsc.skill,
    rsc.job_count,
    rc.total_jobs,
    ROUND((rsc.job_count::decimal / rc.total_jobs) * 100, 2) AS skill_percentage
FROM role_skills rsc
JOIN role_counts rc ON rsc.job_short_title = rc.job_short_title
ORDER BY rsc.job_short_title, rsc.job_count DESC;

--Q20. Table comparison

WITH role_skills AS (
    SELECT
        jp.job_short_title,
        s.skill,
        COUNT(DISTINCT js.job_id) AS job_count
    FROM job_posting jp
    JOIN job_skills js ON jp.job_id = js.job_id
    JOIN skills_dim s ON js.skill_id = s.skill_id
    WHERE jp.job_short_title IN ('Data Analyst', 'Data Scientist')
    GROUP BY jp.job_short_title, s.skill
),

role_counts AS (
    SELECT
        job_short_title,
        COUNT(*) AS total_jobs
    FROM job_posting
    WHERE job_short_title IN ('Data Analyst', 'Data Scientist')
    GROUP BY job_short_title
),

skills_percentage AS (
    SELECT
        rsc.skill,
        rsc.job_short_title,
        ROUND((rsc.job_count::decimal / rc.total_jobs) * 100, 2) AS skill_percentage
    FROM role_skills rsc
    JOIN role_counts rc ON rsc.job_short_title = rc.job_short_title
)

SELECT
    skill,
    COALESCE(
        MAX(
            CASE
                WHEN job_short_title = 'Data Analyst'
                THEN skill_percentage
            END
        ),
        0
    ) AS data_analyst_pct,
    COALESCE(
        MAX(
            CASE
                WHEN job_short_title = 'Data Scientist'
                THEN skill_percentage
            END
        ),
        0
    ) AS data_scientist_pct,

    ROUND(
        COALESCE(
            MAX(
                CASE
                    WHEN job_short_title = 'Data Analyst'
                    THEN skill_percentage
                END
            ),
            0
        )
        -
        COALESCE(
            MAX(
                CASE
                    WHEN job_short_title = 'Data Scientist'
                    THEN skill_percentage
                END
            ),
            0
        ),
        2
    ) AS difference

FROM skills_percentage
GROUP BY skill
ORDER BY ABS(
    COALESCE(MAX(
            CASE
                WHEN job_short_title = 'Data Analyst'
                THEN skill_percentage
            END
        ),
        0
    )
    -
    COALESCE(
        MAX(
            CASE
                WHEN job_short_title = 'Data Scientist'
                THEN skill_percentage
            END
        ),
        0
    )
) DESC;


--Table comparison with skill percentage DA & DS
WITH da AS (
    SELECT 
        s.skill,
        COUNT(DISTINCT jp.job_id) AS da_jobs
    FROM job_skills js
    JOIN skills_dim s ON js.skill_id = s.skill_id
    JOIN job_posting jp ON js.job_id = jp.job_id
    WHERE jp.job_short_title IN ('Data Analyst')
    GROUP BY s.skill
),
ds AS (
    SELECT 
        s.skill,
        COUNT(DISTINCT jp.job_id) AS ds_jobs
    FROM job_skills js
    JOIN skills_dim s ON js.skill_id = s.skill_id
    JOIN job_posting jp ON js.job_id = jp.job_id
    WHERE jp.job_short_title IN ('Data Scientist')
    GROUP BY s.skill
),
totals AS (
    SELECT
        COUNT(*)
        FILTER (WHERE jp.job_short_title = 'Data Analyst') AS total_da,
        COUNT(*)
        FILTER (WHERE jp.job_short_title = 'Data Scientist') AS total_ds
    FROM job_posting jp
)

SELECT 
    COALESCE(da.skill, ds.skill) AS skill,
    COALESCE(da.da_jobs, 0) AS da_jobs,
    ROUND((COALESCE(da.da_jobs, 0) / totals.total_da) * 100, 2) AS da_percentage,
    COALESCE(ds.ds_jobs, 0) AS ds_jobs,
    ROUND((COALESCE(ds.ds_jobs, 0) / totals.total_ds) * 100, 2) AS ds_percentage
FROM da
FULL OUTER JOIN ds
    ON da.skill = ds.skill
CROSS JOIN totals
ORDER BY skill;
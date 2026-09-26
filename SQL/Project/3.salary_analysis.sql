--Q10. Which job types have the highest average salary?
SELECT
    job_short_title,
    ROUND(AVG(salary_avg), 2) AS avg_salary
FROM job_posting
GROUP BY job_short_title
ORDER BY avg_salary DESC;

--Q10. Which job titles have the highest average salary?
SELECT
    job_title,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_avg), 2) AS avg_salary
FROM job_posting
GROUP BY job_title
HAVING COUNT(*) >= 3
ORDER BY avg_salary DESC;

--Q11. Which industries pay the most?
SELECT
    industry,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_avg), 2) AS avg_salary
FROM job_posting
GROUP BY industry
HAVING COUNT(*) >= 3
ORDER BY avg_salary DESC;

--Q12. Does job level affect salary?
SELECT
    job_level,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_avg), 2) AS avg_salary
FROM job_posting
GROUP BY job_level
ORDER BY avg_salary DESC;

-- Q13. Which locations have the highest average salary?
SELECT
    location,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_avg), 2) AS avg_salary
FROM job_posting
GROUP BY location
HAVING COUNT(*) >= 3
ORDER BY avg_salary DESC;
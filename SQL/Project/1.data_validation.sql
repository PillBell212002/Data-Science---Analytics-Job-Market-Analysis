--Q1. How many job postings are there?
SELECT COUNT(*) AS total_rows FROM job_posting;
--ANS 672

SELECT * FROM job_posting
SELECT * FROM job_skills

--Q2. How many unique companies?
SELECT COUNT(DISTINCT company_name) AS total_companies FROM job_posting;
--ANS 432

--Q3. How many unique locations?
SELECT COUNT(DISTINCT location) AS total_locations FROM job_posting;
--ANS 207

--Q4. Are there duplicate job IDs?
SELECT
    job_id,
    COUNT(*) AS count
FROM job_posting
GROUP BY job_id
HAVING
    COUNT(*) > 1
--ANS 0

--Q5. How many jobs have no associated skills?
SELECT 
    COUNT(*) AS jobs_without_skills
FROM job_posting AS jp
LEFT JOIN job_skills AS js ON jp.job_id = js.job_id
WHERE js.skill_id IS NULL
--ANS 27

--
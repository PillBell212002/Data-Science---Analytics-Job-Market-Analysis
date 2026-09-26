--Q6. Which job titles are most common?
SELECT 
    job_title, 
    COUNT(*) AS job_count
FROM job_posting
GROUP BY job_title
ORDER BY job_count DESC
-- Insight:
-- Data Scientist is the most common job title with 337 postings,
-- significantly higher than Data Engineer (26 postings) which is the second most common.

--Q7. Which job levels have the most postings?
SELECT 
    job_level, 
    COUNT(*) AS job_count
FROM job_posting
GROUP BY job_level
ORDER BY job_count DESC
-- Insight:
-- The majority of job postings are for mid-level positions (Level 2) with 558 postings
-- followed by senior-level positions with 107 postings.

--Q8. Which locations have the most jobs?
SELECT 
    location, 
    COUNT(*) AS job_count
FROM job_posting
GROUP BY location
ORDER BY job_count DESC
-- Insight:
-- The top location for job postings is San Francisco, CA with 69 postings,
-- followed by New York, NY with 50 postings and Washington, DC with 26 postings

--Q9. Which industries are hiring the most?
SELECT 
    industry, 
    COUNT(*) AS job_count
FROM job_posting
GROUP BY industry
ORDER BY job_count DESC
-- Insight:
-- The top industry for job postings is Biotech & Pharmaceuticals with 66 postings,
-- closely followed by IT Services with 61 postings and Computer Hardware & Software with 57 postings


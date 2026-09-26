COPY job_posting
FROM '/Users/prithvi/Downloads/Prithvi/Python/Data Science & Analytics Job Market Analysis/Data/Clean_data/job_posting.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_skills
FROM '/Users/prithvi/Downloads/Prithvi/Python/Data Science & Analytics Job Market Analysis/Data/Clean_data/job_skills.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM '/Users/prithvi/Downloads/Prithvi/Python/Data Science & Analytics Job Market Analysis/Data/Clean_data/skill_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
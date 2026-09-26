-- Create job postings table with primary key
CREATE TABLE public.job_posting
(
    job_id INT PRIMARY KEY,
    job_title VARCHAR(150),
    rating DECIMAL(2,1),
    company_name VARCHAR(150),
    location VARCHAR(150),
    headquarters VARCHAR(150),
    size VARCHAR(150),
    founded INT,
    type_of_ownership VARCHAR(150),
    industry VARCHAR(150),
    sector VARCHAR(150),
    revenue VARCHAR(150),
    competitors VARCHAR(150),
    job_level VARCHAR(150),
    job_short_title VARCHAR(150),
    salary_min DECIMAL(10,2),
    salary_max DECIMAL(10,2),
    salary_avg DECIMAL(10,2)
);

-- Create skills_dim table with primary key
CREATE TABLE skills_dim
(
    skill_id INT PRIMARY KEY,
    skill VARCHAR(150) NOT NULL,
    skill_category VARCHAR(150) NOT NULL
);

-- Create job_skills table with a composite primary key and foreign keys
CREATE TABLE public.job_skills
(
    job_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (job_id,skill_id),
    FOREIGN KEY (job_id) REFERENCES public.job_posting (job_id),
    FOREIGN KEY (skill_id) REFERENCES public.skills_dim (skill_id)
);

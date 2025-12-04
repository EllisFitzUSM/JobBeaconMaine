USE `job_beacon_maine`;

CREATE TABLE Location_Lookup(
zip_code CHAR(5) PRIMARY KEY,
city VARCHAR(100),
county VARCHAR(100)
);

CREATE TABLE Jobs_Temp(
job_title VARCHAR(200),
employer_website VARCHAR(255),
employer_name VARCHAR(200),
location VARCHAR(200),
salary_min VARCHAR(20),
salary_max VARCHAR(20),
posted_at DATETIME,
application_url VARCHAR(255)
);

CREATE TABLE Jobs(
job_id INT PRIMARY KEY AUTO_INCREMENT,
employer_id INT,
recruiter_id INT,
application_url VARCHAR(300),
job_description VARCHAR(2000),
job_title VARCHAR(200),
salary_min VARCHAR(20),
salary_max VARCHAR(20),
remote_pref VARCHAR(10),
location_raw VARCHAR(200),
city VARCHAR(100),
county VARCHAR(100),
zip_code CHAR(5),
posted_at DATETIME,
expires_at DATETIME,
estimated_start_date DATETIME,
is_expired BOOL
);

CREATE TABLE Employer(
employer_id INT PRIMARY KEY AUTO_INCREMENT,
employer_name VARCHAR(200),
employer_culture VARCHAR(1000),
employer_website VARCHAR(255),
employer_industry CHAR(50)
);

ALTER TABLE jobs_temp ADD COLUMN city_name VARCHAR(100);

-- Extract city names from the messy location strings
SET SQL_SAFE_UPDATES = 0;

-- Now run your UPDATE
UPDATE jobs_temp 
SET city_name = TRIM(
    CASE 
        WHEN location LIKE 'Remote (%' THEN 
            SUBSTRING_INDEX(SUBSTRING_INDEX(location, '(', -1), ',', 1)
        WHEN location REGEXP '[0-9]{5}' THEN 
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(location, ',', -2), ',', 1))
        ELSE 
            SUBSTRING_INDEX(location, ',', 1)
    END
);

-- Re-enable safe mode after (optional)
SET SQL_SAFE_UPDATES = 1;

INSERT INTO employer (employer_name, employer_website)
SELECT DISTINCT 
    employer_name, 
    employer_website
FROM jobs_temp
WHERE employer_name IS NOT NULL
ORDER BY employer_name;


INSERT INTO jobs (
    job_title, 
    salary_min, 
    salary_max, 
    remote_pref,
    location_raw, 
    city, 
    county, 
    zip_code, 
    posted_at, 
    application_url, 
    employer_id
)
SELECT 
    jt.job_title,
    jt.salary_min,
    jt.salary_max,
    CASE 
        WHEN jt.location LIKE 'Remote%' THEN 'Remote'
        ELSE 'Office'
    END as remote_pref,
    jt.location,
    ll.city,
    ll.county,
    ll.zip_code,
    jt.posted_at,
    jt.application_url,
    e.employer_id
FROM jobs_temp jt
LEFT JOIN employer e 
    ON jt.employer_name = e.employer_name 
    AND jt.employer_website = e.employer_website
LEFT JOIN location_lookup ll 
    ON jt.city_name = ll.city;

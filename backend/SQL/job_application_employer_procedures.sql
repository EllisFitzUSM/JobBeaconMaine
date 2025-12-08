USE TEST;

-- Read job with employer 

DELIMITER $$
CREATE PROCEDURE read_job_employer(
    IN p_job_id INT,
    IN p_employer_id INT
)
BEGIN
    SELECT *
    FROM Jobs AS J
    JOIN Employer AS E ON J.employer_id = E.employer_id
    WHERE J.job_id = p_job_id
      AND E.employer_id = p_employer_id;
END $$
DELIMITER ;


-- READ Employer

DELIMITER $$
CREATE PROCEDURE read_employer(
    IN p_employer_id INT
)
BEGIN
    SELECT *
    FROM Employer
    WHERE employer_id = p_employer_id;
END $$
DELIMITER ;


-- ADD Employer

DELIMITER $$
CREATE PROCEDURE add_employer(
    IN p_employer_name VARCHAR(200),
    IN p_employer_culture VARCHAR(1000),
    IN p_employer_website VARCHAR(255),
    IN p_employer_industry CHAR(50)
)
BEGIN
    INSERT INTO Employer (employer_name, employer_culture, employer_website, employer_industry)
    VALUES (p_employer_name, p_employer_culture, p_employer_website, p_employer_industry);
END $$
DELIMITER ;


-- UPDATE Employer

DELIMITER $$
CREATE PROCEDURE update_employer(
    IN p_employer_id INT,
    IN p_employer_name VARCHAR(200),
    IN p_employer_culture VARCHAR(1000),
    IN p_employer_website VARCHAR(255),
    IN p_employer_industry CHAR(50)
)
BEGIN
    UPDATE Employer
    SET 
        employer_name = p_employer_name,
        employer_culture = p_employer_culture,
        employer_website = p_employer_website,
        employer_industry = p_employer_industry
    WHERE employer_id = p_employer_id;
END $$
DELIMITER ;


-- DELETE Employer

DELIMITER $$
CREATE PROCEDURE delete_employer(IN p_employer_id INT)
BEGIN
    DELETE FROM Employer
    WHERE employer_id = p_employer_id;
END $$
DELIMITER ;


-- ADD Job

DELIMITER $$
CREATE PROCEDURE add_job(
    IN p_employer_id INT,
    IN p_recruiter_id INT,
    IN p_application_url VARCHAR(300),
    IN p_job_description VARCHAR(2000),
    IN p_job_title VARCHAR(200),
    IN p_salary_min VARCHAR(20),
    IN p_salary_max VARCHAR(20),
    IN p_remote_pref VARCHAR(10),
    IN p_location_raw VARCHAR(200),
    IN p_city VARCHAR(100),
    IN p_county VARCHAR(100),
    IN p_zip_code CHAR(5),
    IN p_posted_at DATETIME,
    IN p_expires_at DATETIME,
    IN p_estimated_start_date DATETIME,
    IN p_is_expired BOOL
)
BEGIN
    INSERT INTO Jobs (
        employer_id, recruiter_id, application_url, job_description, job_title,
        salary_min, salary_max, remote_pref, location_raw, city, county, zip_code,
        posted_at, expires_at, estimated_start_date, is_expired
    )
    VALUES (
        p_employer_id, p_recruiter_id, p_application_url, p_job_description, p_job_title,
        p_salary_min, p_salary_max, p_remote_pref, p_location_raw, p_city, p_county, p_zip_code,
        p_posted_at, p_expires_at, p_estimated_start_date, p_is_expired
    );
END $$
DELIMITER ;


-- UPDATE Job

DELIMITER $$
CREATE PROCEDURE update_job(
    IN p_job_id INT,
    IN p_employer_id INT,
    IN p_recruiter_id INT,
    IN p_application_url VARCHAR(300),
    IN p_job_description VARCHAR(2000),
    IN p_job_title VARCHAR(200),
    IN p_salary_min VARCHAR(20),
    IN p_salary_max VARCHAR(20),
    IN p_remote_pref VARCHAR(10),
    IN p_location_raw VARCHAR(200),
    IN p_city VARCHAR(100),
    IN p_county VARCHAR(100),
    IN p_zip_code CHAR(5),
    IN p_posted_at DATETIME,
    IN p_expires_at DATETIME,
    IN p_estimated_start_date DATETIME,
    IN p_is_expired BOOL
)
BEGIN
    UPDATE Jobs
    SET
        employer_id = p_employer_id,
        recruiter_id = p_recruiter_id,
        application_url = p_application_url,
        job_description = p_job_description,
        job_title = p_job_title,
        salary_min = p_salary_min,
        salary_max = p_salary_max,
        remote_pref = p_remote_pref,
        location_raw = p_location_raw,
        city = p_city,
        county = p_county,
        zip_code = p_zip_code,
        posted_at = p_posted_at,
        expires_at = p_expires_at,
        estimated_start_date = p_estimated_start_date,
        is_expired = p_is_expired
    WHERE job_id = p_job_id;
END $$
DELIMITER ;


-- DELETE Job

DELIMITER $$
CREATE PROCEDURE delete_job(IN p_job_id INT)
BEGIN
    DELETE FROM Jobs
    WHERE job_id = p_job_id;
END $$
DELIMITER ;


-- READ Job Application

DELIMITER $$
CREATE PROCEDURE read_job_application(
    IN p_job_app_id INT
)
BEGIN
    SELECT *
    FROM Job_Application
    WHERE job_app_id = p_job_app_id;
END $$
DELIMITER ;


-- ADD Job Application

DELIMITER $$
CREATE PROCEDURE add_job_application(
    IN p_job_id INT,
    IN p_user_id INT,
    IN p_referred_by INT,
    IN p_status ENUM('External', 'Received', 'Under_Review', 'Interview_Scheduled', 'Rejected', 'Accepted')
)
BEGIN
    INSERT INTO Job_Application (job_id, user_id, referred_by, status)
    VALUES (p_job_id, p_user_id, p_referred_by, p_status);
END $$
DELIMITER ;


-- UPDATE Job Application

DELIMITER $$
CREATE PROCEDURE update_job_application(
    IN p_job_id INT,
    IN p_user_id INT,
    IN p_referred_by INT,
    IN p_status ENUM('External', 'Received', 'Under_Review', 'Interview_Scheduled', 'Rejected', 'Accepted')
)
BEGIN
    UPDATE Job_Application
    SET 
        referred_by = p_referred_by,
        status = p_status
    WHERE job_id = p_job_id
      AND user_id = p_user_id;
END $$
DELIMITER ;


-- DELETE Job Application

DELIMITER $$
CREATE PROCEDURE delete_job_application(
    IN p_job_id INT,
    IN p_user_id INT
)
BEGIN
    DELETE FROM Job_Application
    WHERE job_id = p_job_id
      AND user_id = p_user_id;
END $$
DELIMITER ;



-- GET ALL JOBS

DELIMITER $$
CREATE PROCEDURE get_jobs()
BEGIN
    SELECT *
    FROM Jobs;
END $$
DELIMITER ;


-- GET JOB BY ID

DELIMITER $$
CREATE PROCEDURE get_job_by_id(IN p_job_id INT)
BEGIN
    SELECT *
    FROM Jobs
    WHERE job_id = p_job_id;
END $$
DELIMITER ;


-- GET ALL EMPLOYERS
DELIMITER $$
CREATE PROCEDURE get_all_employers()
BEGIN
    SELECT *
    FROM Employer;
END $$
DELIMITER ;


-- GET ALL JOB APPLICATIONS
DELIMITER $$
CREATE PROCEDURE get_all_job_applications()
BEGIN
    SELECT *
    FROM Job_Application;
END $$
DELIMITER ;

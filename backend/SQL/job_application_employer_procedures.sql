USE `job_beacon_maine`;

DROP PROCEDURE IF EXISTS `sp_AddLocationLookup`;
DELIMITER $$
CREATE PROCEDURE `sp_AddLocationLookup`(
    IN `p_zip_code` CHAR(5),
    IN `p_city` VARCHAR(100),
    IN `p_county` VARCHAR(100)
)
BEGIN 
    INSERT INTO `Location_Lookup` (`zip_code`, `city`, `county`)
    VALUES (`p_zip_code`, `p_city`, `p_county`);
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetAllLocations`;
DELIMITER $$
CREATE PROCEDURE `sp_GetAllLocations`()
BEGIN 
    SELECT *
    FROM `Location_Lookup`;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetDistinctCities`;
DELIMITER $$
CREATE PROCEDURE `sp_GetDistinctCities`()
BEGIN 
    SELECT DISTINCT ll.city
    FROM `Location_Lookup` AS ll;
END $$
DELIMITER ;

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


/** I need to make an SQL procedure - jobmatchscore that matches a user with a job based on the users preferences, 
attributes and skills. The following tables are for user, job, 
and skilltables that link user and skill and user and skills and job.
Prompt for chatgpt 5.1
I changed the match score for remote preferences so it compared with the user preferences.
**/

DROP PROCEDURE IF EXISTS jobMatchScore;

DELIMITER $$

CREATE PROCEDURE jobMatchScore(IN p_user_id INT)
BEGIN
/************************************************************
* Load user preferences + location
************************************************************/
SELECT
u.City,
u.County,
u.Zip_Code,
sa.Remote_Pref,
sa.Salary_Min_Pref,
sa.Salary_Max_Pref
INTO
@u_city,
@u_county,
@u_zip,
@u_remote_pref,
@u_sal_min,
@u_sal_max
FROM user u
JOIN STUDENT_ALUM sa ON sa.User_ID = u.User_ID
WHERE u.User_ID = p_user_id;

-- Default salary preferences if missing
IF @u_sal_min IS NULL THEN SET @u_sal_min = 0; END IF;
IF @u_sal_max IS NULL THEN SET @u_sal_max = 999999; END IF;

/************************************************************
 * Create temporary results table
 ************************************************************/
DROP TEMPORARY TABLE IF EXISTS tmp_job_scores;

CREATE TEMPORARY TABLE tmp_job_scores (
    job_id INT,
    job_title VARCHAR(255),
    total_score DECIMAL(10,2),
    skills_score DECIMAL(10,2),
    location_score DECIMAL(10,2),
    remote_score DECIMAL(10,2),
    salary_score DECIMAL(10,2)
);

/************************************************************
 * Insert job match scores
 ************************************************************/
INSERT INTO tmp_job_scores (
    job_id, job_title, total_score,
    skills_score, location_score, remote_score, salary_score
)
SELECT
    j.job_id,
    j.job_title,

    /*************** TOTAL SCORE = skills + location + remote + salary ***************/
    (
        /* Skills Score (60 pts) */
        (
            CASE
                WHEN (SELECT COUNT(*) FROM REQUIRES_SKILL WHERE idJOB = j.job_id) = 0
                    THEN 0
                ELSE (
                    (SELECT COUNT(*)
                     FROM REQUIRES_SKILL rs
                     INNER JOIN HAS_SKILL hs ON hs.idSKILL = rs.idSKILL
                     WHERE rs.idJOB = j.job_id
                     AND hs.idUSER = p_user_id
                    ) * 60.0
                ) / (SELECT COUNT(*) FROM REQUIRES_SKILL WHERE idJOB = j.job_id)
            END
        )

        +

        /* Location Score (20 pts) */
        (
            CASE
                WHEN j.city = @u_city THEN 20
                WHEN j.county = @u_county THEN 15
                WHEN j.zip_code = @u_zip THEN 10
                ELSE 0
            END
        )

        +

        /* Remote Score (10 pts) */
        (
            CASE
                WHEN j.remote_pref = @u_remote_pref THEN 10
                WHEN @u_remote_pref = 'Remote' AND j.remote_pref = 'Hybrid' THEN 6
                WHEN @u_remote_pref = 'Hybrid' AND j.remote_pref IN ('Remote','Office') THEN 6
                WHEN @u_remote_pref = 'Office' AND j.remote_pref = 'Hybrid' THEN 6
                WHEN @u_remote_pref = 'Remote' AND j.remote_pref = 'Office' THEN 3
                WHEN @u_remote_pref = 'Office' AND j.remote_pref = 'Remote' THEN 3
                ELSE 0
            END
        )

        +

        /* Salary Score (10 pts) */
        (
            CASE
                WHEN j.salary_max >= @u_sal_min 
                 AND j.salary_min <= @u_sal_max THEN 10
                ELSE 4
            END
        )
    ) AS total_score,

    /*************** Subscores ***************/
    /* Skills */
    (
        CASE
            WHEN (SELECT COUNT(*) FROM REQUIRES_SKILL WHERE idJOB = j.job_id) = 0 THEN 0
            ELSE (
                (SELECT COUNT(*)
                 FROM REQUIRES_SKILL rs
                 INNER JOIN HAS_SKILL hs ON hs.idSKILL = rs.idSKILL
                 WHERE rs.idJOB = j.job_id
                 AND hs.idUSER = p_user_id
                ) * 60.0
            ) / (SELECT COUNT(*) FROM REQUIRES_SKILL WHERE idJOB = j.job_id)
        END
    ) AS skills_score,

    /* Location */
    (
        CASE
            WHEN j.city = @u_city THEN 20
            WHEN j.county = @u_county THEN 15
            WHEN j.zip_code = @u_zip THEN 10
            ELSE 0
        END
    ) AS location_score,

    /* Remote */
    (
        CASE
            WHEN j.remote_pref = @u_remote_pref THEN 10
            WHEN @u_remote_pref = 'Remote' AND j.remote_pref = 'Hybrid' THEN 6
            WHEN @u_remote_pref = 'Hybrid' AND j.remote_pref IN ('Remote','Office') THEN 6
            WHEN @u_remote_pref = 'Office' AND j.remote_pref = 'Hybrid' THEN 6
            WHEN @u_remote_pref = 'Remote' AND j.remote_pref = 'Office' THEN 3
            WHEN @u_remote_pref = 'Office' AND j.remote_pref = 'Remote' THEN 3
            ELSE 0
        END
    ) AS remote_score,

    /* Salary */
    (
        CASE
            WHEN j.salary_max >= @u_sal_min 
             AND j.salary_min <= @u_sal_max THEN 10
            ELSE 4
        END
    ) AS salary_score

FROM jobs j
WHERE j.is_expired = 0;

/************************************************************
 * Return results sorted by score
 ************************************************************/
SELECT *
FROM tmp_job_scores
ORDER BY total_score DESC;


END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE jobMatchScoreFilterSearch(
    IN p_city VARCHAR(100),
    IN p_remote_pref VARCHAR(20),
    IN p_min_salary INT,
    IN p_max_salary INT,
    IN p_skills_text TEXT
)
BEGIN
    DROP TEMPORARY TABLE IF EXISTS tmp_filter_scores;

    CREATE TEMPORARY TABLE tmp_filter_scores (
        job_id INT,
        job_title VARCHAR(255),
        employer_name VARCHAR(255),
        skills_score DECIMAL(10,2),
        location_score DECIMAL(10,2),
        remote_score DECIMAL(10,2),
        salary_score DECIMAL(10,2),
        total_score DECIMAL(10,2)
    );

    INSERT INTO tmp_filter_scores (job_id, job_title, employer_name,
                                   skills_score, location_score, remote_score,
                                   salary_score, total_score)
    SELECT 
        j.job_id,
        j.job_title,
        e.employer_name,

        -- SKILLS SCORE (60 pts)
        (
            SELECT 
                CASE 
                    WHEN p_skills_text IS NULL OR p_skills_text = '' THEN 0
                    ELSE (
                        SELECT COUNT(*)
                        FROM SKILL s
                        JOIN REQUIRES_SKILL js ON js.idSKILL = s.idSKILL
                        WHERE js.idJOB = j.job_id
                        AND FIND_IN_SET(LOWER(s.NAME), p_skills_text) > 0
                    ) * 10
                END
        ) AS skills_score,

        -- LOCATION SCORE (20 pts)
        (
            CASE 
                WHEN p_city IS NULL OR p_city = '' THEN 0
                WHEN j.city = p_city THEN 20 ELSE 0
            END
        ) AS location_score,

        -- REMOTE SCORE (10 pts)
        (
            CASE 
                WHEN p_remote_pref IS NULL OR p_remote_pref = '' THEN 0
                WHEN j.remote_pref = p_remote_pref THEN 10 ELSE 0
            END
        ) AS remote_score,

        -- SALARY SCORE (10 pts)
        (
            CASE
                WHEN p_min_salary IS NULL AND p_max_salary IS NULL THEN 0
                WHEN CAST(j.salary_min AS UNSIGNED) >= p_min_salary
                     AND CAST(j.salary_max AS UNSIGNED) <= p_max_salary THEN 10
                ELSE 0
            END
        ) AS salary_score,

        -- TOTAL SCORE
        (
            (
                CASE 
                    WHEN p_skills_text IS NULL OR p_skills_text = '' THEN 0
                    ELSE (
                        SELECT COUNT(*)
                        FROM SKILL s
                        JOIN REQUIRES_SKILL js ON js.idSKILL = s.idSKILL
                        WHERE js.idJOB = j.job_id
                        AND FIND_IN_SET(LOWER(s.NAME), p_skills_text) > 0
                    ) * 10
                END
            )
            +
            (CASE WHEN j.city = p_city THEN 20 ELSE 0 END)
            +
            (CASE WHEN j.remote_pref = p_remote_pref THEN 10 ELSE 0 END)
            +
            (
                CASE
                    WHEN p_min_salary IS NULL AND p_max_salary IS NULL THEN 0
                    WHEN CAST(j.salary_min AS UNSIGNED) >= p_min_salary
                         AND CAST(j.salary_max AS UNSIGNED) <= p_max_salary THEN 10
                    ELSE 0
                END
            )
        ) AS total_score

    FROM Jobs j
    LEFT JOIN Employer e ON j.employer_id = e.employer_id;

END $$

DELIMITER ;

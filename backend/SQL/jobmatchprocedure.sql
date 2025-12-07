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

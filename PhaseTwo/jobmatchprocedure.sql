I need to make an SQL procedure - jobmatchscore that matches a user with a job based on the users preferences, 
attributes and skills. The following tables are for user, job, 
and skilltables that link user and skill and user and skills and job.
Prompt for chatgpt 5.1

DELIMITER $$

CREATE PROCEDURE jobMatchScore(IN p_user_id INT)
BEGIN

    /************************************************************
     * Compute job match score as:
     *
     *   Skills Match (60 pts)
     *   Location Match (20 pts)
     *   Remote Preference Match (10 pts)
     *   Salary Match (10 pts)
     *
     ************************************************************/

    -- Temporary table to hold results
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
     * Preload user data
     ************************************************************/
    SELECT City, County, Zip_Code
    INTO @u_city, @u_county, @u_zip
    FROM STUDENT_ALUM
    WHERE User_ID = p_user_id;

    -- If a user has salary preferences, load them:
    SET @salary_pref_min = 0;
    SET @salary_pref_max = 999999;

    /************************************************************
     * Insert each job with computed component scores
     ************************************************************/
    INSERT INTO tmp_job_scores (job_id, job_title, total_score,
                                skills_score, location_score, remote_score, salary_score)
    SELECT
        j.Job_ID,
        j.JobTitle,

        -- TOTAL SCORE
        (
            -- Skills Score (60 pts)
            (
                (SELECT COUNT(*) 
                 FROM REQUIRES_SKILL rs WHERE rs.idJOB = j.Job_ID)
                > 0
                /* % skills matched = user skills matching job skills */
                * (
                    SELECT 
                        (COUNT(*) * 60.0) / 
                        (SELECT COUNT(*) FROM REQUIRES_SKILL rs2 WHERE rs2.idJOB = j.Job_ID)
                    FROM REQUIRES_SKILL rs
                    INNER JOIN HAS_SKILL hs 
                    ON hs.idSKILL = rs.idSKILL
                    WHERE hs.idUSER = p_user_id
                    AND rs.idJOB = j.Job_ID
                )
            )

            +

            -- Location Score (20 pts)
            (
                CASE
                    WHEN j.City   = @u_city   THEN 20
                    WHEN j.County = @u_county THEN 15
                    WHEN j.Zip_Code = @u_zip  THEN 10
                    ELSE 0
                END
            )

            +

            -- Remote Preference Score (10 pts)
            (
                CASE 
                    WHEN j.Remote_Pref = 'Remote' THEN 10
                    WHEN j.Remote_Pref = 'Hybrid' THEN 10
                    WHEN j.Remote_Pref = 'Office' THEN 10
                    ELSE 0
                END
            )

            +

            -- Salary Match Score (10 pts)
            (
                CASE 
                    WHEN j.Salary_Max >= @salary_pref_min 
                         AND j.Salary_Min <= @salary_pref_max THEN 10
                    ELSE 4
                END
            )
        ) AS total_score,

        -- Individual Subscores
        /* Skills score */
        (
            SELECT 
                CASE 
                    WHEN (SELECT COUNT(*) FROM REQUIRES_SKILL WHERE idJOB = j.Job_ID) = 0 THEN 0
                    ELSE (
                        (SELECT COUNT(*) 
                         FROM REQUIRES_SKILL rs
                         INNER JOIN HAS_SKILL hs 
                         ON hs.idSKILL = rs.idSKILL
                         WHERE hs.idUSER = p_user_id
                         AND rs.idJOB = j.Job_ID
                        ) * 60.0
                    ) / (SELECT COUNT(*) FROM REQUIRES_SKILL WHERE idJOB = j.Job_ID)
                END
        ) AS skills_score,

        /* Location */
        (
            CASE
                WHEN j.City   = @u_city   THEN 20
                WHEN j.County = @u_county THEN 15
                WHEN j.Zip_Code = @u_zip  THEN 10
                ELSE 0
            END
        ) AS location_score,

        /* Remote */
        (
            CASE 
                WHEN j.Remote_Pref = 'Remote' THEN 10
                WHEN j.Remote_Pref = 'Hybrid' THEN 7
                WHEN j.Remote_Pref = 'Office' THEN 3
                ELSE 0
            END
        ) AS remote_score,

        /* Salary */
        (
            CASE 
                WHEN j.Salary_Max >= @salary_pref_min 
                     AND j.Salary_Min <= @salary_pref_max THEN 10
                ELSE 4
            END
        ) AS salary_score

    FROM JOB j
    WHERE j.Is_Expired = 0;   -- Only active jobs

    /************************************************************
     * Return sorted result set
     ************************************************************/
    SELECT *
    FROM tmp_job_scores
    ORDER BY total_score DESC;

END $$

DELIMITER ;

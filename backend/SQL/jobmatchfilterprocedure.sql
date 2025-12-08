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
                        JOIN JOB_SKILL js ON js.idSKILL = s.idSKILL
                        WHERE js.job_id = j.job_id
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
                        JOIN JOB_SKILL js ON js.idSKILL = s.idSKILL
                        WHERE js.job_id = j.job_id
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

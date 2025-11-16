USE `job_beacon_maine`;

-- This is a procedure to create a job, and if its given a list of skills (semicolon-separated)
-- This code was generated with the help of ChatGPT. I could not do this on my own. 
DROP PROCEDURE IF EXISTS `sp_CreateJobWithSkills`;
CREATE PROCEDURE `sp_CreateJobWithSkills` (
    IN `p_employer_name` VARCHAR(200),
    IN `p_employer_website` VARCHAR(255),
    IN `p_job_title` VARCHAR(200),
    IN `p_job_description` VARCHAR(2000),
    IN `p_salary_min` VARCHAR(20),
    IN `p_salary_max` VARCHAR(20),
    IN `p_remote_pref` VARCHAR(10),
    IN `p_location_raw` VARCHAR(200),
    IN `p_city` VARCHAR(100),
    IN `p_county` VARCHAR(100),
    IN `p_zip_code` CHAR(5),
    IN `p_posted_at` DATETIME,
    IN `p_application_url` VARCHAR(300),
    IN `p_skill_list` TEXT          -- semicolon-separated list: "Java;Python;SQL"
)
BEGIN
    DECLARE `v_employer_id` INT;
    DECLARE `v_skill` VARCHAR(255);
    DECLARE `v_skill_id` INT;
    DECLARE `v_pos` INT DEFAULT 0;

    IF `p_employer_name` IS NULL OR `p_employer_name` = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employer name cannot be empty';
    END IF;

    IF `p_job_title` IS NULL OR `p_job_title` = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Job title cannot be empty';
    END IF;

    -- Check if there exists an employer id that matches the provided name AND website (to verify they are the exact same).
    SELECT `employer_id` INTO `v_employer_id`
    FROM `Employer`
    WHERE `employer_name` = `p_employer_name`
      AND (`employer_website` = `p_employer_website` OR `p_employer_website` IS NULL)
    LIMIT 1;

    -- Check if the employer is null, then we create a new one. 
    IF `v_employer_id` IS NULL THEN
        INSERT INTO `Employer` (`employer_name`, `employer_website`)
        VALUES (`p_employer_name`, `p_employer_website`);

        SET `v_employer_id` = LAST_INSERT_ID(); -- Properly reference the ID without needing to do another select from where etc.
    END IF;

    INSERT INTO `Jobs` (
        `employer_id`,
        `job_title`,
        `job_description`,
        `salary_min`,
        `salary_max`,
        `remote_pref`,
        `location_raw`,
        `city`,
        `county`,
        `zip_code`,
        `posted_at`,
        `application_url`,
        `is_expired`
    ) VALUES (
        `v_employer_id`,
        `p_job_title`,
        `p_job_description`,
        `p_salary_min`,
        `p_salary_max`,
        `p_remote_pref`,
        `p_location_raw`,
        `p_city`,
        `p_county`,
        `p_zip_code`,
        `p_posted_at`,
        `p_application_url`,
        FALSE
    );

    SET @job_id = LAST_INSERT_ID();

    -- Parse the skills (this is heavily ChatGPT assisted).
    skill_loop: LOOP
        SET v_pos = INSTR(p_skill_list, ';');

        IF v_pos = 0 THEN
            SET v_skill = TRIM(p_skill_list);
        ELSE
            SET v_skill = TRIM(LEFT(p_skill_list, v_pos - 1));
        END IF;

        -- Only process if skill is not empty
        IF v_skill <> '' THEN
            -- Find or create the skill
            SELECT idSKILL INTO v_skill_id
            FROM SKILL
            WHERE NAME = v_skill
            LIMIT 1;

            IF v_skill_id IS NULL THEN
                INSERT INTO SKILL (NAME)
                VALUES (v_skill);

                SET v_skill_id = LAST_INSERT_ID();
            END IF;

            -- Insert relation
            INSERT IGNORE INTO REQUIRES_SKILL (idJOB, idSKILL)
            VALUES (@job_id, v_skill_id);
        END IF;

        -- Break or move to next
        IF v_pos = 0 THEN
            LEAVE skill_loop;
        END IF;

        SET p_skill_list = SUBSTRING(p_skill_list, v_pos + 1);
    END LOOP;

END;
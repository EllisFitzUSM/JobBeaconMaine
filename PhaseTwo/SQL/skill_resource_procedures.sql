USE `job_beacon_maine`;

-- Create a skill
DROP PROCEDURE IF EXISTS `sp_CreateSkill`;
CREATE PROCEDURE `sp_CreateSkill` (
    IN `p_NAME` VARCHAR(255)
)
BEGIN
    IF `p_NAME` IS NULL OR `p_NAME` = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill name cannot be empty';
    END IF;

    IF EXISTS (SELECT 1 FROM `SKILL` WHERE `NAME` = `p_NAME`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill already exists';
    END IF;

    INSERT INTO `SKILL` (`NAME`)
    VALUES (`p_NAME`);
END;

-- Get all the skills in the database sorted alphabetically.
DROP PROCEDURE IF EXISTS `sp_GetAllSkillsSorted`;
CREATE PROCEDURE `sp_GetAllSkillsSorted`()
BEGIN
    SELECT * FROM `SKILL` ORDER BY `NAME` ASC;
END;

-- Procedure to get skills required for a specific job.
DROP PROCEDURE IF EXISTS `sp_GetSkillsForJob`;
CREATE PROCEDURE `sp_GetSkillsForJob` (
    IN `p_idJOB` INT
)
BEGIN
    SELECT `s.idSKILL`, `s.NAME`
    FROM `SKILL` s
    JOIN `REQUIRES_SKILL` r ON `idSKILL` = `r.idSKILL`
    WHERE `r.idSKILL` = `p_idJOB`
    ORDER BY `s.NAME`;
END;

-- Get students skills.
DROP PROCEDURE IF EXISTS `sp_GetStudentsSkills`;
CREATE PROCEDURE `sp_GetStudentsSkills` (
    IN `p_idUSER` INT
)
BEGIN
    SELECT `s.idSKILL`, `s.NAME`
    FROM `SKILL` s
    JOIN `REQUIRES_SKILL` r ON `idSKILL` = `r.idSKILL`
    WHERE `r.idSKILL` = `p_idJOB`
    ORDER BY `s.NAME`;
END;

-- Help with ChatGPT to make it so no silent failure occurs.
DROP PROCEDURE IF EXISTS `sp_AddSkillToStudent`;
CREATE PROCEDURE `sp_AddSkillToStudent` (
    IN `p_User_ID` INT,
    IN `p_idSKILL` INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM `STUDENT_ALUM` WHERE `idUSER` = `p_User_ID`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Student does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM SKILL WHERE Skill_ID = p_Skill_ID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill does not exist';
    END IF;

    IF EXISTS (
        SELECT 1 FROM HAS_SKILL 
        WHERE User_ID = p_User_ID AND Skill_ID = p_Skill_ID
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Student already has this skill';
    END IF;

    INSERT INTO HAS_SKILL (User_ID, Skill_ID)
    VALUES (p_User_ID, p_Skill_ID);
END;

-- Remove skill from student

-- Get skill by ID.
DROP PROCEDURE IF EXISTS `sp_GetSkillByID`;
CREATE PROCEDURE `sp_GetSkillByID` (
    IN `p_idSKILL` INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM `SKILL` WHERE `idSKILL` = `p_idSKILL`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill does not exist';
    END IF;

    SELECT * FROM `SKILL` WHERE `idSKILL` = `p_idSKILL`;
END;

-- Get skill by name.
DROP PROCEDURE IF EXISTS `sp_GetSkillByName`;
CREATE PROCEDURE `sp_GetSkillByName` (
    IN `p_NAME` VARCHAR(45)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM `SKILL` WHERE `NAME` = `p_NAME`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill does not exist';
    END IF;

    SELECT * FROM `SKILL` WHERE `NAME` = `p_NAME`;
END;
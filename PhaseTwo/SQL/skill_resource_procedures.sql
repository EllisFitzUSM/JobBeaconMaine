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

    -- Validates there is not already a skill with this name being referenced (though, it is unique. I am not sure the specifics for MySQL/SQL enforcement here).
    IF EXISTS (SELECT 1 FROM `SKILL` WHERE `NAME` = `p_NAME`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill already exists';
    END IF;

    INSERT INTO `SKILL` (`NAME`)
    VALUES (`p_NAME`);
END;

-- Read a skill by provided id.
DROP PROCEDURE IF EXISTS `sp_ReadSkillByID`;
CREATE PROCEDURE `sp_ReadSkillByID` (
    IN `p_idSKILL` INT
)
BEGIN
    SELECT *
    FROM `SKILL`
    WHERE `idSKILL` = `p_idSKILL`;
END;

-- Get the skill by its provided name (since it is indexed/is unique).
DROP PROCEDURE IF EXISTS `sp_ReadSkillByName`;
CREATE PROCEDURE `sp_ReadSkillByName` (
    IN `p_NAME` VARCHAR(255)
)
BEGIN
    SELECT *
    FROM `SKILL`
    WHERE `NAME` = `p_NAME`;
END;

-- Update a skill's name. This is rather dangerous or not recommended. You can imagine that there may be some instances where a skill is reference elsewhere assuming
-- the name it has is constant. But to stay in line with CRUD I am keeping it.
DROP PROCEDURE IF EXISTS `sp_UpdateSkill`;
CREATE PROCEDURE `sp_UpdateSkill` (
    IN `p_idSKILL` INT,
    IN `p_NAME` VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM `SKILL` WHERE `idSKILL` = `p_idSKILL`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill does not exist';
    END IF;

    IF `p_NAME` IS NULL OR `p_NAME` = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill name cannot be empty';
    END IF;

    -- This is important. Checks if a skill is already been given the name we choose to updart with this.
    IF EXISTS (
        SELECT 1 FROM `SKILL`
        WHERE `NAME` = `p_NAME` AND `idSKILL` <> `p_idSKILL`
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Another skill with this name already exists';
    END IF;

    UPDATE `SKILL`
    SET `NAME` = `p_NAME`
    WHERE `idSKILL` = `p_idSKILL`;
END;

-- Delete a skill by the provided ID if it exists.
DROP PROCEDURE IF EXISTS `sp_DeleteSkill`;
CREATE PROCEDURE `sp_DeleteSkill` (
    IN `p_idSKILL` INT
)
BEGIN
    DELETE FROM `SKILL`
    WHERE `idSKILL` = `p_idSKILL`;
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

-- Adds a skill to a student
DROP PROCEDURE IF EXISTS `sp_AddSkillToStudent`;
CREATE PROCEDURE `sp_AddSkillToStudent` (
    IN `p_idUSER` INT,
    IN `p_idSKILL` INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM `STUDENT_ALUM` WHERE `User_ID` = `p_idUSER`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Student does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM `SKILL` WHERE `idSKILL` = `p_idSKILL`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill does not exist';
    END IF;

    IF EXISTS (
        SELECT 1 FROM `HAS_SKILL`
        WHERE `idUSER` = `p_idUSER` AND `idSKILL` = `p_idSKILL`
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Student already has this skill';
    END IF;

    INSERT INTO `HAS_SKILL` (`idUSER`, `idSKILL`)
    VALUES (`p_idUSER`, `p_idSKILL`);
END;

-- Removes a skill from a student (e.g, they want to specialize in something different.)
DROP PROCEDURE IF EXISTS `sp_RemoveSkillFromStudent`;
CREATE PROCEDURE `sp_RemoveSkillFromStudent` (
    IN `p_idUSER` INT,
    IN `p_idSKILL` INT
)
BEGIN
    DELETE FROM `HAS_SKILL`
    WHERE `idUSER` = `p_idUSER` AND `idSKILL` = `p_idSKILL`;
END;


-- Creates a user
DROP PROCEDURE IF EXISTS `sp_CreateResource`;
CREATE PROCEDURE `sp_CreateResource` (
    IN `p_URL` VARCHAR(255)
)
BEGIN
    IF `p_URL` IS NULL OR `p_URL` = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Resource URL cannot be empty';
    END IF;

    INSERT INTO `RESOURCE` (`URL`)
    VALUES (`p_URL`);
END;

-- Read a resource by provided id.
DROP PROCEDURE IF EXISTS `sp_ReadResourceByID`;
CREATE PROCEDURE `sp_ReadResourceByID` (
    IN `p_idRESOURCE` INT
)
BEGIN
    SELECT *
    FROM `RESOURCE`
    WHERE `idRESOURCE` = `p_idRESOURCE`;
END;

-- Update a resource's URL if necessary.
DROP PROCEDURE IF EXISTS `sp_UpdateResource`;
CREATE PROCEDURE `sp_UpdateResource` (
    IN `p_idRESOURCE` INT,
    IN `p_URL` VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM `RESOURCE` WHERE `idRESOURCE` = `p_idRESOURCE`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Resource does not exist';
    END IF;

    IF `p_URL` IS NULL OR `p_URL` = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Resource URL cannot be empty';
    END IF;

    UPDATE `RESOURCE`
    SET `URL` = `p_URL`
    WHERE `idRESOURCE` = `p_idRESOURCE`;
END;

-- Delete a resource by the provided ID.
DROP PROCEDURE IF EXISTS `sp_DeleteResource`;
CREATE PROCEDURE `sp_DeleteResource` (
    IN `p_idRESOURCE` INT
)
BEGIN
    DELETE FROM `RESOURCE`
    WHERE `idRESOURCE` = `p_idRESOURCE`;
END;

-- Link a resource to a specified skill.
DROP PROCEDURE IF EXISTS `sp_CreateResourceToSkill`;
CREATE PROCEDURE `sp_CreateResourceToSkill` (
    IN `p_idRESOURCE` INT,
    IN `p_idSKILL` INT
)
BEGIN
    -- Validate the resource even exists.
    IF NOT EXISTS (SELECT 1 FROM `RESOURCE` WHERE `idRESOURCE` = `p_idRESOURCE`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Resource does not exist';
    END IF;

    -- Validate the skill even exists.
    IF NOT EXISTS (SELECT 1 FROM `SKILL` WHERE `idSKILL` = `p_idSKILL`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill does not exist';
    END IF;

    IF EXISTS (
        SELECT 1 FROM `SKILL_RESOURCE`
        WHERE `idRESOURCE` = `p_idRESOURCE` AND `idSKILL` = `p_idSKILL`
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Resource is already linked to this skill';
    END IF;

    INSERT INTO `SKILL_RESOURCE` (`idRESOURCE`, `idSKILL`)
    VALUES (`p_idRESOURCE`, `p_idSKILL`);
END;

-- Remove a resource from a specified skill. The rationale here is that a resource may become outdated or irrelevant to a skill, and better represented with others. 
DROP PROCEDURE IF EXISTS `sp_RemoveResourceFromSkill`;
CREATE PROCEDURE `sp_RemoveResourceFromSkill` (
    IN `p_idRESOURCE` INT,
    IN `p_idSKILL` INT
)
BEGIN
    DELETE FROM `SKILL_RESOURCE`
    WHERE `idRESOURCE` = `p_idRESOURCE`
    AND `idSKILL` = `p_idSKILL`;
END;

-- Get all resources for a specific skill.
DROP PROCEDURE IF EXISTS `sp_GetResourcesForSkill`;
CREATE PROCEDURE `sp_GetResourcesForSkill` (
    IN `p_idSKILL` INT
)
BEGIN
    SELECT r.`idRESOURCE`, r.`URL`
    FROM `RESOURCE` r
    JOIN `SKILL_RESOURCE` sr ON sr.`idRESOURCE` = r.`idRESOURCE`
    WHERE sr.`idSKILL` = `p_idSKILL`
    ORDER BY r.`URL`;
END;

-- Adds a required skill to a job.
DROP PROCEDURE IF EXISTS `sp_AddRequiredSkillToJob`;
CREATE PROCEDURE `sp_AddRequiredSkillToJob` (
    IN `p_idJOB` INT,
    IN `p_idSKILL` INT
)
BEGIN
    -- Validates the job even exists
    IF NOT EXISTS (SELECT 1 FROM `Jobs` WHERE `job_id` = `p_idJOB`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Job does not exist';
    END IF;

    -- Validates the skill even exists
    IF NOT EXISTS (SELECT 1 FROM `SKILL` WHERE `idSKILL` = `p_idSKILL`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Skill does not exist';
    END IF;

    -- Validates that the job does not already require this skill
    IF EXISTS (
        SELECT 1 FROM `REQUIRES_SKILL`
        WHERE `idJOB` = p_idJOB AND `idSKILL` = `p_idSKILL`
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Job already requires this skill';
    END IF;

    INSERT INTO `REQUIRES_SKILL` (`idJOB`, `idSKILL`)
    VALUES (`p_idJOB`, `p_idSKILL`);
END;

DROP PROCEDURE IF EXISTS `sp_RemoveRequiredSkillFromJob`;
CREATE PROCEDURE `sp_RemoveRequiredSkillFromJob` (
    IN `p_idJOB` INT,
    IN `p_idSKILL` INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM `REQUIRES_SKILL`
        WHERE `idJOB` = `p_idJOB` AND `idSKILL` = `p_idSKILL`
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Job does not require this skill';
    END IF;

    DELETE FROM `REQUIRES_SKILL`
    WHERE `idJOB` = `p_idJOB` AND `idSKILL` = `p_idSKILL`;
END;

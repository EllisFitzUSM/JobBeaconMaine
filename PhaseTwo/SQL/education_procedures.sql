USE `job_beacon_maine`;

-- This is a basic create education, with the insitute name provided. If the institue already exists, the new education references it.
-- If the institue does not exist, an error is raised (currently), but ideally more checks would occur to verify the institute is in Maine.
DROP PROCEDURE IF EXISTS `sp_CreateEducation`;
CREATE PROCEDURE `sp_CreateEducation` (
    IN `p_idUSER` INT,
    IN `p_HIGH_INST_NAME` VARCHAR(55),
    IN `p_DEGREE` VARCHAR(55),
    IN `p_GRAD_DATE` DATETIME
)
BEGIN
    DECLARE v_inst_id INT;

    -- Validate student exists
    IF NOT EXISTS (SELECT 1 FROM `STUDENT_ALUM` WHERE `User_ID` = `p_idUSER`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Student does not exist';
    END IF;

    -- Validate Institute Name is not empty.
    IF `p_HIGH_INST_NAME` IS NULL OR `p_HIGH_INST_NAME` = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Higher education institute name cannot be empty';
    END IF;

    -- Validate Degree exists in the allowed types.
    IF `p_DEGREE` NOT IN ('Associate''s', 'Bachelor''s', 'Master''s', 'Doctorate') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid degree type';
    END IF;

    -- Validate Grad Date
    IF `p_GRAD_DATE` IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Graduation date cannot be null';
    END IF;

    -- Look up the institute ID by name
    SELECT `idHIGHER_EDUCATION_INSTITUTE`
    INTO v_inst_id -- Temporary variable for error checking. 
    FROM `HIGHER_EDUCATION_INSTITUTE`
    WHERE `NAME` = p_HIGH_INST_NAME;

    IF v_inst_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Higher education institute does not exist';
    END IF;

    -- Insert into EDUCATION
    INSERT INTO `EDUCATION` (
        `idEDUCATION`,
        `DEGREE`,
        `GRAD_DATE`,
        `idUSER`,
        `idHIGHER_EDUCATION_INSTITUTE`
    )
    VALUES (
        NULL, -- AUTO_INCREMENT
        `p_DEGREE`,
        `p_GRAD_DATE`,
        `p_idUSER`,
        v_inst_id
    );
END;

-- This gets all the education entries that a user has. It is for business logic, so the institue name is retrieved instead of the id.
DROP PROCEDURE IF EXISTS `sp_ReadEducationByUser`;
CREATE PROCEDURE `sp_ReadEducationByUser` (
    IN `p_idUSER` INT
)
BEGIN
    SELECT 
        e.`idEDUCATION`,
        e.`DEGREE`,
        e.`GRAD_DATE`,
        h.`NAME` AS `INSTITUTE_NAME`
    FROM `EDUCATION` e
    JOIN `HIGHER_EDUCATION_INSTITUTE` h
      ON h.`idHIGHER_EDUCATION_INSTITUTE` = e.`idHIGHER_EDUCATION_INSTITUTE`
    WHERE e.`idUSER` = p_idUSER;
END;

-- Simple update of education. In case the users graduation date changed etc.
DROP PROCEDURE IF EXISTS `sp_UpdateEducation`;
CREATE PROCEDURE `sp_UpdateEducation` (
    IN `p_idEDUCATION` INT,
    IN `p_DEGREE` VARCHAR(55),
    IN `p_GRAD_DATE` DATETIME
)
BEGIN
    -- Validate education record exists at all.
    IF NOT EXISTS (SELECT 1 FROM `EDUCATION` WHERE `idEDUCATION` = `p_idEDUCATION`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Education record does not exist';
    END IF;

    -- Validate degree exists in the allowed types. 
    IF `p_DEGREE` NOT IN ('Associate''s', 'Bachelor''s', 'Master''s', 'Doctorate') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid degree type';
    END IF;

    UPDATE `EDUCATION`
    SET
        `DEGREE` = `p_DEGREE`,
        `GRAD_DATE` = `p_GRAD_DATE`
    WHERE `idEDUCATION` = `p_idEDUCATION`;
END;


-- Deletes an education by its specified ID (assumed to be used in tandem with GetEducationByUser).
DROP PROCEDURE IF EXISTS `sp_DeleteEducation`;
CREATE PROCEDURE `sp_DeleteEducation` (
    IN `p_idEDUCATION` INT
)
BEGIN
    DELETE FROM `EDUCATION`
    WHERE `idEDUCATION` = p_idEDUCATION;
END;

-- Create of Higher Education Institute (in Maine ofc).
DROP PROCEDURE IF EXISTS `sp_CreateHigherEducationInstitute`;
CREATE PROCEDURE `sp_CreateHigherEducationInstitute` (
    IN `p_NAME` VARCHAR(55)
)
BEGIN
    -- Validate name
    IF `p_NAME` IS NULL OR `p_NAME` = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Institute name cannot be empty';
    END IF;

    -- Validate there are no duplicates
    IF EXISTS (
        SELECT 1 FROM `HIGHER_EDUCATION_INSTITUTE`
        WHERE `NAME` = `p_NAME`
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Institute already exists';
    END IF;

    INSERT INTO `HIGHER_EDUCATION_INSTITUTE` (
        `idHIGHER_EDUCATION_INSTITUTE`,
        `NAME`
    )
    VALUES (
        NULL,
        `p_NAME`
    );
END;

-- Read higher education insiute with provided id.
DROP PROCEDURE IF EXISTS `sp_ReadHigherEducationInstitute`;
CREATE PROCEDURE `sp_ReadHigherEducationInstitute` (
    IN `p_idHIGH_INST` INT
)
BEGIN
    SELECT *
    FROM `HIGHER_EDUCATION_INSTITUTE`
    WHERE `idHIGHER_EDUCATION_INSTITUTE` = `p_idHIGH_INST`;
END;

-- Read all higher education institutes.
DROP PROCEDURE IF EXISTS `sp_ReadAllHigherEducationInstitutes`;
CREATE PROCEDURE `sp_ReadAllHigherEducationInstitutes` ()
BEGIN
    SELECT 
        `idHIGHER_EDUCATION_INSTITUTE`,
        `NAME`
    FROM `HIGHER_EDUCATION_INSTITUTE`
    ORDER BY `NAME`;
END;

-- Update the higher education institute based on provided id.
DROP PROCEDURE IF EXISTS `sp_UpdateHigherEducationInstitute`;
CREATE PROCEDURE `sp_UpdateHigherEducationInstitute` (
    IN `p_idHIGH_INST` INT,
    IN `p_NAME` VARCHAR(55)
)
BEGIN
    -- Validate existence
    IF NOT EXISTS (
        SELECT 1 FROM `HIGHER_EDUCATION_INSTITUTE`
        WHERE `idHIGHER_EDUCATION_INSTITUTE` = `p_idHIGH_INST`
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Institute does not exist';
    END IF;

    -- Validate name
    IF `p_NAME` IS NULL OR `p_NAME` = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Institute name cannot be empty';
    END IF;

    -- Validate no duplicate names
    IF EXISTS (
        SELECT 1 FROM `HIGHER_EDUCATION_INSTITUTE`
        WHERE `NAME` = `p_NAME`
          AND `idHIGHER_EDUCATION_INSTITUTE` <> `p_idHIGH_INST`
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Institute name already exists';
    END IF;

    UPDATE `HIGHER_EDUCATION_INSTITUTE`
    SET `NAME` = `p_NAME`
    WHERE `idHIGHER_EDUCATION_INSTITUTE` = `p_idHIGH_INST`;
END;

-- Delete a higher education institue by its id.
DROP PROCEDURE IF EXISTS `sp_DeleteHigherEducationInstitute`;
CREATE PROCEDURE `sp_DeleteHigherEducationInstitute` (
    IN `p_idHIGH_INST` INT
)
BEGIN
    DELETE FROM `HIGHER_EDUCATION_INSTITUTE`
    WHERE `idHIGHER_EDUCATION_INSTITUTE` = `p_idHIGH_INST`;
END;

USE `job_beacon_maine`;

DELIMITER $$

CREATE PROCEDURE `sp_CreateEducation` (
    IN `p_User_ID` INT,
    IN p_University VARCHAR(55),
    IN p_Degree VARCHAR(255),
    IN p_Graduation_Date DATE
)
BEGIN
    -- Validate input
    IF NOT EXISTS (SELECT 1 FROM `STUDENT_ALUM` WHERE `User_ID` = `p_User_ID`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Student does not exist';
    END IF;

    IF p_University IS NULL OR p_University = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'University cannot be empty';
    END IF;

    IF p_Degree IS NULL OR p_Degree = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Degree cannot be empty';
    END IF;

    IF p_Graduation_Date IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Graduation date cannot be null';
    END IF;

    -- Insert
    INSERT INTO EDUCATION (User_ID, University, Degree, Graduation_Date, Is_Graduated)
    VALUES (
        p_User_ID,
        p_University,
        p_Degree,
        p_Graduation_Date,
        CASE WHEN p_Graduation_Date <= CURDATE() THEN TRUE ELSE FALSE END
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_GetEducationByID (
    IN p_Education_ID INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM EDUCATION WHERE Education_ID = p_Education_ID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Education record does not exist';
    END IF;

    SELECT * 
    FROM EDUCATION
    WHERE Education_ID = p_Education_ID;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_GetEducationByUser (
    IN p_User_ID INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM STUDENT_ALUM WHERE User_ID = p_User_ID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Student does not exist';
    END IF;

    SELECT * 
    FROM EDUCATION
    WHERE User_ID = p_User_ID
    ORDER BY Graduation_Date DESC;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_UpdateEducation (
    IN p_Education_ID INT,
    IN p_University VARCHAR(255),
    IN p_Degree VARCHAR(255),
    IN p_Graduation_Date DATE
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM EDUCATION WHERE Education_ID = p_Education_ID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Education record does not exist';
    END IF;

    IF p_University IS NULL OR p_University = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'University cannot be empty';
    END IF;

    IF p_Degree IS NULL OR p_Degree = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Degree cannot be empty';
    END IF;

    IF p_Graduation_Date IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Graduation date cannot be null';
    END IF;

    UPDATE EDUCATION
    SET 
        University = p_University,
        Degree = p_Degree,
        Graduation_Date = p_Graduation_Date,
        Is_Graduated = CASE WHEN p_Graduation_Date <= CURDATE() THEN TRUE ELSE FALSE END
    WHERE Education_ID = p_Education_ID;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_DeleteEducation (
    IN p_Education_ID INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM EDUCATION WHERE Education_ID = p_Education_ID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Education record does not exist';
    END IF;

    -- Remove HAS_EDUCATION relationships if any (optional if FK CASCADE exists)
    DELETE FROM HAS_EDUCATION 
    WHERE Education_ID = p_Education_ID;

    DELETE FROM EDUCATION
    WHERE Education_ID = p_Education_ID;
END$$

DELIMITER ;
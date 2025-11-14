DELIMITER $$

CREATE PROCEDURE AllSkillsSorted()
BEGIN
    SELECT * FROM SKILL ORDER BY Skill_Name ASC;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE GetSkillsForJob (
    IN p_Job_ID INT
)
BEGIN
    SELECT s.Skill_ID, s.Skill_Name
    FROM SKILL s
    JOIN REQUIRES_SKILL r ON s.Skill_ID = r.Skill_ID
    WHERE r.Job_ID = p_Job_ID
    ORDER BY s.Skill_Name;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_AddSkillToStudent (
    IN p_User_ID INT,
    IN p_Skill_ID INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM STUDENT_ALUM WHERE User_ID = p_User_ID) THEN
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
END$$

DELIMITER ;
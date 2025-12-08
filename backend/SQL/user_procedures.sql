USE job_beacon_maine;

-- Clean up any existing test data
DELETE FROM STUDENT_ALUM WHERE User_ID = 1;
DELETE FROM RECRUITER WHERE User_ID = 1;
DELETE FROM USER WHERE User_ID = 1;

-- Drop existing procedures if they exist
DROP PROCEDURE IF EXISTS AddUser;
DROP PROCEDURE IF EXISTS UpdateUser;
DROP PROCEDURE IF EXISTS RemoveUser;
DROP PROCEDURE IF EXISTS AddStudentAlum;
DROP PROCEDURE IF EXISTS UpdateStudentAlum;
DROP PROCEDURE IF EXISTS RemoveStudentAlum;
DROP PROCEDURE IF EXISTS AddRecruiter;
DROP PROCEDURE IF EXISTS RemoveRecruiter;

-- =====================================================
-- USER PROCEDURES
-- =====================================================

-- Add a new user to the database
DELIMITER $$
CREATE PROCEDURE AddUser(
    IN p_First_Name VARCHAR(50),
    IN p_Last_Name VARCHAR(50),
    IN p_Middle_Initial CHAR(1),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_City VARCHAR(50),
    IN p_County VARCHAR(50),
    IN p_Zip_Code CHAR(5),
    OUT p_User_ID INT
)
BEGIN
    INSERT INTO USER (First_Name, Last_Name, Middle_Initial, Email, Phone, City, County, Zip_Code)
    VALUES (p_First_Name, p_Last_Name, p_Middle_Initial, p_Email, p_Phone, p_City, p_County, p_Zip_Code);
    
    -- Get the ID of the user we just created
    SET p_User_ID = LAST_INSERT_ID();
END$$
DELIMITER ;

-- Update existing user information
DELIMITER $$
CREATE PROCEDURE UpdateUser(
    IN p_User_ID INT,
    IN p_First_Name VARCHAR(50),
    IN p_Last_Name VARCHAR(50),
    IN p_Middle_Initial CHAR(1),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_City VARCHAR(50),
    IN p_County VARCHAR(50),
    IN p_Zip_Code CHAR(5)
)
BEGIN
    UPDATE USER 
    SET First_Name = p_First_Name,
        Last_Name = p_Last_Name,
        Middle_Initial = p_Middle_Initial,
        Email = p_Email,
        Phone = p_Phone,
        City = p_City,
        County = p_County,
        Zip_Code = p_Zip_Code
    WHERE User_ID = p_User_ID;
END$$
DELIMITER ;

-- Remove a user and all their associated data
DELIMITER $$
CREATE PROCEDURE RemoveUser(
    IN p_User_ID INT
)
BEGIN
    -- Delete student/alumni info if exists
    DELETE FROM STUDENT_ALUM WHERE User_ID = p_User_ID;
    
    -- Delete recruiter info if exists
    DELETE FROM RECRUITER WHERE User_ID = p_User_ID;
    
    -- Delete the user record
    DELETE FROM USER WHERE User_ID = p_User_ID;
END$$
DELIMITER ;

-- =====================================================
-- STUDENT/ALUMNI PROCEDURES
-- =====================================================

-- Add student/alumni information for a user
DELIMITER $$
CREATE PROCEDURE AddStudentAlum(
    IN p_User_ID INT,
    IN p_Max_Distance_Pref FLOAT,
    IN p_Remote_Pref VARCHAR(10),
    IN p_Culture_Pref VARCHAR(100),
    IN p_Salary_Min_Pref FLOAT,
    IN p_Salary_Max_Pref FLOAT,
    IN p_Experience BLOB,
    IN p_Resume BLOB
)
BEGIN
    INSERT INTO STUDENT_ALUM (
        User_ID, Max_Distance_Pref, Remote_Pref, Culture_Pref, 
        Salary_Min_Pref, Salary_Max_Pref, Experience, Resume
    )
    VALUES (
        p_User_ID, p_Max_Distance_Pref, p_Remote_Pref, p_Culture_Pref, 
        p_Salary_Min_Pref, p_Salary_Max_Pref, p_Experience, p_Resume
    );
END$$
DELIMITER ;

-- Update student/alumni preferences
DELIMITER $$
CREATE PROCEDURE UpdateStudentAlum(
    IN p_User_ID INT,
    IN p_Max_Distance_Pref FLOAT,
    IN p_Remote_Pref VARCHAR(10),
    IN p_Culture_Pref VARCHAR(100),
    IN p_Salary_Min_Pref FLOAT,
    IN p_Salary_Max_Pref FLOAT,
    IN p_Experience BLOB,
    IN p_Resume BLOB
)
BEGIN
    UPDATE STUDENT_ALUM
    SET Max_Distance_Pref = p_Max_Distance_Pref,
        Remote_Pref = p_Remote_Pref,
        Culture_Pref = p_Culture_Pref,
        Salary_Min_Pref = p_Salary_Min_Pref,
        Salary_Max_Pref = p_Salary_Max_Pref,
        Experience = p_Experience,
        Resume = p_Resume
    WHERE User_ID = p_User_ID;
END$$
DELIMITER ;

-- Remove student/alumni status from a user
DELIMITER $$
CREATE PROCEDURE RemoveStudentAlum(
    IN p_User_ID INT
)
BEGIN
    DELETE FROM STUDENT_ALUM WHERE User_ID = p_User_ID;
END$$
DELIMITER ;

-- =====================================================
-- RECRUITER PROCEDURES
-- =====================================================

-- Add recruiter status to a user
DELIMITER $$
CREATE PROCEDURE AddRecruiter(
    IN p_User_ID INT
)
BEGIN
    INSERT INTO RECRUITER (User_ID)
    VALUES (p_User_ID);
END$$
DELIMITER ;

-- Remove recruiter status from a user
DELIMITER $$
CREATE PROCEDURE RemoveRecruiter(
    IN p_User_ID INT
)
BEGIN
    DELETE FROM RECRUITER WHERE User_ID = p_User_ID;
END$$
DELIMITER ;

-- =====================================================
-- TEST THE PROCEDURES
-- =====================================================

-- Test 1: Add a new user
CALL AddUser('John', 'Smith', 'A', 'john@example.com', '2075551111', 
             'Bangor', 'Penobscot', '04401', @new_user_id);

-- Show the user ID that was created
SELECT @new_user_id AS 'New User ID';

-- Test 2: Add student information for the user
CALL AddStudentAlum(@new_user_id, 25.5, 'Remote', 'Innovative Culture', 
                    50000, 70000, NULL, NULL);

-- Test 3: Add recruiter status for the same user
CALL AddRecruiter(@new_user_id);

-- Display all the data we just created
SELECT * FROM USER WHERE User_ID = @new_user_id;
SELECT * FROM STUDENT_ALUM WHERE User_ID = @new_user_id;
SELECT * FROM RECRUITER WHERE User_ID = @new_user_id;

DROP PROCEDURE IF EXISTS GetUserProfile;
DELIMITER $$

CREATE PROCEDURE GetUserProfile(
    IN p_User_ID INT
)
BEGIN
    SELECT 
        u.User_ID,
        u.First_Name,
        u.Last_Name,
        u.Middle_Initial,
        u.Email,
        u.Phone,
        u.City,
        u.County,
        u.Zip_Code,
        sa.Max_Distance_Pref,
        sa.Remote_Pref,
        sa.Culture_Pref,
        sa.Salary_Min_Pref,
        sa.Salary_Max_Pref
    FROM USER u
    LEFT JOIN STUDENT_ALUM sa
        ON u.User_ID = sa.User_ID
    WHERE u.User_ID = p_User_ID;
END$$

DELIMITER ;
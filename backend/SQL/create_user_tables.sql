USE job_beacon_maine;

-- =====================================================
-- DROP EXISTING TABLES
-- =====================================================
-- Drop tables in correct order (child tables first)
DROP TABLE IF EXISTS STUDENT_ALUM;
DROP TABLE IF EXISTS RECRUITER;
DROP TABLE IF EXISTS USER;

-- =====================================================
-- CREATE USER TABLE
-- =====================================================
-- Stores basic information for all users (students and recruiters)
CREATE TABLE USER (
  User_ID INT NOT NULL AUTO_INCREMENT,
  Username VARCHAR(50) UNIQUE, 
  First_Name VARCHAR(50) NOT NULL,
  Last_Name VARCHAR(50) NOT NULL,
  Middle_Initial CHAR(1) DEFAULT NULL,
  Email VARCHAR(100) NOT NULL UNIQUE,
  Password_Hash VARCHAR(255) NOT NULL DEFAULT 'temphash',
  Phone VARCHAR(15) DEFAULT NULL,
  City VARCHAR(50) DEFAULT NULL,
  County VARCHAR(50) NOT NULL,
  Zip_Code CHAR(5) DEFAULT NULL,
  PRIMARY KEY (User_ID),
  UNIQUE KEY (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- CREATE STUDENT_ALUM TABLE
-- =====================================================
-- Stores job preferences and information for students/alumni
CREATE TABLE STUDENT_ALUM (
  User_ID INT NOT NULL,
  Max_Distance_Pref FLOAT NULL,
  Remote_Pref VARCHAR(10) NULL,
  Culture_Pref VARCHAR(100) NULL,
  Salary_Min_Pref FLOAT NULL,
  Salary_Max_Pref FLOAT NULL,
  Experience BLOB NULL,
  Resume BLOB NULL,
  PRIMARY KEY (User_ID),
  CONSTRAINT STUDENT_ALUM_User_FK 
    FOREIGN KEY (User_ID) 
    REFERENCES USER(User_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- CREATE RECRUITER TABLE
-- =====================================================
-- Stores recruiter status for users
CREATE TABLE RECRUITER (
  User_ID INT NOT NULL,
  PRIMARY KEY (User_ID),
  CONSTRAINT RECRUITER_User_FK
    FOREIGN KEY (User_ID)
    REFERENCES USER(User_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

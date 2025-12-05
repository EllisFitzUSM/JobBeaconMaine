USE job_beacon_maine;

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
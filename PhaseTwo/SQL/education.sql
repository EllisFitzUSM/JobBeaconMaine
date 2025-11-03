-- Created with help from ChatGPT
CREATE DOMAIN MAINE_SCHOOL AS VARCHAR(255)
CHECK (VALUE IN (

    ));
CREATE TABLE EDUCATION (
    Education_ID     SERIAL PRIMARY KEY,
    User_ID          INT NOT NULL,
    University       MAINE_SCHOOL NOT NULL,
    Degree           VARCHAR(255) NOT NULL CHECK (Degree IN (
                        'Associate',
                        'Bachelor',
                        'Master',
                        'Doctorate',
                        'Certificate'
                    )),
    Graduation_Date  DATE NOT NULL,
    Is_Graduated     BOOLEAN GENERATED ALWAYS AS (
                        CASE
                            WHEN Graduation_Date <= CURRENT_DATE THEN TRUE
                            ELSE FALSE
                        END
                     ) STORED,
    FOREIGN KEY (User_ID) REFERENCES USER(User_ID)
);

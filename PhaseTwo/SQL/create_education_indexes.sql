-- Use already initialized database.
USE `job_beacon_maine`;

-- Create index of education for ids for join operations. 
CREATE INDEX `idx_education` 
ON `EDUCATION` (`idUSER`)

-- Create index of institutes. Just regular primary key.
CREATE INDEX `idx_higher_education_institute`
ON `HIGHER_EDUCATION_INSTUTITE` (`idHIGHER_EDUCATION_INSTUTITE`);
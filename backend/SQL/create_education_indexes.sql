-- Use already initialized database.
USE `job_beacon_maine`;

-- Create index of education on primary key for faster lookups.
CREATE INDEX `idx_education` 
ON `EDUCATION` (`idUSER`);

-- Create index of institutes on primary key for faster lookups.
CREATE INDEX `idx_higher_education_institute`
ON `HIGHER_EDUCATION_INSTITUTE` (`idHIGHER_EDUCATION_INSTITUTE`);
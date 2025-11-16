-- Use proper database.
USE `job_beacon_maine`;

-- Drop existing tables if they exist.
DROP TABLE IF EXISTS `EDUCATION`;
DROP TABLE IF EXISTS `HIGHER_EDUCATION_INSTITUTE`;

-- HIGHER EDUCATION INSTITUTE table to properly reference educational institutes in Maine.
CREATE TABLE `HIGHER_EDUCATION_INSTITUTE` (
  `idHIGHER_EDUCATION_INSTITUTE` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(55) DEFAULT NULL,
  PRIMARY KEY (`idHIGHER_EDUCATION_INSTITUTE`)
);

-- EDUCATION table to store USER (STUDENTALUM) education details.
-- Contains information about their degree type, graduation date
CREATE TABLE `EDUCATION` (
  `idEDUCATION` INT NOT NULL,
  `DEGREE` VARCHAR(55) NOT NULL,
  `GRAD_DATE` datetime NOT NULL,
  `idUSER` INT NOT NULL,
  `idHIGHER_EDUCATION_INSTITUTE` INT NOT NULL,
  PRIMARY KEY (`idEDUCATION`),
  KEY `idUSER_idx` (`idUSER`),
  CONSTRAINT `chk_degree` 
    CHECK (`DEGREE` IN ('Associate''s', 'Bachelor''s', 'Master''s', 'Doctorate')),
  CONSTRAINT `fk_education_user` 
    FOREIGN KEY (`idUSER`) 
    REFERENCES `USER` (`User_ID`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  CONSTRAINT `fk_education_higher_education_institute` 
    FOREIGN KEY (`idHIGHER_EDUCATION_INSTITUTE`) 
    REFERENCES `HIGHER_EDUCATION_INSTITUTE` (`idHIGHER_EDUCATION_INSTITUTE`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);
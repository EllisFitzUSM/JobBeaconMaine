-- Use proper database.
USE `job_beacon_maine`;

-- Drop existing tables if they exist.
DROP TABLE IF EXISTS `SKILL`;
DROP TABLE IF EXISTS `SKILL_RESOURCE`;

-- SKILL table to store various skills. Reasoning for ID is in case for future skill aliasing.
CREATE TABLE `SKILL` (
  `idSKILL` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(45) DEFAULT NULL,
  PRIMARY KEY (`idSKILL`),
  UNIQUE KEY `NAME_UNIQUE` (`NAME`)
);

-- Drop RESOURCE if it already exists.
DROP TABLE IF EXISTS `RESOURCE`;

-- RESOURCE for SKILL educational resources.
CREATE TABLE `RESOURCE` (
  `idRESOURCE` INT NOT NULL AUTO_INCREMENT,
  `URL` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRESOURCE`)
);

-- SKILL RESOURCE many to many table. 
CREATE TABLE `SKILL_RESOURCE` (
  `idRESOURCE` INT NOT NULL,
  `idSKILL` INT NOT NULL,
  PRIMARY KEY (`idRESOURCE`, `idSKILL`),
  INDEX `idSKILL_idx` (`idSKILL` ASC) VISIBLE,
  CONSTRAINT `idSKILL`
    FOREIGN KEY (`idSKILL`)
    REFERENCES `job_beacon_maine`.`SKILL` (`idSKILL`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idRESOURCE`
    FOREIGN KEY (`idRESOURCE`)
    REFERENCES `job_beacon_maine`.`RESOURCE` (`idRESOURCE`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

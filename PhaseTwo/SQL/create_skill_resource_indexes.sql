-- Make sure using correct database.
USE `job_beacon_maine`;

-- Create index for RESOURCE tables index for faster lookup.
CREATE INDEX `idx_resource`
ON `RESOURCE` (`idRESOURCE`);

-- Create index for SKILL table for faster lookup. Both id and name since they are currently equally important w/ no aliasing.
CREATE INDEX `idx_skill`
ON `SKILL` (`idSKILL`, `NAME`);
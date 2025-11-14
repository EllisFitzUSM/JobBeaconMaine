USE job_beacon_maine;

-- =====================================================
-- RECRUITER TABLE INDEXES
-- =====================================================

-- Note: The RECRUITER table only has User_ID as its primary key,
-- which is already indexed automatically by MySQL as a foreign key.

-- Index on User_ID (Foreign Key)
-- Justification: Although this is already indexed as a foreign key,
-- explicitly documenting it here for completeness.
-- This index is used when:
-- - Looking up recruiter information for a specific user
-- - Joining RECRUITER with USER table
-- - Checking if a user is a recruiter
-- The index already exists due to the foreign key constraint,
-- so we don't need to create it again.

-- If the RECRUITER table had additional columns like Company_ID, Position, etc.,
-- we would add indexes on those columns here.
-- For now, the automatic foreign key index is sufficient for this table's needs.
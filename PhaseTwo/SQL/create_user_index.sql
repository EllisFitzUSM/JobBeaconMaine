
USE job_beacon_maine;

-- =====================================================
-- USER TABLE INDEXES
-- =====================================================

-- Index on Email
-- Justification: Email is frequently used for user login and lookup operations.
-- Users will search by email when logging in or resetting passwords.
-- Email is also unique, so indexing improves query performance significantly.
CREATE INDEX idx_user_email ON USER(Email);

-- Index on Last_Name and First_Name
-- Justification: Common to search for users by name in the system.
-- Recruiters might search for students/alumni by name.
-- Combined index allows efficient searching by last name alone or both together.
CREATE INDEX idx_user_name ON USER(Last_Name, First_Name);

-- Index on City
-- Justification: Job matching often filters by location/city.
-- Students may want to find other students in the same city.
-- Recruiters may search for candidates in specific cities.
CREATE INDEX idx_user_city ON USER(City);

-- Index on County
-- Justification: Maine-specific searches often happen at county level.
-- Job postings and candidate searches may filter by county.
-- Helps with location-based matching algorithms.
CREATE INDEX idx_user_county ON USER(County);

-- Index on Zip_Code
-- Justification: Used for precise location matching and distance calculations.
-- Important for matching students with jobs within their preferred distance.
-- Zip code searches are common in job applications.
CREATE INDEX idx_user_zipcode ON USER(Zip_Code);
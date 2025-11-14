USE job_beacon_maine;

-- =====================================================
-- STUDENT_ALUM TABLE INDEXES
-- =====================================================

-- Index on Remote_Pref
-- Justification: Job matching will frequently filter by remote work preference.
-- Many searches will be "show me all students who want remote work".
-- This is a common filter criteria in modern job searches.
CREATE INDEX idx_student_remote_pref ON STUDENT_ALUM(Remote_Pref);

-- Index on Salary_Min_Pref and Salary_Max_Pref
-- Justification: Salary range is a critical factor in job matching.
-- Recruiters need to find candidates whose salary expectations match job offers.
-- Range queries benefit from indexing both min and max values.
CREATE INDEX idx_student_salary_range ON STUDENT_ALUM(Salary_Min_Pref, Salary_Max_Pref);

-- Index on Max_Distance_Pref
-- Justification: Used to match students with jobs within their acceptable commute distance.
-- Distance-based searches are common in location matching algorithms.
-- Helps filter out jobs that are too far away quickly.
CREATE INDEX idx_student_max_distance ON STUDENT_ALUM(Max_Distance_Pref);

-- Index on Culture_Pref
-- Justification: Company culture fit is important for job satisfaction.
-- Students may search for companies with specific culture types.
-- Recruiters may filter candidates by culture preferences.
CREATE INDEX idx_student_culture_pref ON STUDENT_ALUM(Culture_Pref);
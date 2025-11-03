CREATE TABLE Employer(
EmployerID varchar(15),
Industry varchar(50),
EmployerName varchar(20),
WebsiteURL varchar(100),
Culture varchar(2000)
);

CREATE TABLE Job(
JobID
EmployerID
RecruiterID
ApplicationURL
JobDescription
JobTitle
PostedAt
ExpiresAt
IsExpired
StartDate
RequiredSkills
Location
Preferences
)

CREATE TABLE Resources(
ResourceID
Documents
)

CREATE TABLE Skill(
SkillID
SkillName
)

CREATE TABLE Education(
EducationID
UserID
Education
GraduationDate
IsGraduated
)





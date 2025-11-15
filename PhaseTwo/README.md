# JobBeaconMaine
Students and new graduates struggle to discover relevant job opportunities in Maine's job market. This project will find and notify students of these opportunities.

## Roles & Contacts
|    Name     | Ellis (Team Lead)       | Jered        | Kadin       |
|------------|------------|-----------|-----------|
|   Email  | ellis.fitzgerald@maine.edu   | jered.kalombo@maine.edu | kadin.ilott@maine.edu  |

## Tasks
Due dates are similar to keep everyone moving at the same pace and collaborate on any issues.

### Scraping
|    Task     | Assignee       | Deadline / Status        |
|------------|-----------|-----------|
| Maine Colleges & Universities   | Ellis | ✅  |
| [Indeed](https://indeed.com)   | Ellis | ✅  |
| [liveandworkinmaine](https://www.liveandworkinmaine.com/)   | Jered | ✅  |
| [JobsInMaine](https://jobsinmaine.com/jobs)   | Kadin | ✅  |
| Maine Zipcodes, Towns, & Counties | Kadin | ✅ |
| Skill Extraction   | Ellis | ✅  |
| Resources | Jered | Nov 8, 2025 |

### Scraping Documentation
|    Task     | Assignee       | Deadline / Status        |
|------------|-----------|-----------|
| Maine Colleges & Universities   | Ellis | ✅  |
| Job Website  | Ellis | ✅  |
| Skill Extraction  | Ellis | ✅  |
| Maine Zipcodes, Towns, & Counties | Kadin | Nov 8, 2025 |
| Job Website  | Kadin | Nov 8, 2025  |
| Job Website  | Jered | ✅  |
| Resources | Jered | Nov 9, 2025 |

### SQL Schemas
|    Task     | Assignee       | Deadline / Status        |
|------------|-----------|-----------|
| Skill Table   | Ellis | ✅  |
| JobRequiresSkill Table   | Ellis | Nov 13, 2025  |
| StudentAlumHasSkill Table   | Ellis | Nov 13, 2025  |
| ResourceTeachesSkill Table   | Ellis | ✅ |
| Education Table   | Ellis | ✅ |
| HigherEducationInstitute Table   | Ellis | ✅ |
| Resource Tables | Ellis | ✅ |
| User Table   | Jered | ✅  |
| StudentAlum Table   | Jered | ✅  |
| Recruiter Table   | Jered | ✅  |
| JobTable   | Kadin | Nov 10, 2025  |
| JobApplication Table  | Kadin | Nov 10, 2025  |
| Employer Table   | Kadin | Nov 10, 2025  |
| WorksAt Table   | Kadin | Nov 10, 2025  |
<!--| MaineLocation Table | Kadin | Nov 14, 2025 |-->

*If your table references another table's primary key AND it is NOT among your own responsibilities AND it does NOT already exist in the repository... just create a temporary one. It could be as basic as the following:*
```sql
CREATE TABLE `job_beacon_maine`.`{Insert table dependency name}` (
  `id{Insert table dependency name}` INT NOT NULL,
  PRIMARY KEY (`id{Insert table dependency name}`)
);
```

### SQL Index
|    Task     | Assignee       | Deadline / Status        |
|------------|-----------|-----------|
| Write a (or multiple) `{table_name}_index.sql` files which index upon a table you wrote. ADD SQL CODE COMMENTS FOR JUSTIFICATION! | Ellis, Jered, Kadin | Nov 14, 2025 |

As seen on [W3Schools](https://www.w3schools.com/mysql/mysql_create_index.asp):
```sql
CREATE INDEX index_name ON table_name (column1, column2, ...);
```

### SQL Procedures + Functions + Triggers
|    Task     | Assignee       | Deadline / Status        |
|------------|-----------|-----------|
| Basic read & write operations on tables that you were responsible for writing.| Ellis, Kadin | Nov 13, 2025  |
| Basic read & write operations on tables that you were responsible for writing.| Jered | ✅  |
| "AlumniReferral"   | Ellis | Nov 13, 2025  |
| "ResourcesBasedOnMissingSkills"   | Ellis | Nov 13, 2025  |
| "JobMatchScore"  | Kadin | Nov 13, 2025  |
| "RemoveExpiredJobs"   | Kadin | Nov 13, 2025  |
| "MissingSkills" | Jered | Nov 13, 2025  |
| "JobApplicationStatus"   | Jered | Nov 13, 2025  |

### Final Tasks
|    Task     | Assignee       | Deadline / Status        |
|------------|-----------|-----------|
| Video: Demonstrate the `CREATE DATABASE` for `job_beacon_maine` then running the tables *YOU* wrote (with the addition of other tables if yours rely on them via a dependency). Secondly, the procedures and functions that *YOU* wrote and discuss their purpose. Thirdly, any index statements that optimize selections. Finally, demonstrate you running your scraping scripts. Could be as simple as getting one data entry.   | Ellis, Jered, Kadin | Nov 14, 2025  |
| Video Edit & Combine  | Ellis | Nov 14, 2025  |
| "How To Run" ReadMe   | Ellis | Nov 14, 2025  |
| Query Analysis: Write a few queries for the database *before* you have ran any index SQL statements like so: `{table_name}_index.sql`. Then run said index statements and run the same queries to demonstrate performance gains.   | Kadin | Nov 15, 2025  |

## Meetings
|    Time     | Topics  |    Status  |   
|------------|-----------|-----------|
| Nov 4, 2025 2:00 PM EST  | Understanding of responsibilities, questions, blockers, etc. Agree on the data that should be cleaned and what format to return the data in. | ✅ |
| Nov 6, 2025 2:00 PM EST  | Meeting before scraping deadline. Getting up to speed and agreeing on data format. | ✅ |
| Nov 11, 2025 2:00 PM EST  | Make sure scraping scripts are final. Decide if any changes need to be made. | ❌ (Holiday) |
| Nov 13, 2025 2:00 PM EST  | Meet before final deadlines. Conclude steps for final build. Check documentation to make sure consistent. | ✅  |

## Branches
Commits should be done through branches to prevent any conflicts and a stable upstream.
|    Name     | Branch  |  
|------------|-----------|
| Ellis  | `ellis-tasks` |
| Jered  | `jered-tasks` |
| Kadin  | `kadin-tasks` |

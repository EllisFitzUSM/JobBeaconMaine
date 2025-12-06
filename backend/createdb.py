from data_importer import DataImporter
from import_utility import *
import pymysql.cursors
import argparse as ap
import re

def main():
    import sys
    print("ARGV:", sys.argv)

    argparser = ap.ArgumentParser(description='Build the Job Beacon Maine backend/database')
    argparser.add_argument('--host', type=str, default='localhost', help='Database host')
    argparser.add_argument('--user', type=str, default='admin', help='Database user')
    argparser.add_argument('--pw', type=str, default='admin', help='Database password')
    argparser.add_argument('--port', type=int, default=3306, help='Database port')
    argparser.add_argument('--skip_drop', action='store_true', help='Skip dropping of tables')
    argparser.add_argument('--index', action='store_true', help='Create indexes after creating tables')
    argparser.add_argument('--import_data', action='store_true', help='Whether to import initial backend/data from scraping stages.')
    args = argparser.parse_args()

    print("USER RAW: ", repr(args.user))
    print("PASSWORD RAW: ", repr(args.pw))

    create_database_file = 'backend/SQL/create_database.sql'
    drop_tables_file = 'backend/SQL/drop_tables_procedures.sql'

    create_table_files_ordered = [
        'backend/SQL/create_user_tables.sql',
        'backend/SQL/create_job_employer_tables.sql',
        'backend/SQL/create_job_application_tables.sql',
        'backend/SQL/create_education_tables.sql',
        'backend/SQL/create_skill_resource_tables.sql'
    ]

    create_index_files_ordered = [
        'backend/SQL/create_education_indexes.sql',
        'backend/SQL/create_skill_resource_indexes.sql',
        'backend/SQL/create_job_employer_indexes.sql',
        'backend/SQL/create_user_index.sql',
        'backend/SQL/create_recruiter_index.sql',
        'backend/SQL/create_studentalum_index.sql'
    ]

    procedures_files_ordered = [
        'backend/SQL/skill_resource_procedures.sql',
        'backend/SQL/education_procedures.sql',
        'backend/SQL/job_application_employer_procedures.sql',
        'backend/SQL/user_procedures.sql',
        'backend/SQL/job_import_procedure.sql'
        # 'backend/SQL/jobmatchprocedure.sql' # this needs fixin
    ]

    # Connect to the backend/database
    connection = pymysql.connect(host=args.host,
                                port=args.port,
                                user=args.user,
                                password=args.pw,
                                charset='utf8mb4',
                                cursorclass=pymysql.cursors.DictCursor,
                                client_flag=pymysql.constants.CLIENT.MULTI_STATEMENTS
                                )

    # Build backend/database, tables, indexes, and procedures in specified order. 
    with connection:
        with connection.cursor() as cursor:
            file_order = [create_database_file]
            if not args.skip_drop:
                file_order += [drop_tables_file]
            file_order += create_table_files_ordered
            if args.index:
                file_order += create_index_files_ordered
            file_order += procedures_files_ordered
            for file_path in file_order:
                print(f'Executing {file_path}...')
                with open(file_path, 'r') as sql_file:
                    sql_content = sql_file.read()
                sql_content = re.sub(r'DELIMITER(\s)?\$\$', '', sql_content)
                sql_content = re.sub(r'DELIMITER ;', '', sql_content)
                sql_content = re.sub(r'(\s)?\$\$', ';', sql_content)
                sql_content = re.sub(r'USE\s.+;', 'USE `job_beacon_maine`;', sql_content)
                cursor.execute(sql_content)
        connection.commit()

        # Populate the tables with backend/data
        if args.import_data:
            data_importers = [
                DataImporter(
                    'backend/data/new_england_indeed_job_skills.csv', 
                    'sp_CreateSkill',
                    ['Name']
                ),
                DataImporter(
                    'backend/data/maine_schools.csv',
                    'sp_CreateHigherEducationInstitute',
                    ['Name']
                ),
                DataImporter(
                    'backend/data/new_england_indeed_jobs.csv',
                    'sp_CreateJobWithSkills',
                    ['company', 
                    'company_url', 
                    'title', 
                    {'value': 'description', 'callable': shorten_desc}, 
                    'min_amount', 
                    'max_amount', 
                    'is_remote', 
                    'location', 
                    'location', 
                    'location', 
                    {'value':'location', 'callable': shorten_zip}, 
                    'date_posted', 
                    {'value': 'job_url_direct','callable': shorten_app_url}, 
                    'skills'] # This is honestly bad. Just plain bad. 
                )
            ]
            for data_importer in data_importers:
                print(f'Importing Data from {data_importer.file.name}...')
                data_importer.data_import(connection)
            connection.commit()

if __name__ == '__main__':
    main()
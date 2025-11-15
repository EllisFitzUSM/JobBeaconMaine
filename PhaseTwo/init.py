from data_importer import DataImporter
import pymysql.cursors
import argparse as ap

argparser = ap.ArgumentParser(description='Build the Job Beacon Maine database')
argparser.add_argument('--host', type=str, default='localhost', help='Database host')
argparser.add_argument('--user', type=str, default='root', help='Database user')
argparser.add_argument('--pw', type=str, default='passwd', help='Database password')
argparser.add_argument('--port', type=int, default=3306, help='Database port')
argparser.add_argument('--skip_drop', action='store_true', help='Skip dropping of tables')
argparser.add_argument('--index', action='store_true', help='Create indexes after creating tables')
argparser.add_argument('--import_data', action='store_true', help='Whether to import initial data from scraping stages.')
args = argparser.parse_args()

create_database_file = 'PhaseTwo/SQL/create_database.sql'
drop_tables_file = 'PhaseTwo/SQL/drop_tables.sql'

create_table_files_ordered = [
    'PhaseTwo/SQL/create_user_tables.sql',
    'PhaseTwo/SQL/create_job_employer_tables.sql',
    'PhaseTwo/SQL/create_education_tables.sql',
    'PhaseTwo/SQL/create_skill_resource_tables.sql'
]

create_index_files_ordered = [
    # 'SQL/create_job_indexes.sql',
    'PhaseTwo/SQL/create_education_indexes.sql',
    'PhaseTwo/SQL/create_skill_resource_indexes.sql'
]

procedures_files_ordered = [
    'PhaseTwo/SQL/skill_resource_procedures.sql'
    # 'PhaseTwo/SQL/education_procedures.sql',
    # 'SQL/user_procedures.sql'
]

def to_sql_statements(file_path:str):
    with open(file_path, 'r') as f:
        content = f.read()
    return [stmt.strip() for stmt in content.split(';') if stmt.strip()]

# Connect to the database
connection = pymysql.connect(host=args.host,
                            port=args.port,
                            user=args.user,
                            password=args.pw,
                            charset='utf8mb4',
                            cursorclass=pymysql.cursors.DictCursor,
                            client_flag=pymysql.constants.CLIENT.MULTI_STATEMENTS
                            )

# Build database, tables, indexes, and procedures in specified order. 
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
            cursor.execute(sql_content)
    connection.commit()

    # Populate the tables with data
    if args.import_data:
        data_importers = [
            DataImporter(
                'PhaseTwo/Data/new_england_indeed_job_skills.csv', 
                'sp_CreateSkill',
                ['Name']
            )
        ]
        for data_importer in data_importers:
            print(f'Importing data from {data_importer.file.name}...')
            data_importer.data_import(connection)
        connection.commit()
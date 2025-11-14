import pymysql.cursors
import argparse as ap

create_database_file = 'PhaseTwo/SQL/create_database.sql'
drop_tables_file = 'PhaseTwo/SQL/drop_tables.sql'

create_table_files_order = [
    'PhaseTwo/SQL/create_user_tables.sql',
    # 'SQL/create_job_tables.sql',
    'PhaseTwo/SQL/create_education_tables.sql',
    'PhaseTwo/SQL/create_skill_resource_tables.sql'
]

create_index_files_order = [
    # 'SQL/create_job_indexes.sql',
    'PhaseTwo/SQL/create_education_indexes.sql',
    'PhaseTwo/SQL/create_skill_resource_indexes.sql'
]

procedures_files_order = [
    'PhaseTwo/SQL/skill_resource_procedures.sql',
    'PhaseTwo/SQL/education_procedures.sql',
    'SQL/user_procedures.sql'
]

argparser = ap.ArgumentParser(description='Build the Job Beacon Maine database.')
argparser.add_argument('host', type=str, default='localhost', help='Database host')
argparser.add_argument('user', type=str, default='root', help='Database user')
argparser.add_argument('password', type=str, default='passwd', help='Database password')
argparser.add_argument('--skip_drop', action='store_false', help='Whether to skip dropping of tables.')
argparser.add_argument('--index', action='store_false', help='Whether to create indexes.')
args = argparser.parse_args()

def to_sql_statements(file_path):
    with open(file_path, 'r') as f:
        content = f.read()
    return [stmt.strip() for stmt in content.split(';') if stmt.strip()]

# Connect to the database
connection = pymysql.connect(host=args.host,
                                user=args.user,
                                password=args.password,
                                charset='utf8mb4',
                                cursorclass=pymysql.cursors.DictCursor)

with connection:
    with connection.cursor() as cursor:
        file_order = [create_database_file]
        if not args.skip_drop:
            file_order += [drop_tables_file]
        if args.index:
            file_order += create_index_files_order
        file_order += procedures_files_order
        for file in file_order:
            print(f'Executing {file}...')

            for stmt in to_sql_statements(file):
                cursor.execute(stmt)
    connection.commit()

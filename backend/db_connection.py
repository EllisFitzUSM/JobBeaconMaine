db_config = None

def set_db_config(config):
    global db_config
    db_config = config

def get_db_connection():
    if db_config is None:
        raise Exception("Database configuration not set. Call set_db_config first.")
    
    import pymysql
    return pymysql.connect(
        host=db_config['host'],
        user=db_config['user'],
        password=db_config['password'],
        database='job_beacon_maine',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=True
    )
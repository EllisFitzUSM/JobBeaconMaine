db = None

def set_db_connection(in_connection):
    global db
    db = in_connection

def get_db_connection():
    return db
from db_connection import *
from flask import Flask
from flask_cors import CORS
from routes.jobs import jobs_routes  # Import the new jobs routes
from routes.user import user_routes
from routes.signup import signup_routes
from routes.login_routes import login_routes
import argparse as ap
import pymysql.cursors

def main():
    argparser = ap.ArgumentParser(description='Flask route backend for JobBeaconMaine')
    argparser.add_argument('--host', type=str, default='localhost', help='Database host')
    argparser.add_argument('--user', type=str, default='admin', help='Database user')
    argparser.add_argument('--pw', type=str, default='admin', help='Database password')
    argparser.add_argument('--port', type=int, default=3306, help='Database port')
    args = argparser.parse_args()
    connection = pymysql.connect(host=args.host,
                                port=args.port,
                                user=args.user,
                                password=args.pw,
                                charset='utf8mb4',
                                database='job_beacon_maine',
                                cursorclass=pymysql.cursors.DictCursor,
                                client_flag=pymysql.constants.CLIENT.MULTI_STATEMENTS
                                )
    set_db_connection(connection)
    app.run(debug=True, port=5000)

app = Flask(__name__)

# Enable CORS so React can make requests to Flask
CORS(app, resources={r"/api/*": {"origins": "http://localhost:5173"}})

# Register blueprints
app.register_blueprint(user_routes)
app.register_blueprint(jobs_routes)
app.register_blueprint(signup_routes)
app.register_blueprint(login_routes)


@app.route("/")
def home():
    return {"message": "Job Beacon API is running"}

@app.route("/health")
def health():
    return {"status": "healthy"}, 200

if __name__ == '__main__':
    main()
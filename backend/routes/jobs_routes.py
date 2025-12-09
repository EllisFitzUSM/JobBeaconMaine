from flask import Blueprint, request, jsonify
from db_connection import get_db_connection
import traceback
import pymysql

jobs_routes = Blueprint("jobs_routes", __name__, url_prefix='/api/jobs')

# -----------------------------------------------------------
# MODE 1: Keyword Search (simple) by the word entered in the search bar
# -----------------------------------------------------------
@jobs_routes.get("/search")
def search_jobs():
    keyword = request.args.get("keyword", "")

    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        like = f"%{keyword}%"

        cursor.execute("""
            SELECT j.*, e.employer_name, e.employer_website 
            FROM Jobs j
            LEFT JOIN Employer e ON j.employer_id = e.employer_id
            WHERE j.job_title LIKE %s
               OR j.job_description LIKE %s
               OR e.employer_name LIKE %s
        """, (like, like, like))

        jobs = cursor.fetchall()

        return jsonify({"success": True, "jobs": jobs})

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

# -----------------------------------------------------------
# MODE 2: Filter-Based Search based on info entered by user upon signing up
# -----------------------------------------------------------
@jobs_routes.get("/filter")
def filter_jobs():

    city = request.args.get("city")
    remote = request.args.get("remote")
    min_salary = request.args.get("min_salary")
    max_salary = request.args.get("max_salary")
    skills = request.args.get("skills", "")

    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        cursor.callproc(
            "jobMatchScoreFilterSearch",
            (city, remote, min_salary, max_salary, skills)
        )

        cursor.execute("SELECT * FROM tmp_filter_scores ORDER BY total_score DESC")
        jobs = cursor.fetchall()

        return jsonify({"success": True, "jobs": jobs})

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


# -----------------------------------------------------------
# MODE 3: Recommended Jobs (Stored Procedure based on User info in database)
# -----------------------------------------------------------
@jobs_routes.route("/recommend/<int:user_id>", methods=["GET"])
def recommend_jobs(user_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)

        cursor.callproc("jobMatchScore", (user_id,))
        cursor.execute("SELECT * FROM tmp_job_scores ORDER BY total_score DESC;")
        jobs = cursor.fetchall()

        cursor.close()
        conn.close()

        return jsonify({"success": True, "jobs": jobs}), 200

    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "error": str(e)}), 500
    
@jobs_routes.route("/applications", methods=["GET", "POST"])
def job_application():
    try:

        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)

        if request.method == "GET":
            user_id = request.args.get("user_id")
            cursor.execute("SELECT * FROM job_application AS ja JOIN jobs AS j ON j.job_id = ja.job_id JOIN employer AS e ON j.employer_id = e.employer_id WHERE ja.user_id = %s;", (user_id, ))
            job_apps = cursor.fetchall()

            return jsonify({
                "success": True, 
                "job_apps": [{
                    "job_id": row['job_id'],
                    "employer_id": row['employer_id'],
                    "employer_name": row['employer_name'],
                    "job_title": row['job_title'],
                    "job_description": row['job_description'],
                    "apply_date": row['apply_date']
                } for row in job_apps]
            })
        elif request.method == "POST":
            job_id = request.args.get("job_id")
            user_id = request.args.get("user_id")
            cursor.callproc('add_job_application', (user_id, job_id, None, 'External'))
            conn.commit()
            return jsonify({"success": True}), 200
    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "error": str(e)}), 500

from flask import Blueprint, request, jsonify
from db_connection import get_db_connection
import traceback

jobs_routes = Blueprint("jobs_routes", __name__)

# -----------------------------------------------------------
# MODE 1: Keyword Search (simple)
# -----------------------------------------------------------
@jobs_routes.get("/api/jobs/search")
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
# MODE 2: Filter-Based Search
# -----------------------------------------------------------
@jobs_routes.route("/api/jobs/filter", methods=["GET"])
def filter_jobs():
    try:
        city = request.args.get("city")
        remote_pref = request.args.get("remote_pref")
        min_salary = request.args.get("min_salary")
        max_salary = request.args.get("max_salary")
        keyword = request.args.get("keyword")

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT j.*, e.employer_name, e.employer_industry
            FROM Jobs j
            LEFT JOIN Employer e ON j.employer_id = e.employer_id
            WHERE 1 = 1
        """

        params = []

        if keyword:
            query += " AND (j.job_title LIKE %s OR j.job_description LIKE %s)"
            kw = f"%{keyword}%"
            params.extend([kw, kw])

        if city:
            query += " AND j.city = %s"
            params.append(city)

        if remote_pref:
            query += " AND j.remote_pref = %s"
            params.append(remote_pref)

        if min_salary not in [None, "", "0"]:
            query += " AND CAST(j.salary_min AS UNSIGNED) >= %s"
            params.append(min_salary)

        if max_salary not in [None, "", "0"]:
            query += " AND CAST(j.salary_max AS UNSIGNED) <= %s"
            params.append(max_salary)

        cursor.execute(query, tuple(params))
        jobs = cursor.fetchall()

        cursor.close()
        conn.close()

        return jsonify({"success": True, "jobs": jobs, "count": len(jobs)}), 200

    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "error": str(e)}), 500


# -----------------------------------------------------------
# MODE 3: Recommended Jobs (Stored Procedure)
# -----------------------------------------------------------
@jobs_routes.route("/api/jobs/recommend/<int:user_id>", methods=["GET"])
def recommend_jobs(user_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.callproc("jobMatchScore", (user_id,))
        cursor.execute("SELECT * FROM tmp_job_scores ORDER BY total_score DESC;")
        jobs = cursor.fetchall()

        cursor.close()
        conn.close()

        return jsonify({"success": True, "jobs": jobs}), 200

    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "error": str(e)}), 500

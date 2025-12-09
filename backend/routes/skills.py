from flask import Blueprint, jsonify, request
from datetime import datetime
import pymysql
from db_connection import get_db_connection

skill_routes = Blueprint('skills_routes', __name__, url_prefix='/api/skills')

@skill_routes.route('/', methods=["GET", "POST"])
def skills():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)

        if request.args.get('user_id') is not None:
            if request.method == "POST":
                cursor.execute("SELECT ")
            else:
                return jsonify({"success": False, "error": "Unimplemented"}), 501
        elif request.args.get('job_id') is not None:
            return jsonify({"success": False, "error": "Unimplemented"}), 501
        else:
            cursor.callproc('sp_GetAllSkillsSorted', ())
            skills = cursor.fetchall()

            return jsonify({"success": True, "skills": skills})


    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500
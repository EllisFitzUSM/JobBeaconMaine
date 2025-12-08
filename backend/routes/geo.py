from flask import Blueprint, jsonify, request
from datetime import datetime
import pymysql
from db_connection import get_db_connection
import traceback

geo_routes = Blueprint('geo_routes', __name__, url_prefix='/api/geo')

@geo_routes.get('/cities')
def distinct_cities():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)

        data = request.args
        if data.get('user_id') is not None:
            return jsonify({"success": False, "error": "Unimplemented"}), 501
        elif data.get('employer_id') is not None:
            return jsonify({"success": False, "error": "Unimplemented"}), 501
        elif data.get('job_id') is not None:
            return jsonify({"success": False, "error": "Unimplemented"}), 501
        else:
            print("retrieving all distinct cities")
            # cursor.callproc('sp_GetDistinctCities', ())
            # cursor.execute("CALL sp_GetDistinctCities()")
            cursor.execute("SELECT DISTINCT ll.city FROM `Location_Lookup` AS ll")
            cities = cursor.fetchall()

            print(cities)

            return jsonify({"success": True, "cities": [row['city'] for row in cities if row['city']]})


    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "error": str(e)}), 500
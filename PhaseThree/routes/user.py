from flask import Blueprint, jsonify, request
from db import get_db_connection

user_routes = Blueprint('user_routes', __name__)

@user_routes.route('/user/<int:user_id>', methods=['GET', 'PUT'])
def user_profile(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'GET':
        cursor.execute("""
            SELECT u.User_ID, u.First_Name, u.Last_Name, u.Email, u.City, 
                   sa.Remote_Pref, sa.Salary_Min_Pref, sa.Salary_Max_Pref
            FROM USER u
            LEFT JOIN STUDENT_ALUM sa ON u.User_ID = sa.User_ID
            WHERE u.User_ID = %s
        """, (user_id,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        return jsonify(user)

    elif request.method == 'PUT':
        data = request.json
        cursor.execute("""
            UPDATE USER
            SET First_Name=%s, Last_Name=%s, Email=%s, City=%s
            WHERE User_ID=%s
        """, (data['firstName'], data['lastName'], data['email'], data['city'], user_id))
        cursor.execute("""
            UPDATE STUDENT_ALUM
            SET Remote_Pref=%s, Salary_Min_Pref=%s, Salary_Max_Pref=%s
            WHERE User_ID=%s
        """, (data['remotePref'], data['salaryMin'], data['salaryMax'], user_id))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Profile updated successfully!'})
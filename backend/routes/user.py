from flask import Blueprint, request, jsonify
import pymysql.cursors

user_routes = Blueprint('user_routes', __name__)

@user_routes.route('/user/<int:user_id>', methods=['GET', 'PUT'])
def user_profile(user_id):
    conn = get_db_connection()
    cursor = conn.cursor()

    if request.method == 'GET':
        cursor.callproc('GetUserProfile', [user_id])
        result = cursor.fetchall()

        cursor.close()
        conn.close()
        return jsonify(result[0]) if result else jsonify({})

    elif request.method == 'PUT':
        data = request.json

        cursor.callproc('UpdateUser', [
            user_id,
            data.get('firstName'),
            data.get('lastName'),
            data.get('middleInitial'),
            data.get('email'),
            data.get('phone'),
            data.get('city'),
            data.get('county'),
            data.get('zip')
        ])

        cursor.callproc('UpdateStudentAlum', [
            user_id,
            data.get('distance'),
            data.get('remotePref'),
            data.get('culturePref'),
            data.get('salaryMin'),
            data.get('salaryMax'),
            None,
            None
        ])

        conn.commit()

        cursor.close()
        conn.close()
        return jsonify({'message': 'Profile updated successfully'})
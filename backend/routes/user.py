from flask import Blueprint, request, jsonify
import pymysql.cursors
from db_connection import get_db_connection


user_routes = Blueprint('user_routes', __name__)

def open_connection():
    return pymysql.connect(
        host='localhost',
        user='admin',
        password='admin',
        database='job_beacon_maine',
        port=3306,
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=False  # transaction management
    )

@user_routes.route('/user/<int:user_id>', methods=['GET', 'PUT'])
def user_profile(user_id):
    conn = open_connection()
    cursor = conn.cursor()

    try:
        if request.method == 'GET':
            cursor.callproc('GetUserProfile', [user_id])
            result = cursor.fetchall()
            if not result:
                return jsonify({'error': 'User not found'}), 404
            return jsonify(result[0])

        if request.method == 'PUT':
            data = request.json or {}

            # Start transaction
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
                data.get('maxCommute'),
                data.get('remotePref'),
                data.get('culturePref'),
                data.get('salaryMin'),
                data.get('salaryMax'),
                None,
                None
            ])

            # Commits only if both succeed
            conn.commit()

            return jsonify({'message': 'Profile updated successfully'})

    except Exception as e:
        # Rollback in case of any error
        conn.rollback()
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()
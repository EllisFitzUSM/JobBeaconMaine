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
        cursorclass=pymysql.cursors.DictCursor
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

        elif request.method == 'PUT':
            data = request.json or {}

            # Start a transaction
            cursor.execute('START TRANSACTION;')

            # Update main user info
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

            # Update student/alumni-specific info
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

            # Commit transaction if all succeeds
            conn.commit()

            return jsonify({'message': 'Profile updated successfully'})

    except Exception as e:
        # Rollback if anything goes wrong
        conn.rollback()
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()
from flask import Blueprint, jsonify, request
import pymysql
from datetime import datetime
from db_connection import get_db_connection

employer_routes = Blueprint('employer_routes', __name__, url_prefix='/api/employers')

@employer_routes.route('/<int:employer_id>', methods=['GET'])
def get_employer(employer_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.callproc('read_employer', [employer_id])
        
        employer = None
        for result in cursor.stored_results():
            employer = result.fetchone()
        
        if not employer:
            cursor.close()
            conn.close()
            return jsonify({
                'success': False,
                'error': 'Employer not found'
            }), 404
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'employer': employer
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@employer_routes.route(methods=['POST'])
def create_employer():
    try:
        data = request.get_json()
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.callproc('add_employer', [
            data.get('employer_name'),
            data.get('employer_culture'),
            data.get('employer_website'),
            data.get('employer_industry')
        ])
        
        conn.commit()
        employer_id = cursor.lastrowid
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'employer_id': employer_id,
            'message': 'Employer created successfully'
        }), 201
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@employer_routes.route('<int:employer_id>', methods=['PUT'])
def update_employer(employer_id):
    try:
        data = request.get_json()
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.callproc('update_employer', [
            employer_id,
            data.get('employer_name'),
            data.get('employer_culture'),
            data.get('employer_website'),
            data.get('employer_industry')
        ])
        
        conn.commit()
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': 'Employer updated successfully'
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@employer_routes.route('<int:employer_id>', methods=['DELETE'])
def delete_employer(employer_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.callproc('delete_employer', [employer_id])
        
        conn.commit()
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': 'Employer deleted successfully'
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500
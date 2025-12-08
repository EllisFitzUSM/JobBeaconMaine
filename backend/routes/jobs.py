from flask import Blueprint, jsonify, request
import pymysql
from datetime import datetime
from db_connection import get_db_connection
import traceback

jobs_routes = Blueprint('jobs_routes', __name__)

# GET all jobs (with optional filters)
@jobs_routes.route('/api/jobs', methods=['GET'])
def get_jobs():
    try:
        # Get query parameters for filtering
        city = request.args.get('city')
        remote_pref = request.args.get('remote_pref')
        min_salary = request.args.get('min_salary')
        max_salary = request.args.get('max_salary')
        keyword = request.args.get('keyword')
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Build dynamic query
        query = """
            SELECT 
                j.job_id,
                j.job_title,
                j.job_description,
                j.salary_min,
                j.salary_max,
                j.remote_pref,
                j.city,
                j.county,
                j.zip_code,
                j.posted_at,
                j.expires_at,
                j.estimated_start_date,
                j.is_expired,
                j.application_url,
                e.employer_name,
                e.employer_website,
                e.employer_industry
            FROM Jobs j
            LEFT JOIN Employer e ON j.employer_id = e.employer_id
            WHERE 1=1
        """
        params = []
        
        # City filter
        if city:
            query += " AND j.city = %s"
            params.append(city)
        
        # Remote preference filter
        if remote_pref:
            query += " AND j.remote_pref = %s"
            params.append(remote_pref)
        
        # Minimum salary filter - job's min salary must be at least this value
        if min_salary:
            query += " AND CAST(j.salary_min AS UNSIGNED) >= %s"
            params.append(min_salary)
        
        # Maximum salary filter - job's max salary must be at most this value
        if max_salary:
            query += " AND CAST(j.salary_max AS UNSIGNED) <= %s"
            params.append(max_salary)
        
        # Keyword search - search in job title, description, and employer name
        if keyword:
            query += """ AND (
                j.job_title LIKE %s 
                OR j.job_description LIKE %s 
                OR e.employer_name LIKE %s
            )"""
            keyword_param = f"%{keyword}%"
            params.extend([keyword_param, keyword_param, keyword_param])
        
        query += " ORDER BY j.posted_at DESC"
        
        cursor.execute(query, params)
        jobs = cursor.fetchall()
        
        # Convert datetime objects to strings for JSON
        for job in jobs:
            if job['posted_at']:
                job['posted_at'] = job['posted_at'].isoformat()
            if job['expires_at']:
                job['expires_at'] = job['expires_at'].isoformat()
            if job['estimated_start_date']:
                job['estimated_start_date'] = job['estimated_start_date'].isoformat()
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'jobs': jobs,
            'count': len(jobs)
        }), 200
        
    except Exception as e:
        traceback.print_exc()
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

# GET single job by ID
@jobs_routes.route('/api/jobs/<int:job_id>', methods=['GET'])
def get_job(job_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = """
            SELECT 
                j.*,
                e.employer_name,
                e.employer_website,
                e.employer_culture,
                e.employer_industry
            FROM Jobs j
            LEFT JOIN Employer e ON j.employer_id = e.employer_id
            WHERE j.job_id = %s
        """
        
        cursor.execute(query, (job_id,))
        job = cursor.fetchone()
        
        if not job:
            return jsonify({
                'success': False,
                'error': 'Job not found'
            }), 404
        
        # Convert datetime to string
        if job['posted_at']:
            job['posted_at'] = job['posted_at'].isoformat()
        if job['expires_at']:
            job['expires_at'] = job['expires_at'].isoformat()
        if job['estimated_start_date']:
            job['estimated_start_date'] = job['estimated_start_date'].isoformat()
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'job': job
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

# GET unique cities (for filter dropdown)
@jobs_routes.route('/api/jobs/filters/cities', methods=['GET'])
def get_cities():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT DISTINCT city 
            FROM Jobs 
            WHERE city IS NOT NULL 
            ORDER BY city
        """)
        
        cities = [row['city'] for row in cursor.fetchall()]
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'cities': cities
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

# GET filter options (remote preferences)
@jobs_routes.route('/api/jobs/filters/remote', methods=['GET'])
def get_remote_options():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT DISTINCT remote_pref 
            FROM Jobs 
            WHERE remote_pref IS NOT NULL 
            ORDER BY remote_pref
        """)
        
        remote_options = [row['remote_pref'] for row in cursor.fetchall()]
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'remote_options': remote_options
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

# GET salary range statistics
@jobs_routes.route('/api/jobs/filters/salary-range', methods=['GET'])
def get_salary_range():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT 
                MIN(CAST(salary_min AS UNSIGNED)) as min_salary,
                MAX(CAST(salary_max AS UNSIGNED)) as max_salary,
                AVG(CAST(salary_min AS UNSIGNED)) as avg_min_salary,
                AVG(CAST(salary_max AS UNSIGNED)) as avg_max_salary
            FROM Jobs 
            WHERE salary_min IS NOT NULL 
            AND salary_max IS NOT NULL
            AND salary_min != ''
            AND salary_max != ''
        """)
        
        result = cursor.fetchone()
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'salary_range': {
                'min': int(result['min_salary']) if result['min_salary'] else 0,
                'max': int(result['max_salary']) if result['max_salary'] else 0,
                'avg_min': int(result['avg_min_salary']) if result['avg_min_salary'] else 0,
                'avg_max': int(result['avg_max_salary']) if result['avg_max_salary'] else 0
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

# POST - Create new job (optional, if you want to add jobs via API)
@jobs_routes.route('/api/jobs', methods=['POST'])
def create_job():
    try:
        data = request.get_json()
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        query = """
            INSERT INTO Jobs (
                job_title, job_description, salary_min, salary_max,
                remote_pref, city, application_url, employer_id, posted_at
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        
        cursor.execute(query, (
            data.get('job_title'),
            data.get('job_description'),
            data.get('salary_min'),
            data.get('salary_max'),
            data.get('remote_pref'),
            data.get('city'),
            data.get('application_url'),
            data.get('employer_id'),
            datetime.now()
        ))
        
        conn.commit()
        job_id = cursor.lastrowid
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'job_id': job_id,
            'message': 'Job created successfully'
        }), 201
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500
    
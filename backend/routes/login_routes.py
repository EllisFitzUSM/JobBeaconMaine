from flask import Blueprint, request, jsonify
from db_connection import get_db_connection
import bcrypt
import pymysql

login_routes = Blueprint("login_routes", __name__, url_prefix="/api/auth")

@login_routes.post("/login")
def login():
    data = request.get_json()

    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({"success": False, "error": "Missing username or password"}), 400

    try:
        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)

        # -------------------------------------------------------
        # Look up user by username
        # -------------------------------------------------------
        cursor.execute("SELECT * FROM USER WHERE Username = %s", (username,))
        user = cursor.fetchone()

        if not user:
            return jsonify({"success": False, "error": "Invalid username or password"}), 401

        # -------------------------------------------------------
        # Compare bcrypt hashed password
        # -------------------------------------------------------
        stored_hash = user["Password_Hash"].encode()
        entered_pw = password.encode()

        if not bcrypt.checkpw(entered_pw, stored_hash):
            return jsonify({"success": False, "error": "Invalid username or password"}), 401

        # -------------------------------------------------------
        # SUCCESS — return user info
        # -------------------------------------------------------
        user_info = {
            "User_ID": user["User_ID"],
            "Username": user["Username"],
            "Email": user["Email"],
            "City": user["City"],
            "County": user["County"]
        }

        return jsonify({"success": True, "user": user_info}), 200

    except Exception as e:
        print("LOGIN ERROR:", e)
        return jsonify({"success": False, "error": str(e)}), 500

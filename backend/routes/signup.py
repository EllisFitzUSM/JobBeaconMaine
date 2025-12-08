from flask import Blueprint, request, jsonify
from db_connection import get_db_connection
import bcrypt
import pymysql   # <-- REQUIRED FIX

signup_routes = Blueprint("signup_routes", __name__, url_prefix="/api")

@signup_routes.post("/signup")
def signup():
    data = request.get_json()

    try:
        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)  # <-- FIXED

        # ---------------------------------------------------
        # 0) CHECK IF USERNAME OR EMAIL ALREADY EXISTS
        # ---------------------------------------------------
        cursor.execute("SELECT * FROM USER WHERE Username = %s", (data["username"],))
        if cursor.fetchone():
            return jsonify({"error": "Username already exists"}), 400

        cursor.execute("SELECT * FROM USER WHERE Email = %s", (data["email"],))
        if cursor.fetchone():
            return jsonify({"error": "Email already registered"}), 400

        # ---------------------------------------------------
        # 1) HASH PASSWORD
        # ---------------------------------------------------
        raw_password = data["password"]
        hashed_password = bcrypt.hashpw(raw_password.encode(), bcrypt.gensalt()).decode()

        # ---------------------------------------------------
        # 2) INSERT INTO USER TABLE
        # ---------------------------------------------------
        sql_user = """
            INSERT INTO USER (
                Username, First_Name, Last_Name, Middle_Initial,
                Email, Password_Hash, Phone, City, County, Zip_Code
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """

        user_vals = (
            data["username"],
            data["firstName"],
            data["lastName"],
            data.get("middleInitial"),
            data["email"],
            hashed_password,
            data.get("phone"),
            data.get("city"),
            data["county"],
            data.get("zip"),
        )

        cursor.execute(sql_user, user_vals)
        user_id = cursor.lastrowid

        # ---------------------------------------------------
        # 3) INSERT INTO STUDENT_ALUM
        # ---------------------------------------------------
        sql_alum = """
            INSERT INTO STUDENT_ALUM (
                User_ID, Max_Distance_Pref, Remote_Pref,
                Salary_Min_Pref, Salary_Max_Pref
            )
            VALUES (%s, %s, %s, %s, %s)
        """

        alum_vals = (
            user_id,
            data.get("maxCommute"),
            data.get("remotePref"),
            data.get("salaryMin"),
            data.get("salaryMax"),
        )

        cursor.execute(sql_alum, alum_vals)

        # ---------------------------------------------------
        # 4) INSERT USER SKILLS (IF THEY EXIST)
        # ---------------------------------------------------
        if data.get("skills"):
            skill_list = [
                s.strip().lower()
                for s in data["skills"].split(",")
                if s.strip()
            ]

            for skill in skill_list:
                cursor.execute(
                    "SELECT idSKILL FROM SKILL WHERE LOWER(NAME) = %s",
                    (skill,)
                )
                row = cursor.fetchone()

                if row:
                    cursor.execute(
                        "INSERT INTO HAS_SKILL (idUSER, idSKILL) VALUES (%s, %s)",
                        (user_id, row["idSKILL"])
                    )
                else:
                    print(f"IGNORED unknown skill: {skill}")

        conn.commit()

        return jsonify({
            "success": True,
            "message": "Signup successful!",
            "user_id": user_id
        }), 201

    except Exception as e:
        conn.rollback()
        print("SERVER ERROR:", e)
        return jsonify({"error": str(e)}), 500

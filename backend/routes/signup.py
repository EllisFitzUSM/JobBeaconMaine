from flask import Blueprint, request, jsonify
from db_connection import get_db_connection

signup_routes = Blueprint("signup_routes", __name__, url_prefix="/api")

@signup_routes.post("/signup")
def signup():
    data = request.get_json()

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # -------------------------------------------
        # 1) INSERT INTO USER
        # -------------------------------------------
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
            data.get("middleInitial", None),
            data["email"],
            data["password"],  # hashing optional
            data.get("phone", None),
            data.get("city", None),
            data["county"],
            data.get("zip", None)
        )

        cursor.execute(sql_user, user_vals)
        user_id = cursor.lastrowid  # ← MUST USE THIS VALUE

        # -------------------------------------------
        # 2) INSERT INTO STUDENT_ALUM
        # -------------------------------------------
        sql_alum = """
            INSERT INTO STUDENT_ALUM (
                User_ID, Max_Distance_Pref, Remote_Pref,
                Salary_Min_Pref, Salary_Max_Pref
            )
            VALUES (%s, %s, %s, %s, %s)
        """

        alum_vals = (
            user_id,
            data.get("maxCommute", None),
            data.get("remotePref", None),
            data.get("salaryMin", None),
            data.get("salaryMax", None)
        )

        cursor.execute(sql_alum, alum_vals)

        # -------------------------------------------
        # 3) INSERT INTO HAS_SKILL (ONLY EXISTING SKILLS)
        # -------------------------------------------
        if data.get("skills"):
            # Convert comma-separated skills to a clean list
            skill_list = [s.strip().lower() for s in data["skills"].split(",") if s.strip()]

            for skill in skill_list:
                # Look for matching skill in SKILL table (case-insensitive)
                cursor.execute("SELECT idSKILL FROM SKILL WHERE LOWER(NAME) = %s", (skill,))
                skill_row = cursor.fetchone()

                if skill_row:
                    skill_id = skill_row["idSKILL"]

                    # Insert user-skill relationship
                    cursor.execute(
                        "INSERT INTO HAS_SKILL (idUSER, idSKILL) VALUES (%s, %s)",
                        (user_id, skill_id)
                    )
                else:
                    # Ignore unknown/misspelled skills
                    print(f"IGNORED unknown skill: {skill}")

        conn.commit()

        return jsonify({"message": "Signup successful (skills linked)!"}), 201

    except Exception as e:
        conn.rollback()
        print("SERVER ERROR:", e)  # helpful debugging print
        return jsonify({"error": str(e)}), 500

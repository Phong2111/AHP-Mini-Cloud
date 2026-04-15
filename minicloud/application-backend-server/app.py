from flask import Flask, jsonify, request
import time, requests, os, json
import pymysql
from jose import jwt

ISSUER   = os.getenv("OIDC_ISSUER",   "http://authentication-identity-server:8080/realms/master")
AUDIENCE = os.getenv("OIDC_AUDIENCE", "myapp")
JWKS_URL = f"{ISSUER}/protocol/openid-connect/certs"

DB_HOST = os.getenv("DB_HOST", "relational-database-server")
DB_PORT = int(os.getenv("DB_PORT", 3306))
DB_USER = os.getenv("DB_USER", "root")
DB_PASS = os.getenv("DB_PASS", "root")
DB_NAME = os.getenv("DB_NAME", "studentdb")

_JWKS = None; _TS = 0
def get_jwks():
    global _JWKS, _TS
    now = time.time()
    if not _JWKS or now - _TS > 600:
        _JWKS = requests.get(JWKS_URL, timeout=5).json()
        _TS = now
    return _JWKS

def get_db():
    return pymysql.connect(
        host=DB_HOST, port=DB_PORT,
        user=DB_USER, password=DB_PASS,
        database=DB_NAME, cursorclass=pymysql.cursors.DictCursor,
        connect_timeout=5
    )

app = Flask(__name__)

@app.route("/hello")
def hello():
    return jsonify(message="Hello from App Server!")

@app.route("/secure")
def secure():
    auth = request.headers.get("Authorization", "")
    if not auth.startswith("Bearer "):
        return jsonify(error="Missing Bearer token"), 401
    token = auth.split(" ", 1)[1]
    try:
        payload = jwt.decode(token, get_jwks(), algorithms=["RS256"], audience=AUDIENCE, issuer=ISSUER)
        return jsonify(message="Secure resource OK", preferred_username=payload.get("preferred_username"))
    except Exception as e:
        return jsonify(error=str(e)), 401

# ─── /student: đọc từ JSON file ───────────────────────────────────────────────
@app.route("/student")
def student():
    with open("students.json", "r", encoding="utf-8") as f:
        data = json.load(f)
    return jsonify(data)

# ─── /db/students: CRUD kết nối trực tiếp MariaDB ─────────────────────────────
@app.route("/db/students", methods=["GET"])
def db_students_get():
    try:
        conn = get_db()
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM students ORDER BY id")
            rows = cur.fetchall()
        conn.close()
        return jsonify(rows)
    except Exception as e:
        return jsonify(error=str(e)), 500

@app.route("/db/students", methods=["POST"])
def db_students_post():
    data = request.get_json()
    try:
        conn = get_db()
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO students (student_id, fullname, dob, major) VALUES (%s, %s, %s, %s)",
                (data.get("student_id"), data.get("fullname"), data.get("dob"), data.get("major"))
            )
        conn.commit(); conn.close()
        return jsonify(message="Student created"), 201
    except Exception as e:
        return jsonify(error=str(e)), 500

@app.route("/db/students/<int:sid>", methods=["DELETE"])
def db_students_delete(sid):
    try:
        conn = get_db()
        with conn.cursor() as cur:
            cur.execute("DELETE FROM students WHERE id = %s", (sid,))
        conn.commit(); conn.close()
        return jsonify(message=f"Student {sid} deleted")
    except Exception as e:
        return jsonify(error=str(e)), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8081)
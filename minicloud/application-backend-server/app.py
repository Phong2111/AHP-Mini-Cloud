from flask import Flask, jsonify
import json

app = Flask(__name__)

@app.route("/hello")
def hello():
    return jsonify(message="Hello from App Server!")

@app.route("/student")
def student():
    with open("students.json") as f:
        return jsonify(json.load(f))

app.run(host="0.0.0.0", port=8081)
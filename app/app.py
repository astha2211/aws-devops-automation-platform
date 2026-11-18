
from flask import Flask, jsonify, request
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from threading import Lock

app = Flask(__name__)

tasks = {}
task_counter = 1
lock = Lock()

REQUEST_COUNT = Counter(
    "clouddeploy_http_requests_total",
    "Total HTTP requests"
)

@app.before_request
def count_requests():
    REQUEST_COUNT.inc()


@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "project": "CloudDeploy",
        "description": "AWS DevOps Automation Platform",
        "status": "running",
        "version": "1.0.0"
    })


@app.route("/health", methods=["GET"])
def health():
    return jsonify({
        "status": "healthy",
        "service": "CloudDeploy API"
    }), 200


@app.route("/tasks", methods=["GET"])
def get_tasks():
    return jsonify(list(tasks.values())), 200


@app.route("/tasks", methods=["POST"])
def create_task():
    global task_counter

    data = request.get_json(silent=True)

    if not data or not data.get("title"):
        return jsonify({"error": "Task title is required"}), 400

    with lock:
        task = {
            "id": task_counter,
            "title": data["title"],
            "completed": False
        }
        tasks[task_counter] = task
        task_counter += 1

    return jsonify(task), 201


@app.route("/tasks/<int:task_id>", methods=["GET"])
def get_task(task_id):
    task = tasks.get(task_id)

    if not task:
        return jsonify({"error": "Task not found"}), 404

    return jsonify(task), 200


@app.route("/tasks/<int:task_id>", methods=["PUT"])
def update_task(task_id):
    task = tasks.get(task_id)

    if not task:
        return jsonify({"error": "Task not found"}), 404

    data = request.get_json(silent=True) or {}

    if "title" in data:
        task["title"] = data["title"]

    if "completed" in data:
        task["completed"] = bool(data["completed"])

    return jsonify(task), 200


@app.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    if task_id not in tasks:
        return jsonify({"error": "Task not found"}), 404

    del tasks[task_id]

    return jsonify({"message": "Task deleted"}), 200


@app.route("/metrics", methods=["GET"])
def metrics():
    return generate_latest(), 200, {
        "Content-Type": CONTENT_TYPE_LATEST
    }


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

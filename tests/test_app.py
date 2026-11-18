
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from app.app import app

import pytest


@pytest.fixture
def client():
    app.config["TESTING"] = True

    from app.app import tasks
    tasks.clear()

    with app.test_client() as client:
        yield client


def test_home(client):
    response = client.get("/")
    assert response.status_code == 200


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json["status"] == "healthy"


def test_create_task(client):
    response = client.post(
        "/tasks",
        json={"title": "Learn Docker"}
    )
    assert response.status_code == 201


def test_get_tasks(client):
    client.post("/tasks", json={"title": "Learn AWS"})
    response = client.get("/tasks")
    assert response.status_code == 200
    assert len(response.json) == 1


def test_missing_task(client):
    response = client.get("/tasks/999")
    assert response.status_code == 404


def test_update_task(client):
    created = client.post("/tasks", json={"title": "Learn Git"})
    task_id = created.json["id"]

    response = client.put(
        f"/tasks/{task_id}",
        json={"completed": True}
    )

    assert response.status_code == 200
    assert response.json["completed"] is True


def test_delete_task(client):
    created = client.post("/tasks", json={"title": "Learn Linux"})
    task_id = created.json["id"]

    response = client.delete(f"/tasks/{task_id}")
    assert response.status_code == 200


def test_metrics(client):
    response = client.get("/metrics")
    assert response.status_code == 200
    assert b"clouddeploy_http_requests_total" in response.data


def test_invalid_task(client):
    response = client.post("/tasks", json={})
    assert response.status_code == 400

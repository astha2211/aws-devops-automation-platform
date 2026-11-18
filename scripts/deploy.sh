
#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="CloudDeploy"

echo "Starting ${PROJECT_NAME} deployment..."

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker is not installed or not available."
    exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
    echo "ERROR: Docker Compose is unavailable."
    exit 1
fi

docker compose up -d --build

echo "Waiting for the API health endpoint..."

for attempt in {1..30}; do
    if curl --fail --silent http://localhost:5000/health >/dev/null; then
        echo "${PROJECT_NAME} API is healthy."
        docker compose ps
        exit 0
    fi

    sleep 2
done

echo "ERROR: API did not become healthy within 60 seconds."
docker compose logs --tail=50 app
exit 1

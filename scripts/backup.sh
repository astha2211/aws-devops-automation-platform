
#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${PROJECT_DIR}/backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE_NAME="clouddeploy_backup_${TIMESTAMP}.tar.gz"

mkdir -p "${BACKUP_DIR}"

echo "Creating CloudDeploy project backup..."

tar -czf "${BACKUP_DIR}/${ARCHIVE_NAME}" \
    --exclude='.git' \
    --exclude='.venv' \
    --exclude='venv' \
    --exclude='__pycache__' \
    --exclude='.pytest_cache' \
    --exclude='terraform/.terraform' \
    --exclude='backups' \
    -C "$(dirname "${PROJECT_DIR}")" \
    "$(basename "${PROJECT_DIR}")"

echo "Backup created successfully:"
echo "${BACKUP_DIR}/${ARCHIVE_NAME}"

echo "Backup size:"
du -h "${BACKUP_DIR}/${ARCHIVE_NAME}"

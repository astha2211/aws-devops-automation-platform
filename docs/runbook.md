\# CloudDeploy – Operations Runbook



\## 1. Purpose



This runbook explains how to start, stop, monitor, troubleshoot, and back up the CloudDeploy local environment.



\## 2. Start the Application



From the project root directory, run:



```bash

docker compose up -d --build

```



Check container status:



```bash

docker compose ps

```



Expected services:



\- clouddeploy-api

\- clouddeploy-prometheus

\- clouddeploy-grafana



The API should show a healthy status.



\## 3. Stop the Application



```bash

docker compose down

```



To also remove the named monitoring volumes:



```bash

docker compose down -v

```



\*\*Warning:\*\* The second command deletes stored Prometheus and Grafana volume data.



\## 4. Health Monitoring



Check the Flask API:



```bash

curl http://localhost:5000/health

```



Check Prometheus:



```bash

curl http://localhost:9090/-/healthy

```



Check Grafana:



```bash

curl http://localhost:3000/api/health

```



\## 5. Monitoring Access



| Component | URL |

|---|---|

| Flask API | http://localhost:5000 |

| API Health | http://localhost:5000/health |

| API Metrics | http://localhost:5000/metrics |

| Prometheus | http://localhost:9090 |

| Grafana | http://localhost:3000 |



Grafana local credentials:



\- Username: `admin`

\- Password: `[REDACTED]`



\## 6. Troubleshooting



\### Problem: API container is unhealthy



Check logs:



```bash

docker compose logs app

```



Restart the application:



```bash

docker compose restart app

```



\### Problem: Prometheus cannot scrape the API



1\. Open http://localhost:9090/targets.

2\. Check the `clouddeploy-api` target.

3\. Confirm the Flask application is running.

4\. Confirm the Prometheus target is configured as `app:5000`.

5\. Review logs:



```bash

docker compose logs prometheus

```



\### Problem: Grafana is unavailable



Check Grafana logs:



```bash

docker compose logs grafana

```



Check its health endpoint:



```bash

curl http://localhost:3000/api/health

```



\### Problem: Port is already in use



Check running containers:



```bash

docker compose ps

```



Stop the project stack:



```bash

docker compose down

```



If another application is using ports 5000, 9090, or 3000, stop that application or change the corresponding port mapping in `docker-compose.yml`.



\### Problem: Docker Compose fails to build



Check Docker:



```bash

docker --version

docker compose version

```



Review build output:



```bash

docker compose build --no-cache

```



Then start the services again:



```bash

docker compose up -d

```



\## 7. Deployment Automation



The deployment script can be executed using Git Bash:



```bash

./scripts/deploy.sh

```



It checks Docker availability, rebuilds and starts the services, and waits for the API health endpoint.



\## 8. Backup Automation



Run:



```bash

./scripts/backup.sh

```



The script creates a timestamped compressed project-file archive inside `backups/`.



The archive excludes Git history, virtual environments, caches, Terraform provider downloads, and previous backups.



\*\*Backup limitation:\*\* This script backs up project files only. It does not back up in-memory API tasks or Docker named-volume data.



\## 9. Terraform Operations



Initialize and validate Terraform:



```bash

terraform -chdir=terraform init

terraform -chdir=terraform validate

terraform -chdir=terraform fmt -check

```



No Terraform apply operation is part of the current local demonstration. AWS resources have not been provisioned.



\## 10. Kubernetes Scope



Kubernetes manifests are available in the `kubernetes/` directory.



They define a Namespace, Deployment, and NodePort Service. They have been checked for YAML syntax but have not been applied to a Kubernetes cluster.



\## 11. Operational Notes



\- Keep Docker Desktop running before starting the stack.

\- Do not commit credentials or local Terraform variable files.

\- Keep `.terraform.lock.hcl` under version control.

\- Do not commit virtual environments or backup archives.

\- Change default Grafana credentials before any broader deployment.




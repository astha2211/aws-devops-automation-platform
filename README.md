# CloudDeploy - AWS-Based DevOps Automation & Monitoring Platform



![Python](https://img.shields.io/badge/Python-3.12-blue)

![Flask](https://img.shields.io/badge/Flask-3.1-black)

![Docker](https://img.shields.io/badge/Docker-Containerized-blue)

![Terraform](https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-purple)

![Monitoring](https://img.shields.io/badge/Monitoring-Prometheus%20%7C%20Grafana-orange)

![Tests](https://img.shields.io/badge/Tests-9%20Passed-brightgreen)



## Overview



CloudDeploy is a DevOps automation and monitoring project designed to demonstrate how application deployment, infrastructure configuration, containerization, CI automation, and monitoring can work together.



The project uses a Python Flask REST API as its application, Docker and Docker Compose for containerization, GitHub Actions for continuous integration, Terraform for AWS infrastructure definition, and Prometheus and Grafana for monitoring.



The complete application stack can be built and tested locally without provisioning paid AWS resources.



## Problem Statement



Manual application deployment and infrastructure management can lead to inconsistent environments, configuration errors, deployment failures, and limited visibility into application health.



CloudDeploy demonstrates an integrated DevOps workflow that automates application testing and container builds, defines cloud infrastructure as code, and provides application monitoring.



## Architecture



The project workflow:



1. Developer pushes code to GitHub.

2. GitHub Actions runs automated Python tests.

3. GitHub Actions builds the Docker image.

4. Docker Compose runs the application and monitoring services locally.

5. Prometheus collects application metrics.

6. Grafana visualizes monitoring data.

7. Terraform defines the AWS infrastructure configuration.

8. Bash scripts automate deployment and project backups.



## Technology Stack



| Category | Technologies |
|---|---|
| Application | Python, Flask, REST API |
| Testing | Pytest |
| Containerization | Docker, Docker Compose |
| CI | GitHub Actions |
| Infrastructure as Code | Terraform, AWS Provider |
| Cloud Infrastructure | AWS EC2, S3, IAM, VPC, Security Groups |
| Monitoring | Prometheus, Grafana |
| Orchestration | Kubernetes manifests |
| Scripting | Bash |
| Version Control | Git, GitHub |



## Project Features



### 1. Flask REST API

- Application homepage

- Health-check endpoint

- Task creation and retrieval

- Task update and deletion

- Prometheus metrics endpoint



### 2. Docker

- Custom Docker image

- Lightweight Python base image

- Non-root application user

- Container health check



### 3. Docker Compose

Runs three services:

- Flask application

- Prometheus

- Grafana



### 4. CI Pipeline

GitHub Actions automatically:

- Installs Python dependencies

- Runs the Pytest suite

- Builds the Docker image



### 5. Terraform

Defines AWS infrastructure configuration for:

- VPC and public subnet

- Internet gateway and routing

- Security group

- EC2 instance

- IAM role and instance profile

- S3 backup bucket with versioning and encryption



### 6. Monitoring

- Prometheus metrics collection

- Grafana dashboard

- HTTP request monitoring

- API availability monitoring



### 7. Automation Scripts

- `deploy.sh`: Builds and starts the Docker Compose stack and checks API health.

- `backup.sh`: Creates a compressed project-file backup.



### 8. Kubernetes

Includes basic Kubernetes manifests:

- Namespace

- Deployment

- NodePort Service

- Readiness and liveness probes

- Container resource requests and limits



## Project Structure



```text

aws-devops-automation-platform/

â”‚

â”œâ”€â”€ app/

â”‚   â”œâ”€â”€ app.py

â”‚   â””â”€â”€ requirements.txt

â”‚

â”œâ”€â”€ tests/

â”‚   â””â”€â”€ test_app.py

â”‚

â”œâ”€â”€ docker/

â”‚   â””â”€â”€ Dockerfile

â”‚

â”œâ”€â”€ terraform/

â”‚   â”œâ”€â”€ main.tf

â”‚   â”œâ”€â”€ variables.tf

â”‚   â”œâ”€â”€ outputs.tf

â”‚   â”œâ”€â”€ provider.tf

â”‚   â”œâ”€â”€ terraform.tfvars.example

â”‚   â””â”€â”€ .terraform.lock.hcl

â”‚

â”œâ”€â”€ monitoring/

â”‚   â”œâ”€â”€ prometheus.yml

â”‚   â””â”€â”€ grafana/

â”‚

â”œâ”€â”€ kubernetes/

â”‚   â”œâ”€â”€ namespace.yaml

â”‚   â”œâ”€â”€ deployment.yaml

â”‚   â””â”€â”€ service.yaml

â”‚

â”œâ”€â”€ scripts/

â”‚   â”œâ”€â”€ deploy.sh

â”‚   â””â”€â”€ backup.sh

â”‚

â”œâ”€â”€ .github/

â”‚   â””â”€â”€ workflows/

â”‚       â””â”€â”€ deploy.yml

â”‚

â”œâ”€â”€ docs/

â”œâ”€â”€ screenshots/

â”œâ”€â”€ docker-compose.yml

â”œâ”€â”€ Dockerfile

â”œâ”€â”€ .dockerignore

â”œâ”€â”€ .gitignore

â””â”€â”€ README.md

```



## Local Setup



### Prerequisites



- Python 3.12+

- Docker Desktop

- Git

- Terraform 1.5+



### 1. Clone the repository



```bash

git clone https://github.com/YOUR_USERNAME/aws-devops-automation-platform.git

cd aws-devops-automation-platform

```



### 2. Create a virtual environment



```bash

python -m venv .venv

```



Activate on Windows PowerShell:



```powershell

.venv\\Scripts\\Activate.ps1

```



### 3. Install dependencies



```bash

pip install -r app/requirements.txt

```



### 4. Run automated tests



```bash

python -m pytest tests/ -v

```



### 5. Start the application stack



```bash

docker compose up -d --build

```



### 6. Access the services



| Service | Local URL ||---|---|| Flask API | http://localhost:5000 || Health Check | http://localhost:5000/health || API Metrics | http://localhost:5000/metrics || Prometheus | http://localhost:9090 || Grafana | http://localhost:3000 |



Grafana default local credentials:



- Username: `admin`
- Password: Set locally using the `GF_SECURITY_ADMIN_PASSWORD` environment variable in `.env`.



Change the default password before using this configuration beyond local development.



### 7. Stop services



```bash

docker compose down

```



## Terraform Validation



Terraform configuration is included to demonstrate Infrastructure as Code.



Initialize and validate:



```bash

terraform -chdir=terraform init

terraform -chdir=terraform validate

terraform -chdir=terraform fmt -check

```



**Important:** AWS infrastructure is defined but has not been provisioned. Terraform validation does not mean that AWS resources have been deployed.



## Testing Results



The Flask API test suite currently contains 9 tests covering:



- Homepage

- Health endpoint

- Task creation

- Task retrieval

- Missing task handling

- Task updates

- Task deletion

- Prometheus metrics

- Invalid task input



Latest local test result: **9 passed**.



Docker Compose services and the application health endpoint have also been tested locally.



## Screenshots



Monitoring dashboard screenshots are available in the `screenshots/` directory.



## Cost and Deployment Scope



This project is designed for local execution and demonstration.



- No AWS resources have been provisioned.

- No paid cloud deployment is required.

- Terraform configurations are provided for infrastructure definition and validation.

- CI runs tests and builds a Docker image; it does not deploy to AWS.



## Future Improvements



- Add persistent database storage.

- Add authentication and authorization.

- Add production WSGI server configuration.

- Add automated Grafana dashboard provisioning.

- Extend Kubernetes deployment testing.

- Implement a cloud deployment pipeline when AWS infrastructure is available.



## Author



**Astha Mehra**



B.Tech - Artificial Intelligence and Data Science



GitHub: https://github.com/astha2211





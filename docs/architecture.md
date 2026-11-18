\# CloudDeploy – System Architecture



\## Architecture Diagram



```mermaid

flowchart TD

&#x20;   A\[Developer] --> B\[GitHub Repository]



&#x20;   B --> C\[GitHub Actions CI]

&#x20;   C --> D\[Run Pytest]

&#x20;   D --> E\[Build Docker Image]



&#x20;   E --> F\[Docker Compose]



&#x20;   subgraph Local Environment

&#x20;       F --> G\[Flask REST API]

&#x20;       F --> H\[Prometheus]

&#x20;       F --> I\[Grafana]



&#x20;       G --> J\[Health Endpoint]

&#x20;       G --> K\[Metrics Endpoint]

&#x20;       K --> H

&#x20;       H --> I

&#x20;   end



&#x20;   B --> L\[Terraform Configuration]

&#x20;   L --> M\[AWS Infrastructure Definitions]



&#x20;   B --> N\[Bash Automation Scripts]

&#x20;   N --> F



&#x20;   O\[Kubernetes Manifests] --> P\[Kubernetes Deployment Configuration]

```



\## Architecture Components



| Component | Responsibility |

|---|---|

| GitHub | Source code and version control |

| GitHub Actions | Automated tests and Docker image build |

| Flask | REST API and health endpoint |

| Docker | Application containerization |

| Docker Compose | Local multi-container orchestration |

| Prometheus | Metrics collection |

| Grafana | Monitoring dashboards |

| Terraform | AWS infrastructure definitions |

| Bash | Deployment and backup automation |

| Kubernetes | Container orchestration manifests |



\## Execution Flow



1\. Developers commit and push changes to GitHub.

2\. GitHub Actions runs the automated test suite.

3\. After successful tests, the workflow builds the Docker image.

4\. Docker Compose runs the Flask API, Prometheus, and Grafana locally.

5\. Prometheus collects application metrics from the API.

6\. Grafana displays the monitoring information.

7\. Terraform provides the configuration for the proposed AWS infrastructure.

8\. Bash scripts automate local deployment and project-file backups.



\## Deployment Scope



The current implementation is designed for local execution. AWS infrastructure is defined using Terraform but has not been provisioned. Kubernetes manifests are included but have not been deployed to a cluster.





variable "aws_region" {
  description = "AWS region for CloudDeploy infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "clouddeploy"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "development"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to access SSH; replace with your trusted public IP/32 before deployment"
  type        = string
  default     = "127.0.0.1/32"

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "allowed_ssh_cidr must be a valid CIDR block."
  }
}

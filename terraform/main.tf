
# Generate a unique suffix for the S3 bucket name.
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# VPC
resource "aws_vpc" "clouddeploy_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# Public subnet
resource "aws_subnet" "clouddeploy_public_subnet" {
  vpc_id                  = aws_vpc.clouddeploy_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Internet gateway
resource "aws_internet_gateway" "clouddeploy_igw" {
  vpc_id = aws_vpc.clouddeploy_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public route table
resource "aws_route_table" "clouddeploy_route_table" {
  vpc_id = aws_vpc.clouddeploy_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.clouddeploy_igw.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.clouddeploy_public_subnet.id
  route_table_id = aws_route_table.clouddeploy_route_table.id
}

# Security group
resource "aws_security_group" "clouddeploy_sg" {
  name        = "${var.project_name}-security-group"
  description = "Security group for CloudDeploy EC2"
  vpc_id      = aws_vpc.clouddeploy_vpc.id

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Restricted SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 IAM role
resource "aws_iam_role" "clouddeploy_ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

# S3 bucket
resource "aws_s3_bucket" "clouddeploy_bucket" {
  bucket = "${var.project_name}-backups-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-backups"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "clouddeploy_versioning" {
  bucket = aws_s3_bucket.clouddeploy_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "clouddeploy_encryption" {
  bucket = aws_s3_bucket.clouddeploy_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "clouddeploy_public_access" {
  bucket = aws_s3_bucket.clouddeploy_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Allow EC2 to access only the project backup bucket.
resource "aws_iam_role_policy" "clouddeploy_s3_policy" {
  name = "${var.project_name}-s3-backup-policy"
  role = aws_iam_role.clouddeploy_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.clouddeploy_bucket.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.clouddeploy_bucket.arn}/*"
      }
    ]
  })
}

# EC2 instance profile
resource "aws_iam_instance_profile" "clouddeploy_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.clouddeploy_ec2_role.name
}

# EC2 instance
resource "aws_instance" "clouddeploy_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.clouddeploy_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.clouddeploy_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.clouddeploy_profile.name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.project_name}-server"
    Environment = var.environment
  }
}

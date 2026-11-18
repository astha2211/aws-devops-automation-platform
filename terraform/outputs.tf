
output "vpc_id" {
  description = "CloudDeploy VPC ID"
  value       = aws_vpc.clouddeploy_vpc.id
}

output "public_subnet_id" {
  description = "CloudDeploy public subnet ID"
  value       = aws_subnet.clouddeploy_public_subnet.id
}

output "security_group_id" {
  description = "CloudDeploy security group ID"
  value       = aws_security_group.clouddeploy_sg.id
}

output "ec2_instance_id" {
  description = "CloudDeploy EC2 instance ID"
  value       = aws_instance.clouddeploy_server.id
}

output "ec2_public_ip" {
  description = "CloudDeploy EC2 public IP"
  value       = aws_instance.clouddeploy_server.public_ip
}

output "s3_bucket_name" {
  description = "CloudDeploy backup bucket name"
  value       = aws_s3_bucket.clouddeploy_bucket.bucket
}

output "iam_role_arn" {
  description = "CloudDeploy EC2 IAM role ARN"
  value       = aws_iam_role.clouddeploy_ec2_role.arn
}

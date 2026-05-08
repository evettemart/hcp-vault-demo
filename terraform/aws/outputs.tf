output "aws_region_1" {
  description = "AWS Region 1"
  value       = var.aws_region_1
}

output "aws_region_2" {
  description = "AWS Region 2"
  value       = var.aws_region_2
}

output "aws_region_3" {
  description = "AWS Region 3"
  value       = var.aws_region_3
}

output "vpc_region_1_id" {
  description = "Region 1 VPC ID"
  value       = aws_vpc.region_1.id
}

output "vpc_region_1_cidr_block" {
  description = "Region 1 VPC CIDR"
  value       = aws_vpc.region_1.cidr_block
}

output "public_subnet_region_1_id" {
  description = "Region 1 public subnet ID"
  value       = aws_subnet.public_region_1.id
}

output "private_subnet_region_1_id" {
  description = "Region 1 private subnet ID"
  value       = aws_subnet.private_region_1.id
}

output "vpc_region_2_id" {
  description = "Region 2 VPC ID"
  value       = aws_vpc.region_2.id
}

output "vpc_region_2_cidr_block" {
  description = "Region 2 VPC CIDR"
  value       = aws_vpc.region_2.cidr_block
}

output "public_subnet_region_2_id" {
  description = "Region 2 public subnet ID"
  value       = aws_subnet.public_region_2.id
}

output "private_subnet_region_2_id" {
  description = "Region 2 private subnet ID"
  value       = aws_subnet.private_region_2.id
}

output "vpc_region_3_id" {
  description = "Region 3 VPC ID"
  value       = aws_vpc.region_3.id
}

output "vpc_region_3_cidr_block" {
  description = "Region 3 VPC CIDR"
  value       = aws_vpc.region_3.cidr_block
}

output "public_subnet_region_3_id" {
  description = "Region 3 public subnet ID"
  value       = aws_subnet.public_region_3.id
}

output "private_subnet_region_3_id" {
  description = "Region 3 private subnet ID"
  value       = aws_subnet.private_region_3.id
}

output "aws_account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

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

output "aws_region_4" {
  description = "AWS Region 4"
  value       = var.aws_region_4
}

output "aws_region_5" {
  description = "AWS Region 5"
  value       = var.aws_region_5
}

output "aws_region_6" {
  description = "AWS Region 6"
  value       = var.aws_region_6
}

output "vpc_region_1_id" {
  description = "Region 1 VPC ID"
  value       = module.region_1_network.vpc_id
}

output "vpc_region_1_cidr_block" {
  description = "Region 1 VPC CIDR"
  value       = module.region_1_network.vpc_cidr_block
}

output "public_subnet_region_1_id" {
  description = "Region 1 public subnet ID"
  value       = module.region_1_network.public_subnet_id
}

output "private_subnet_region_1_id" {
  description = "Region 1 private subnet ID"
  value       = module.region_1_network.private_subnet_id
}

output "vpc_region_2_id" {
  description = "Region 2 VPC ID"
  value       = module.region_2_network.vpc_id
}

output "vpc_region_2_cidr_block" {
  description = "Region 2 VPC CIDR"
  value       = module.region_2_network.vpc_cidr_block
}

output "public_subnet_region_2_id" {
  description = "Region 2 public subnet ID"
  value       = module.region_2_network.public_subnet_id
}

output "private_subnet_region_2_id" {
  description = "Region 2 private subnet ID"
  value       = module.region_2_network.private_subnet_id
}

output "vpc_region_3_id" {
  description = "Region 3 VPC ID"
  value       = try(module.region_3_network[0].vpc_id, null)
}

output "vpc_region_3_cidr_block" {
  description = "Region 3 VPC CIDR"
  value       = try(module.region_3_network[0].vpc_cidr_block, null)
}

output "public_subnet_region_3_id" {
  description = "Region 3 public subnet ID"
  value       = try(module.region_3_network[0].public_subnet_id, null)
}

output "private_subnet_region_3_id" {
  description = "Region 3 private subnet ID"
  value       = try(module.region_3_network[0].private_subnet_id, null)
}

output "vpc_region_4_id" {
  description = "Region 4 VPC ID"
  value       = try(module.region_4_network[0].vpc_id, null)
}

output "vpc_region_4_cidr_block" {
  description = "Region 4 VPC CIDR"
  value       = try(module.region_4_network[0].vpc_cidr_block, null)
}

output "public_subnet_region_4_id" {
  description = "Region 4 public subnet ID"
  value       = try(module.region_4_network[0].public_subnet_id, null)
}

output "private_subnet_region_4_id" {
  description = "Region 4 private subnet ID"
  value       = try(module.region_4_network[0].private_subnet_id, null)
}

output "vpc_region_5_id" {
  description = "Region 5 VPC ID"
  value       = try(module.region_5_network[0].vpc_id, null)
}

output "vpc_region_5_cidr_block" {
  description = "Region 5 VPC CIDR"
  value       = try(module.region_5_network[0].vpc_cidr_block, null)
}

output "public_subnet_region_5_id" {
  description = "Region 5 public subnet ID"
  value       = try(module.region_5_network[0].public_subnet_id, null)
}

output "private_subnet_region_5_id" {
  description = "Region 5 private subnet ID"
  value       = try(module.region_5_network[0].private_subnet_id, null)
}

output "vpc_region_6_id" {
  description = "Region 6 VPC ID"
  value       = try(module.region_6_network[0].vpc_id, null)
}

output "vpc_region_6_cidr_block" {
  description = "Region 6 VPC CIDR"
  value       = try(module.region_6_network[0].vpc_cidr_block, null)
}

output "public_subnet_region_6_id" {
  description = "Region 6 public subnet ID"
  value       = try(module.region_6_network[0].public_subnet_id, null)
}

output "private_subnet_region_6_id" {
  description = "Region 6 private subnet ID"
  value       = try(module.region_6_network[0].private_subnet_id, null)
}

output "aws_account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "tgw_region_1_id" {
  description = "Region 1 Transit Gateway ID"
  value       = module.tgw_region_1.transit_gateway_id
}

output "tgw_region_2_id" {
  description = "Region 2 Transit Gateway ID"
  value       = module.tgw_region_2.transit_gateway_id
}

output "tgw_region_3_id" {
  description = "Region 3 Transit Gateway ID"
  value       = try(module.tgw_region_3[0].transit_gateway_id, null)
}

output "tgw_region_4_id" {
  description = "Region 4 Transit Gateway ID"
  value       = try(module.tgw_region_4[0].transit_gateway_id, null)
}

output "tgw_region_5_id" {
  description = "Region 5 Transit Gateway ID"
  value       = try(module.tgw_region_5[0].transit_gateway_id, null)
}

output "tgw_region_6_id" {
  description = "Region 6 Transit Gateway ID"
  value       = try(module.tgw_region_6[0].transit_gateway_id, null)
}

output "tgw_region_1_share_arn" {
  description = "Region 1 RAM share ARN for TGW"
  value       = module.tgw_region_1.resource_share_arn
}

output "tgw_region_2_share_arn" {
  description = "Region 2 RAM share ARN for TGW"
  value       = module.tgw_region_2.resource_share_arn
}

output "tgw_region_3_share_arn" {
  description = "Region 3 RAM share ARN for TGW"
  value       = try(module.tgw_region_3[0].resource_share_arn, null)
}

output "tgw_region_4_share_arn" {
  description = "Region 4 RAM share ARN for TGW"
  value       = try(module.tgw_region_4[0].resource_share_arn, null)
}

output "tgw_region_5_share_arn" {
  description = "Region 5 RAM share ARN for TGW"
  value       = try(module.tgw_region_5[0].resource_share_arn, null)
}

output "tgw_region_6_share_arn" {
  description = "Region 6 RAM share ARN for TGW"
  value       = try(module.tgw_region_6[0].resource_share_arn, null)
}

variable "aws_region_1" {
  description = "AWS region for Region 1 resources"
  type        = string
  default     = "eu-west-1"
}

variable "aws_region_2" {
  description = "AWS region for Region 2 resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_region_3" {
  description = "AWS region for Region 3 resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "name_prefix" {
  description = "Prefix used for resource names"
  type        = string
  default     = "vault-hcp-demo"
}

variable "vpc_region_1_cidr_block" {
  description = "CIDR for Region 1 AWS VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_region_1_cidr" {
  description = "CIDR for Region 1 public subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_region_1_cidr" {
  description = "CIDR for Region 1 private subnet"
  type        = string
  default     = "10.20.2.0/24"
}

variable "vpc_region_2_cidr_block" {
  description = "CIDR for Region 2 AWS VPC"
  type        = string
  default     = "10.21.0.0/16"
}

variable "public_subnet_region_2_cidr" {
  description = "CIDR for Region 2 public subnet"
  type        = string
  default     = "10.21.1.0/24"
}

variable "private_subnet_region_2_cidr" {
  description = "CIDR for Region 2 private subnet"
  type        = string
  default     = "10.21.2.0/24"
}

variable "vpc_region_3_cidr_block" {
  description = "CIDR for Region 3 AWS VPC"
  type        = string
  default     = "10.22.0.0/16"
}

variable "public_subnet_region_3_cidr" {
  description = "CIDR for Region 3 public subnet"
  type        = string
  default     = "10.22.1.0/24"
}

variable "private_subnet_region_3_cidr" {
  description = "CIDR for Region 3 private subnet"
  type        = string
  default     = "10.22.2.0/24"
}

variable "enable_hcp_peering_acceptance" {
  description = "Enable accepting HCP peering requests in AWS"
  type        = bool
  default     = false
}

variable "enable_hcp_routes" {
  description = "Enable creating routes from AWS route tables to all HVN CIDRs"
  type        = bool
  default     = false
}

variable "hvn_region_1_primary_cidr" {
  description = "CIDR for primary HVN in Region 1"
  type        = string
  default     = "172.25.16.0/20"
}

variable "hvn_region_2_primary_cidr" {
  description = "CIDR for primary HVN in Region 2"
  type        = string
  default     = "172.26.16.0/20"
}

variable "hvn_region_3_primary_cidr" {
  description = "CIDR for primary HVN in Region 3"
  type        = string
  default     = "172.27.16.0/20"
}

variable "hvn_region_2_dr_for_region_1_cidr" {
  description = "CIDR for DR secondary HVN in Region 2 serving Region 1"
  type        = string
  default     = "172.28.16.0/20"
}

variable "hvn_region_3_dr_for_region_2_cidr" {
  description = "CIDR for DR secondary HVN in Region 3 serving Region 2"
  type        = string
  default     = "172.29.16.0/20"
}

variable "hvn_region_1_dr_for_region_3_cidr" {
  description = "CIDR for DR secondary HVN in Region 1 serving Region 3"
  type        = string
  default     = "172.30.16.0/20"
}

variable "tags" {
  description = "Tags applied to AWS resources"
  type        = map(string)
  default = {
    Environment = "prod"
    ManagedBy   = "terraform"
    Project     = "hcp-vault-demo"
  }
}

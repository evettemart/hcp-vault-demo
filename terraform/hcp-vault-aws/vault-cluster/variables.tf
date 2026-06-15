variable "project_id" {
  description = "HCP project ID"
  type        = string
}

variable "topology_scenario" {
  description = "Deployment topology scenario. Use full for 3-region topology, dr_pair_r1_r2 for region1 primary + region2 secondary pair."
  type        = string
  default     = "full"

  validation {
    condition     = contains(["full", "dr_pair_r1_r2"], var.topology_scenario)
    error_message = "topology_scenario must be one of: full, dr_pair_r1_r2."
  }
}

variable "enable_hvn_peering" {
  description = "Enable HVN peering connectivity to AWS Transit Gateways (attachments and HVN routes)"
  type        = bool
  default     = true
}

variable "aws_tgw_region_1_id" {
  description = "AWS Transit Gateway ID for Region 1"
  type        = string
  default     = null
}

variable "aws_tgw_region_2_id" {
  description = "AWS Transit Gateway ID for Region 2"
  type        = string
  default     = null
}

variable "aws_tgw_region_3_id" {
  description = "AWS Transit Gateway ID for Region 3 (required when topology_scenario is full)"
  type        = string
  default     = null
}

variable "aws_tgw_region_1_share_arn" {
  description = "AWS RAM share ARN for Region 1 Transit Gateway"
  type        = string
  default     = null
}

variable "aws_tgw_region_2_share_arn" {
  description = "AWS RAM share ARN for Region 2 Transit Gateway"
  type        = string
  default     = null
}

variable "aws_tgw_region_3_share_arn" {
  description = "AWS RAM share ARN for Region 3 Transit Gateway (required when topology_scenario is full)"
  type        = string
  default     = null
}

variable "aws_vpc_region_1_cidr_block" {
  description = "AWS VPC CIDR block for Region 1"
  type        = string
  default     = null
}

variable "aws_vpc_region_2_cidr_block" {
  description = "AWS VPC CIDR block for Region 2"
  type        = string
  default     = null
}

variable "aws_vpc_region_3_cidr_block" {
  description = "AWS VPC CIDR block for Region 3 (required when topology_scenario is full)"
  type        = string
  default     = null
}

variable "region_1_primary_hvn_id" {
  description = "HVN ID for Region 1 primary cluster"
  type        = string
  default     = "vault-r1-primary-hvn"
}

variable "region_1_primary_hvn_region" {
  description = "HCP region for Region 1 primary HVN"
  type        = string
  default     = "eu-west-1"
}

variable "region_1_primary_hvn_cidr" {
  description = "CIDR for Region 1 primary HVN"
  type        = string
  default     = "172.25.16.0/20"
}

variable "region_1_primary_cluster_id" {
  description = "Cluster ID for Region 1 performance primary"
  type        = string
  default     = "vault-r1-primary"
}

variable "region_1_primary_cluster_tier" {
  description = "Tier for Region 1 performance primary"
  type        = string
  default     = "plus_small"
}

variable "region_2_primary_hvn_id" {
  description = "HVN ID for Region 2 performance secondary / DR primary"
  type        = string
  default     = "vault-r2-primary-hvn"
}

variable "region_2_primary_hvn_region" {
  description = "HCP region for Region 2 primary HVN"
  type        = string
  default     = "us-east-1"
}

variable "region_2_primary_hvn_cidr" {
  description = "CIDR for Region 2 primary HVN"
  type        = string
  default     = "172.26.16.0/20"
}

variable "region_2_primary_cluster_id" {
  description = "Cluster ID for Region 2 performance secondary"
  type        = string
  default     = "vault-r2-primary"
}

variable "region_2_primary_cluster_tier" {
  description = "Tier for Region 2 performance secondary"
  type        = string
  default     = "plus_small"
}

variable "region_3_primary_hvn_id" {
  description = "HVN ID for Region 3 performance secondary / DR primary"
  type        = string
  default     = "vault-r3-primary-hvn"
}

variable "region_3_primary_hvn_region" {
  description = "HCP region for Region 3 primary HVN"
  type        = string
  default     = "ap-southeast-1"
}

variable "region_3_primary_hvn_cidr" {
  description = "CIDR for Region 3 primary HVN"
  type        = string
  default     = "172.27.16.0/20"
}

variable "region_3_primary_cluster_id" {
  description = "Cluster ID for Region 3 performance secondary"
  type        = string
  default     = "vault-r3-primary"
}

variable "region_3_primary_cluster_tier" {
  description = "Tier for Region 3 performance secondary"
  type        = string
  default     = "plus_small"
}

variable "region_2_dr_for_region_1_hvn_id" {
  description = "HVN ID for DR secondary in Region 2 serving Region 1"
  type        = string
  default     = "vault-r2-dr-for-r1-hvn"
}

variable "region_2_dr_for_region_1_hvn_region" {
  description = "HCP region for DR secondary HVN in Region 2 serving Region 1"
  type        = string
  default     = "us-east-1"
}

variable "region_2_dr_for_region_1_hvn_cidr" {
  description = "CIDR for DR secondary HVN in Region 2 serving Region 1"
  type        = string
  default     = "172.28.16.0/20"
}

variable "region_3_dr_for_region_2_hvn_id" {
  description = "HVN ID for DR secondary in Region 3 serving Region 2"
  type        = string
  default     = "vault-r3-dr-for-r2-hvn"
}

variable "region_3_dr_for_region_2_hvn_region" {
  description = "HCP region for DR secondary HVN in Region 3 serving Region 2"
  type        = string
  default     = "ap-southeast-1"
}

variable "region_3_dr_for_region_2_hvn_cidr" {
  description = "CIDR for DR secondary HVN in Region 3 serving Region 2"
  type        = string
  default     = "172.29.16.0/20"
}

variable "region_1_dr_for_region_3_hvn_id" {
  description = "HVN ID for DR secondary in Region 1 serving Region 3"
  type        = string
  default     = "vault-r1-dr-for-r3-hvn"
}

variable "region_1_dr_for_region_3_hvn_region" {
  description = "HCP region for DR secondary HVN in Region 1 serving Region 3"
  type        = string
  default     = "eu-west-1"
}

variable "region_1_dr_for_region_3_hvn_cidr" {
  description = "CIDR for DR secondary HVN in Region 1 serving Region 3"
  type        = string
  default     = "172.30.16.0/20"
}

variable "vault_public_endpoint" {
  description = "Enable public endpoint"
  type        = bool
  default     = false
}

variable "vault_proxy_endpoint" {
  description = "Proxy endpoint mode"
  type        = string
  default     = "DISABLED"
}

variable "vault_min_vault_version" {
  description = "Optional minimum Vault version"
  type        = string
  default     = null
}

variable "vault_ip_allowlist" {
  description = "IP allowlist for public endpoint"
  type = list(object({
    address     = string
    description = optional(string)
  }))
  default = []
}

variable "region_1_primary_to_aws_tgw_attachment_id" {
  description = "Transit gateway attachment ID for Region 1 primary HVN"
  type        = string
  default     = "r1-primary-to-aws-tgw"
}

variable "region_2_primary_to_aws_tgw_attachment_id" {
  description = "Transit gateway attachment ID for Region 2 primary HVN"
  type        = string
  default     = "r2-primary-to-aws-tgw"
}

variable "region_3_primary_to_aws_tgw_attachment_id" {
  description = "Transit gateway attachment ID for Region 3 primary HVN"
  type        = string
  default     = "r3-primary-to-aws-tgw"
}

variable "region_2_dr_for_region_1_to_aws_tgw_attachment_id" {
  description = "Transit gateway attachment ID for Region 2 DR HVN serving Region 1"
  type        = string
  default     = "r2-dr-for-r1-to-aws-tgw"
}

variable "region_3_dr_for_region_2_to_aws_tgw_attachment_id" {
  description = "Transit gateway attachment ID for Region 3 DR HVN serving Region 2"
  type        = string
  default     = "r3-dr-for-r2-to-aws-tgw"
}

variable "region_1_dr_for_region_3_to_aws_tgw_attachment_id" {
  description = "Transit gateway attachment ID for Region 1 DR HVN serving Region 3"
  type        = string
  default     = "r1-dr-for-r3-to-aws-tgw"
}

variable "region_1_primary_to_aws_route_id" {
  description = "Route ID from Region 1 primary HVN to AWS VPC"
  type        = string
  default     = "r1-primary-to-aws-vpc"
}

variable "region_2_primary_to_aws_route_id" {
  description = "Route ID from Region 2 primary HVN to AWS VPC"
  type        = string
  default     = "r2-primary-to-aws-vpc"
}

variable "region_3_primary_to_aws_route_id" {
  description = "Route ID from Region 3 primary HVN to AWS VPC"
  type        = string
  default     = "r3-primary-to-aws-vpc"
}

variable "region_2_dr_for_region_1_to_aws_route_id" {
  description = "Route ID from Region 2 DR HVN (for Region 1) to AWS VPC"
  type        = string
  default     = "r2-dr-for-r1-to-aws-vpc"
}

variable "region_3_dr_for_region_2_to_aws_route_id" {
  description = "Route ID from Region 3 DR HVN (for Region 2) to AWS VPC"
  type        = string
  default     = "r3-dr-for-r2-to-aws-vpc"
}

variable "region_1_dr_for_region_3_to_aws_route_id" {
  description = "Route ID from Region 1 DR HVN (for Region 3) to AWS VPC"
  type        = string
  default     = "r1-dr-for-r3-to-aws-vpc"
}

locals {
  hvn_peering_requires_region_1_2_inputs = (
    !var.enable_hvn_peering || (
      var.aws_tgw_region_1_id != null &&
      var.aws_tgw_region_2_id != null &&
      var.aws_tgw_region_1_share_arn != null &&
      var.aws_tgw_region_2_share_arn != null &&
      var.aws_vpc_region_1_cidr_block != null &&
      var.aws_vpc_region_2_cidr_block != null
    )
  )

  full_topology_requires_region_3_inputs = (
    !var.enable_hvn_peering || var.topology_scenario != "full" || (
      var.aws_tgw_region_3_id != null &&
      var.aws_tgw_region_3_share_arn != null &&
      var.aws_vpc_region_3_cidr_block != null
    )
  )
}

check "hvn_peering_region_1_2_inputs" {
  assert {
    condition     = local.hvn_peering_requires_region_1_2_inputs
    error_message = "When enable_hvn_peering is true, aws_tgw_region_1_id, aws_tgw_region_2_id, aws_tgw_region_1_share_arn, aws_tgw_region_2_share_arn, aws_vpc_region_1_cidr_block, and aws_vpc_region_2_cidr_block must be set."
  }
}

check "full_topology_region_3_inputs" {
  assert {
    condition     = local.full_topology_requires_region_3_inputs
    error_message = "When topology_scenario is full, aws_tgw_region_3_id, aws_tgw_region_3_share_arn, and aws_vpc_region_3_cidr_block must be set."
  }
}

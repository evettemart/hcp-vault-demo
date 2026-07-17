variable "aws_region_1" {
  description = "AWS region for Region 1 resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_region_2" {
  description = "AWS region for Region 2 resources"
  type        = string
  default     = "eu-west-1"
}

variable "aws_region_3" {
  description = "AWS region for Region 3 resources"
  type        = string
  default     = "us-east-1"
}

variable "enable_region_3" {
  description = "Enable Region 3 AWS network and TGW resources in prod topology"
  type        = bool
  default     = false
}

variable "aws_region_4" {
  description = "AWS region for Region 4 resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_region_5" {
  description = "AWS region for Region 5 resources"
  type        = string
  default     = "eu-west-2"
}

variable "aws_region_6" {
  description = "AWS region for Region 6 resources"
  type        = string
  default     = "us-east-2"
}

variable "enable_region_4" {
  description = "Enable Region 4 AWS network and TGW resources in prod topology"
  type        = bool
  default     = false
}

variable "enable_region_5" {
  description = "Enable Region 5 AWS network and TGW resources in prod topology"
  type        = bool
  default     = false
}

variable "enable_region_6" {
  description = "Enable Region 6 AWS network and TGW resources in prod topology"
  type        = bool
  default     = false
}

variable "name_prefix" {
  description = "Prefix used for resource names"
  type        = string
  default     = "vault-hcp-demo"
}

variable "environment" {
  description = "Deployment environment name used for tagging"
  type        = string
  default     = "prod"
}

variable "topology_scenario" {
  description = "Deployment topology scenario. Use prod for full deployment and non-prod for reduced deployment."
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["prod", "non-prod"], var.topology_scenario)
    error_message = "topology_scenario must be one of: prod, non-prod."
  }
}

variable "vpc_region_1_cidr_block" {
  description = "CIDR for Region 1 AWS VPC"
  type        = string
  default     = "10.20.0.0/24"
}

variable "public_subnet_region_1_cidr" {
  description = "CIDR for Region 1 public subnet"
  type        = string
  default     = "10.20.0.0/25"
}

variable "private_subnet_region_1_cidr" {
  description = "CIDR for Region 1 private subnet"
  type        = string
  default     = "10.20.0.128/25"
}

variable "vpc_region_2_cidr_block" {
  description = "CIDR for Region 2 AWS VPC"
  type        = string
  default     = "10.21.0.0/24"
}

variable "public_subnet_region_2_cidr" {
  description = "CIDR for Region 2 public subnet"
  type        = string
  default     = "10.21.0.0/25"
}

variable "private_subnet_region_2_cidr" {
  description = "CIDR for Region 2 private subnet"
  type        = string
  default     = "10.21.0.128/25"
}

variable "vpc_region_3_cidr_block" {
  description = "CIDR for Region 3 AWS VPC"
  type        = string
  default     = "10.22.0.0/24"
}

variable "public_subnet_region_3_cidr" {
  description = "CIDR for Region 3 public subnet"
  type        = string
  default     = "10.22.0.0/25"
}

variable "private_subnet_region_3_cidr" {
  description = "CIDR for Region 3 private subnet"
  type        = string
  default     = "10.22.0.128/25"
}

variable "vpc_region_4_cidr_block" {
  description = "CIDR for Region 4 AWS VPC"
  type        = string
  default     = "10.23.0.0/24"
}

variable "public_subnet_region_4_cidr" {
  description = "CIDR for Region 4 public subnet"
  type        = string
  default     = "10.23.0.0/25"
}

variable "private_subnet_region_4_cidr" {
  description = "CIDR for Region 4 private subnet"
  type        = string
  default     = "10.23.0.128/25"
}

variable "vpc_region_5_cidr_block" {
  description = "CIDR for Region 5 AWS VPC"
  type        = string
  default     = "10.24.0.0/24"
}

variable "public_subnet_region_5_cidr" {
  description = "CIDR for Region 5 public subnet"
  type        = string
  default     = "10.24.0.0/25"
}

variable "private_subnet_region_5_cidr" {
  description = "CIDR for Region 5 private subnet"
  type        = string
  default     = "10.24.0.128/25"
}

variable "vpc_region_6_cidr_block" {
  description = "CIDR for Region 6 AWS VPC"
  type        = string
  default     = "10.25.0.0/24"
}

variable "public_subnet_region_6_cidr" {
  description = "CIDR for Region 6 public subnet"
  type        = string
  default     = "10.25.0.0/25"
}

variable "private_subnet_region_6_cidr" {
  description = "CIDR for Region 6 private subnet"
  type        = string
  default     = "10.25.0.128/25"
}

variable "enable_hcp_tgw_acceptance" {
  description = "Enable accepting HCP transit gateway attachments in AWS"
  type        = bool
  default     = false
}

variable "enable_hcp_routes" {
  description = "Enable creating routes from AWS route tables to all HVN CIDRs via transit gateways"
  type        = bool
  default     = false
}

variable "hvn_cluster_1_cidr" {
  description = "CIDR for cluster 1 HVN"
  type        = string
  default     = "172.25.16.0/24"
}

variable "hvn_cluster_2_cidr" {
  description = "CIDR for cluster 2 HVN"
  type        = string
  default     = "172.26.16.0/24"
}

variable "hvn_cluster_3_cidr" {
  description = "CIDR for cluster 3 HVN"
  type        = string
  default     = "172.27.16.0/24"
}

variable "hvn_cluster_4_cidr" {
  description = "CIDR for cluster 4 HVN"
  type        = string
  default     = "172.28.16.0/24"
}

variable "hvn_cluster_5_cidr" {
  description = "CIDR for cluster 5 HVN"
  type        = string
  default     = "172.29.16.0/24"
}

variable "hvn_cluster_6_cidr" {
  description = "CIDR for cluster 6 HVN"
  type        = string
  default     = "172.30.16.0/24"
}

variable "hvn_region_1_primary_cidr" {
  description = "CIDR for legacy region 1 primary HVN route"
  type        = string
  default     = "172.25.16.0/24"
}

variable "hvn_region_2_primary_cidr" {
  description = "CIDR for legacy region 2 primary HVN route"
  type        = string
  default     = "172.26.16.0/24"
}

variable "hvn_region_3_primary_cidr" {
  description = "CIDR for legacy region 3 primary HVN route"
  type        = string
  default     = "172.27.16.0/24"
}

variable "hvn_region_2_dr_for_region_1_cidr" {
  description = "CIDR for legacy region 2 DR-for-region-1 HVN route"
  type        = string
  default     = "172.28.16.0/24"
}

variable "hvn_region_3_dr_for_region_2_cidr" {
  description = "CIDR for legacy region 3 DR-for-region-2 HVN route"
  type        = string
  default     = "172.29.16.0/24"
}

variable "hvn_region_1_dr_for_region_3_cidr" {
  description = "CIDR for legacy region 1 DR-for-region-3 HVN route"
  type        = string
  default     = "172.30.16.0/24"
}

variable "hcp_provider_account_id_region_1" {
  description = "Optional HCP provider AWS account ID used for RAM principal association in Region 1"
  type        = string
  default     = null
}

variable "hcp_provider_account_id_region_2" {
  description = "Optional HCP provider AWS account ID used for RAM principal association in Region 2"
  type        = string
  default     = null
}

variable "hcp_provider_account_id_region_3" {
  description = "Optional HCP provider AWS account ID used for RAM principal association in Region 3"
  type        = string
  default     = null
}

variable "hcp_provider_account_id_region_4" {
  description = "Optional HCP provider AWS account ID used for RAM principal association in Region 4"
  type        = string
  default     = null
}

variable "hcp_provider_account_id_region_5" {
  description = "Optional HCP provider AWS account ID used for RAM principal association in Region 5"
  type        = string
  default     = null
}

variable "hcp_provider_account_id_region_6" {
  description = "Optional HCP provider AWS account ID used for RAM principal association in Region 6"
  type        = string
  default     = null
}

variable "hcp_provider_tgw_attachment_cluster_1" {
  description = "Provider-side TGW attachment ID from HCP for cluster 1"
  type        = string
  default     = null
}

variable "hcp_provider_tgw_attachment_cluster_2" {
  description = "Provider-side TGW attachment ID from HCP for cluster 2"
  type        = string
  default     = null
}

variable "hcp_provider_tgw_attachment_cluster_3" {
  description = "Provider-side TGW attachment ID from HCP for cluster 3"
  type        = string
  default     = null
}

variable "hcp_provider_tgw_attachment_cluster_4" {
  description = "Provider-side TGW attachment ID from HCP for cluster 4"
  type        = string
  default     = null
}

variable "hcp_provider_tgw_attachment_cluster_5" {
  description = "Provider-side TGW attachment ID from HCP for cluster 5"
  type        = string
  default     = null
}

variable "hcp_provider_tgw_attachment_cluster_6" {
  description = "Provider-side TGW attachment ID from HCP for cluster 6"
  type        = string
  default     = null
}

variable "tags" {
  description = "Base tags applied to AWS resources"
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Project   = "hcp-vault-demo"
  }
}

variable "enable_test_databases" {
  description = "Create low-cost RDS PostgreSQL and MySQL test databases in Region 1 for Vault database secret engine testing"
  type        = bool
  default     = false
}

variable "test_database_subnet_type" {
  description = "Deprecated. RDS databases are placed in DB subnet groups derived from regional network subnets"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.test_database_subnet_type)
    error_message = "test_database_subnet_type must be one of: public, private."
  }
}

variable "test_database_instance_type" {
  description = "RDS instance class used for test databases"
  type        = string
  default     = "db.t4g.micro"
}

variable "test_database_allowed_cidrs" {
  description = "CIDR ranges allowed to access Region 1 test database ports (5432 and 3306). If empty, Region 1 VPC and non-prod HVN CIDRs are allowed."
  type        = list(string)
  default     = []
}

variable "test_postgres_username" {
  description = "Master username for test PostgreSQL RDS instances"
  type        = string
  default     = "vaultadmin"
}

variable "test_postgres_password" {
  description = "Master password for test PostgreSQL RDS instances"
  type        = string
  default     = "replace-me"
  sensitive   = true
}

variable "test_postgres_database" {
  description = "Initial database name for test PostgreSQL RDS instances"
  type        = string
  default     = "appdb"
}

variable "test_mysql_username" {
  description = "Master username for test MySQL RDS instances"
  type        = string
  default     = "vaultadmin"
}

variable "test_mysql_password" {
  description = "Master password for test MySQL RDS instances"
  type        = string
  default     = "replace-me"
  sensitive   = true
}

variable "test_mysql_database" {
  description = "Initial database name for test MySQL RDS instances"
  type        = string
  default     = "appdb"
}

variable "test_mysql_root_password" {
  description = "Deprecated. Not used with RDS-based test MySQL databases"
  type        = string
  default     = "replace-me-root"
  sensitive   = true
}

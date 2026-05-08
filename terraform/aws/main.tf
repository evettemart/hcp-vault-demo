module "region_1_network" {
  source = "./modules/regional_network"

  name_prefix         = var.name_prefix
  region_short        = "r1"
  region_group        = "region-1"
  vpc_cidr_block      = var.vpc_region_1_cidr_block
  public_subnet_cidr  = var.public_subnet_region_1_cidr
  private_subnet_cidr = var.private_subnet_region_1_cidr
  tags                = var.tags
}

module "region_2_network" {
  source = "./modules/regional_network"

  providers = {
    aws = aws.region2
  }

  name_prefix         = var.name_prefix
  region_short        = "r2"
  region_group        = "region-2"
  vpc_cidr_block      = var.vpc_region_2_cidr_block
  public_subnet_cidr  = var.public_subnet_region_2_cidr
  private_subnet_cidr = var.private_subnet_region_2_cidr
  tags                = var.tags
}

module "region_3_network" {
  source = "./modules/regional_network"

  providers = {
    aws = aws.region3
  }

  name_prefix         = var.name_prefix
  region_short        = "r3"
  region_group        = "region-3"
  vpc_cidr_block      = var.vpc_region_3_cidr_block
  public_subnet_cidr  = var.public_subnet_region_3_cidr
  private_subnet_cidr = var.private_subnet_region_3_cidr
  tags                = var.tags
}

data "terraform_remote_state" "hcp_vault_aws" {
  count   = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? 1 : 0
  backend = "s3"

  config = {
    bucket = "hcp-vault-demo-terraform-state"
    key    = "terraform/hcp-vault-aws/vault-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  r1_primary_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_region_1, null) : null
  r2_primary_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_region_2, null) : null
  r3_primary_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_region_3, null) : null

  r2_dr_for_r1_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_dr_region_2_for_region_1, null) : null
  r3_dr_for_r2_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_dr_region_3_for_region_2, null) : null
  r1_dr_for_r3_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_dr_region_1_for_region_3, null) : null
}

resource "aws_vpc_peering_connection_accepter" "region_1_primary" {
  count = var.enable_hcp_peering_acceptance && local.r1_primary_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r1_primary_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_2_primary" {
  provider = aws.region2

  count = var.enable_hcp_peering_acceptance && local.r2_primary_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r2_primary_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_3_primary" {
  provider = aws.region3

  count = var.enable_hcp_peering_acceptance && local.r3_primary_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r3_primary_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_2_dr_for_region_1" {
  provider = aws.region2

  count = var.enable_hcp_peering_acceptance && local.r2_dr_for_r1_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r2_dr_for_r1_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_3_dr_for_region_2" {
  provider = aws.region3

  count = var.enable_hcp_peering_acceptance && local.r3_dr_for_r2_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r3_dr_for_r2_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_1_dr_for_region_3" {
  count = var.enable_hcp_peering_acceptance && local.r1_dr_for_r3_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r1_dr_for_r3_peering_id
  auto_accept               = true
}

module "routes_region_1_primary" {
  source = "./modules/hvn_routes"

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_1_network.public_route_table_id
  private_route_table_id = module.region_1_network.private_route_table_id
  destination_cidr_block = var.hvn_region_1_primary_cidr
  peering_connection_id  = local.r1_primary_peering_id
}

module "routes_region_2_primary" {
  source = "./modules/hvn_routes"

  providers = {
    aws = aws.region2
  }

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_2_network.public_route_table_id
  private_route_table_id = module.region_2_network.private_route_table_id
  destination_cidr_block = var.hvn_region_2_primary_cidr
  peering_connection_id  = local.r2_primary_peering_id
}

module "routes_region_3_primary" {
  source = "./modules/hvn_routes"

  providers = {
    aws = aws.region3
  }

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_3_network.public_route_table_id
  private_route_table_id = module.region_3_network.private_route_table_id
  destination_cidr_block = var.hvn_region_3_primary_cidr
  peering_connection_id  = local.r3_primary_peering_id
}

module "routes_region_2_dr_for_region_1" {
  source = "./modules/hvn_routes"

  providers = {
    aws = aws.region2
  }

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_2_network.public_route_table_id
  private_route_table_id = module.region_2_network.private_route_table_id
  destination_cidr_block = var.hvn_region_2_dr_for_region_1_cidr
  peering_connection_id  = local.r2_dr_for_r1_peering_id
}

module "routes_region_3_dr_for_region_2" {
  source = "./modules/hvn_routes"

  providers = {
    aws = aws.region3
  }

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_3_network.public_route_table_id
  private_route_table_id = module.region_3_network.private_route_table_id
  destination_cidr_block = var.hvn_region_3_dr_for_region_2_cidr
  peering_connection_id  = local.r3_dr_for_r2_peering_id
}

module "routes_region_1_dr_for_region_3" {
  source = "./modules/hvn_routes"

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_1_network.public_route_table_id
  private_route_table_id = module.region_1_network.private_route_table_id
  destination_cidr_block = var.hvn_region_1_dr_for_region_3_cidr
  peering_connection_id  = local.r1_dr_for_r3_peering_id
}

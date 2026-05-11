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

module "tgw_region_1" {
  source = "./modules/tgw_regional_connectivity"

  name_prefix             = var.name_prefix
  region_short            = "r1"
  region_group            = "region-1"
  region_label            = "Region 1"
  vpc_id                  = module.region_1_network.vpc_id
  subnet_ids              = [module.region_1_network.private_subnet_id]
  hcp_provider_account_id = var.hcp_provider_account_id_region_1
  tags                    = var.tags
}

module "tgw_region_2" {
  source = "./modules/tgw_regional_connectivity"

  providers = {
    aws = aws.region2
  }

  name_prefix             = var.name_prefix
  region_short            = "r2"
  region_group            = "region-2"
  region_label            = "Region 2"
  vpc_id                  = module.region_2_network.vpc_id
  subnet_ids              = [module.region_2_network.private_subnet_id]
  hcp_provider_account_id = var.hcp_provider_account_id_region_2
  tags                    = var.tags
}

module "tgw_region_3" {
  source = "./modules/tgw_regional_connectivity"

  providers = {
    aws = aws.region3
  }

  name_prefix             = var.name_prefix
  region_short            = "r3"
  region_group            = "region-3"
  region_label            = "Region 3"
  vpc_id                  = module.region_3_network.vpc_id
  subnet_ids              = [module.region_3_network.private_subnet_id]
  hcp_provider_account_id = var.hcp_provider_account_id_region_3
  tags                    = var.tags
}

data "terraform_remote_state" "hcp_vault_aws" {
  count   = var.enable_hcp_tgw_acceptance ? 1 : 0
  backend = "s3"

  config = {
    bucket = "hcp-vault-demo-terraform-state"
    key    = "terraform/hcp-vault-aws/vault-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  r1_primary_tgw_attachment_id = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_region_1, null) : null
  r2_primary_tgw_attachment_id = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_region_2, null) : null
  r3_primary_tgw_attachment_id = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_region_3, null) : null

  r2_dr_for_r1_tgw_attachment_id = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_dr_region_2_for_region_1, null) : null
  r3_dr_for_r2_tgw_attachment_id = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_dr_region_3_for_region_2, null) : null
  r1_dr_for_r3_tgw_attachment_id = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_dr_region_1_for_region_3, null) : null

  region_1_attachment_ids = {
    primary         = local.r1_primary_tgw_attachment_id
    dr_for_region_3 = local.r1_dr_for_r3_tgw_attachment_id
  }

  region_2_attachment_ids = {
    primary         = local.r2_primary_tgw_attachment_id
    dr_for_region_1 = local.r2_dr_for_r1_tgw_attachment_id
  }

  region_3_attachment_ids = {
    primary         = local.r3_primary_tgw_attachment_id
    dr_for_region_2 = local.r3_dr_for_r2_tgw_attachment_id
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "region_1" {
  for_each = var.enable_hcp_tgw_acceptance ? {
    for name, attachment_id in local.region_1_attachment_ids : name => attachment_id if attachment_id != null
  } : {}

  transit_gateway_attachment_id = each.value
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "region_2" {
  provider = aws.region2

  for_each = var.enable_hcp_tgw_acceptance ? {
    for name, attachment_id in local.region_2_attachment_ids : name => attachment_id if attachment_id != null
  } : {}

  transit_gateway_attachment_id = each.value
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "region_3" {
  provider = aws.region3

  for_each = var.enable_hcp_tgw_acceptance ? {
    for name, attachment_id in local.region_3_attachment_ids : name => attachment_id if attachment_id != null
  } : {}

  transit_gateway_attachment_id = each.value
}

module "routes_region_1_primary" {
  source = "./modules/hvn_routes"

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_1_network.public_route_table_id
  private_route_table_id = module.region_1_network.private_route_table_id
  destination_cidr_block = var.hvn_region_1_primary_cidr
  transit_gateway_id     = module.tgw_region_1.transit_gateway_id
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
  transit_gateway_id     = module.tgw_region_2.transit_gateway_id
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
  transit_gateway_id     = module.tgw_region_3.transit_gateway_id
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
  transit_gateway_id     = module.tgw_region_2.transit_gateway_id
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
  transit_gateway_id     = module.tgw_region_3.transit_gateway_id
}

module "routes_region_1_dr_for_region_3" {
  source = "./modules/hvn_routes"

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_1_network.public_route_table_id
  private_route_table_id = module.region_1_network.private_route_table_id
  destination_cidr_block = var.hvn_region_1_dr_for_region_3_cidr
  transit_gateway_id     = module.tgw_region_1.transit_gateway_id
}

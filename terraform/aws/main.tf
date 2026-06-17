module "region_1_network" {
  source = "./modules/regional_network"

  name_prefix         = var.name_prefix
  region_short        = "r1"
  region_group        = "region-1"
  vpc_cidr_block      = var.vpc_region_1_cidr_block
  public_subnet_cidr  = var.public_subnet_region_1_cidr
  private_subnet_cidr = var.private_subnet_region_1_cidr
  tags                = local.tags
}

locals {
  full_topology = var.topology_scenario == "prod"
  tags          = merge(var.tags, { Environment = var.environment })
  enable_region_3 = local.full_topology && var.enable_region_3
  enable_region_4 = local.full_topology && var.enable_region_4
  enable_region_5 = local.full_topology && var.enable_region_5
  enable_region_6 = local.full_topology && var.enable_region_6
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
  tags                = local.tags
}

module "region_3_network" {
  count  = local.enable_region_3 ? 1 : 0
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
  tags                = local.tags
}

module "region_4_network" {
  count  = local.enable_region_4 ? 1 : 0
  source = "./modules/regional_network"

  providers = {
    aws = aws.region4
  }

  name_prefix         = var.name_prefix
  region_short        = "r4"
  region_group        = "region-4"
  vpc_cidr_block      = var.vpc_region_4_cidr_block
  public_subnet_cidr  = var.public_subnet_region_4_cidr
  private_subnet_cidr = var.private_subnet_region_4_cidr
  tags                = local.tags
}

module "region_5_network" {
  count  = local.enable_region_5 ? 1 : 0
  source = "./modules/regional_network"

  providers = {
    aws = aws.region5
  }

  name_prefix         = var.name_prefix
  region_short        = "r5"
  region_group        = "region-5"
  vpc_cidr_block      = var.vpc_region_5_cidr_block
  public_subnet_cidr  = var.public_subnet_region_5_cidr
  private_subnet_cidr = var.private_subnet_region_5_cidr
  tags                = local.tags
}

module "region_6_network" {
  count  = local.enable_region_6 ? 1 : 0
  source = "./modules/regional_network"

  providers = {
    aws = aws.region6
  }

  name_prefix         = var.name_prefix
  region_short        = "r6"
  region_group        = "region-6"
  vpc_cidr_block      = var.vpc_region_6_cidr_block
  public_subnet_cidr  = var.public_subnet_region_6_cidr
  private_subnet_cidr = var.private_subnet_region_6_cidr
  tags                = local.tags
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
  tags                    = local.tags
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
  tags                    = local.tags
}

module "tgw_region_3" {
  count  = local.enable_region_3 ? 1 : 0
  source = "./modules/tgw_regional_connectivity"

  providers = {
    aws = aws.region3
  }

  name_prefix             = var.name_prefix
  region_short            = "r3"
  region_group            = "region-3"
  region_label            = "Region 3"
  vpc_id                  = module.region_3_network[0].vpc_id
  subnet_ids              = [module.region_3_network[0].private_subnet_id]
  hcp_provider_account_id = var.hcp_provider_account_id_region_3
  tags                    = local.tags
}

module "tgw_region_4" {
  count  = local.enable_region_4 ? 1 : 0
  source = "./modules/tgw_regional_connectivity"

  providers = {
    aws = aws.region4
  }

  name_prefix             = var.name_prefix
  region_short            = "r4"
  region_group            = "region-4"
  region_label            = "Region 4"
  vpc_id                  = module.region_4_network[0].vpc_id
  subnet_ids              = [module.region_4_network[0].private_subnet_id]
  hcp_provider_account_id = var.hcp_provider_account_id_region_4
  tags                    = local.tags
}

module "tgw_region_5" {
  count  = local.enable_region_5 ? 1 : 0
  source = "./modules/tgw_regional_connectivity"

  providers = {
    aws = aws.region5
  }

  name_prefix             = var.name_prefix
  region_short            = "r5"
  region_group            = "region-5"
  region_label            = "Region 5"
  vpc_id                  = module.region_5_network[0].vpc_id
  subnet_ids              = [module.region_5_network[0].private_subnet_id]
  hcp_provider_account_id = var.hcp_provider_account_id_region_5
  tags                    = local.tags
}

module "tgw_region_6" {
  count  = local.enable_region_6 ? 1 : 0
  source = "./modules/tgw_regional_connectivity"

  providers = {
    aws = aws.region6
  }

  name_prefix             = var.name_prefix
  region_short            = "r6"
  region_group            = "region-6"
  region_label            = "Region 6"
  vpc_id                  = module.region_6_network[0].vpc_id
  subnet_ids              = [module.region_6_network[0].private_subnet_id]
  hcp_provider_account_id = var.hcp_provider_account_id_region_6
  tags                    = local.tags
}

data "terraform_remote_state" "hcp_vault_aws" {
  count     = var.enable_hcp_tgw_acceptance ? 1 : 0
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket               = "hcp-vault-demo-terraform-state"
    key                  = "terraform/hcp-vault-aws/vault-cluster/terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "terraform/workspaces"
  }
}

locals {
  region_1_attachment_ids = {
    primary = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_cluster_1, null) : null
  }

  region_2_attachment_ids = {
    primary = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_cluster_2, null) : null
  }

  region_3_attachment_ids = {
    primary = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_cluster_3, null) : null
  }

  region_4_attachment_ids = {
    primary = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_cluster_4, null) : null
  }

  region_5_attachment_ids = {
    primary = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_cluster_5, null) : null
  }

  region_6_attachment_ids = {
    primary = var.enable_hcp_tgw_acceptance ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_tgw_attachment_cluster_6, null) : null
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

  for_each = var.enable_hcp_tgw_acceptance && local.enable_region_3 ? {
    for name, attachment_id in local.region_3_attachment_ids : name => attachment_id if attachment_id != null
  } : {}

  transit_gateway_attachment_id = each.value
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "region_4" {
  provider = aws.region4

  for_each = var.enable_hcp_tgw_acceptance && local.enable_region_4 ? {
    for name, attachment_id in local.region_4_attachment_ids : name => attachment_id if attachment_id != null
  } : {}

  transit_gateway_attachment_id = each.value
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "region_5" {
  provider = aws.region5

  for_each = var.enable_hcp_tgw_acceptance && local.enable_region_5 ? {
    for name, attachment_id in local.region_5_attachment_ids : name => attachment_id if attachment_id != null
  } : {}

  transit_gateway_attachment_id = each.value
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "region_6" {
  provider = aws.region6

  for_each = var.enable_hcp_tgw_acceptance && local.enable_region_6 ? {
    for name, attachment_id in local.region_6_attachment_ids : name => attachment_id if attachment_id != null
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
  count  = local.full_topology ? 1 : 0
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
  count  = local.enable_region_3 ? 1 : 0
  source = "./modules/hvn_routes"

  providers = {
    aws = aws.region3
  }

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_3_network[0].public_route_table_id
  private_route_table_id = module.region_3_network[0].private_route_table_id
  destination_cidr_block = var.hvn_region_3_primary_cidr
  transit_gateway_id     = module.tgw_region_3[0].transit_gateway_id
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
  count  = local.enable_region_3 ? 1 : 0
  source = "./modules/hvn_routes"

  providers = {
    aws = aws.region3
  }

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_3_network[0].public_route_table_id
  private_route_table_id = module.region_3_network[0].private_route_table_id
  destination_cidr_block = var.hvn_region_3_dr_for_region_2_cidr
  transit_gateway_id     = module.tgw_region_3[0].transit_gateway_id
}

module "routes_region_1_dr_for_region_3" {
  count  = local.full_topology ? 1 : 0
  source = "./modules/hvn_routes"

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_1_network.public_route_table_id
  private_route_table_id = module.region_1_network.private_route_table_id
  destination_cidr_block = var.hvn_region_1_dr_for_region_3_cidr
  transit_gateway_id     = module.tgw_region_1.transit_gateway_id
}

module "routes_region_4_primary" {
  count  = local.enable_region_4 ? 1 : 0
  source = "./modules/hvn_routes"

  providers = {
    aws = aws.region4
  }

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_4_network[0].public_route_table_id
  private_route_table_id = module.region_4_network[0].private_route_table_id
  destination_cidr_block = var.hvn_cluster_4_cidr
  transit_gateway_id     = module.tgw_region_4[0].transit_gateway_id
}

module "routes_region_5_primary" {
  count  = local.enable_region_5 ? 1 : 0
  source = "./modules/hvn_routes"

  providers = {
    aws = aws.region5
  }

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_5_network[0].public_route_table_id
  private_route_table_id = module.region_5_network[0].private_route_table_id
  destination_cidr_block = var.hvn_cluster_5_cidr
  transit_gateway_id     = module.tgw_region_5[0].transit_gateway_id
}

module "routes_region_6_primary" {
  count  = local.enable_region_6 ? 1 : 0
  source = "./modules/hvn_routes"

  providers = {
    aws = aws.region6
  }

  enabled                = var.enable_hcp_routes
  public_route_table_id  = module.region_6_network[0].public_route_table_id
  private_route_table_id = module.region_6_network[0].private_route_table_id
  destination_cidr_block = var.hvn_cluster_6_cidr
  transit_gateway_id     = module.tgw_region_6[0].transit_gateway_id
}

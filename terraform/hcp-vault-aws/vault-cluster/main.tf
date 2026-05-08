locals {
  hvns = {
    region_1_primary = {
      hvn_id = var.region_1_primary_hvn_id
      region = var.region_1_primary_hvn_region
      cidr   = var.region_1_primary_hvn_cidr
    }
    region_2_primary = {
      hvn_id = var.region_2_primary_hvn_id
      region = var.region_2_primary_hvn_region
      cidr   = var.region_2_primary_hvn_cidr
    }
    region_3_primary = {
      hvn_id = var.region_3_primary_hvn_id
      region = var.region_3_primary_hvn_region
      cidr   = var.region_3_primary_hvn_cidr
    }
    region_2_dr_for_region_1 = {
      hvn_id = var.region_2_dr_for_region_1_hvn_id
      region = var.region_2_dr_for_region_1_hvn_region
      cidr   = var.region_2_dr_for_region_1_hvn_cidr
    }
    region_3_dr_for_region_2 = {
      hvn_id = var.region_3_dr_for_region_2_hvn_id
      region = var.region_3_dr_for_region_2_hvn_region
      cidr   = var.region_3_dr_for_region_2_hvn_cidr
    }
    region_1_dr_for_region_3 = {
      hvn_id = var.region_1_dr_for_region_3_hvn_id
      region = var.region_1_dr_for_region_3_hvn_region
      cidr   = var.region_1_dr_for_region_3_hvn_cidr
    }
  }
}

module "hvn" {
  source   = "../modules/hvn"
  for_each = local.hvns

  hvn_id         = each.value.hvn_id
  cloud_provider = "aws"
  region         = each.value.region
  cidr_block     = each.value.cidr
  project_id     = var.project_id
}

module "vault_region_1" {
  source = "../modules/vault_cluster"

  cluster_id        = var.region_1_primary_cluster_id
  hvn_id            = module.hvn["region_1_primary"].hvn_id
  tier              = var.region_1_primary_cluster_tier
  project_id        = var.project_id
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version
  ip_allowlist      = var.vault_ip_allowlist
}

module "vault_region_2" {
  source = "../modules/vault_cluster"

  cluster_id        = var.region_2_primary_cluster_id
  hvn_id            = module.hvn["region_2_primary"].hvn_id
  tier              = var.region_2_primary_cluster_tier
  project_id        = var.project_id
  primary_link      = module.vault_region_1.self_link
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version
  ip_allowlist      = var.vault_ip_allowlist
}

module "vault_region_3" {
  source = "../modules/vault_cluster"

  cluster_id        = var.region_3_primary_cluster_id
  hvn_id            = module.hvn["region_3_primary"].hvn_id
  tier              = var.region_3_primary_cluster_tier
  project_id        = var.project_id
  primary_link      = module.vault_region_1.self_link
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version
  ip_allowlist      = var.vault_ip_allowlist
}

data "terraform_remote_state" "aws" {
  backend = "s3"
  config = {
    bucket = var.aws_state_bucket
    key    = var.aws_state_key
    region = var.aws_state_region
  }
}

locals {
  connectivity = {
    region_1_primary = {
      hvn_key          = "region_1_primary"
      peering_id       = var.region_1_primary_to_aws_peering_id
      route_id         = var.region_1_primary_to_aws_route_id
      peer_vpc_id      = data.terraform_remote_state.aws.outputs.vpc_region_1_id
      peer_vpc_region  = data.terraform_remote_state.aws.outputs.aws_region_1
      destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_1_cidr_block
    }
    region_2_primary = {
      hvn_key          = "region_2_primary"
      peering_id       = var.region_2_primary_to_aws_peering_id
      route_id         = var.region_2_primary_to_aws_route_id
      peer_vpc_id      = data.terraform_remote_state.aws.outputs.vpc_region_2_id
      peer_vpc_region  = data.terraform_remote_state.aws.outputs.aws_region_2
      destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_2_cidr_block
    }
    region_3_primary = {
      hvn_key          = "region_3_primary"
      peering_id       = var.region_3_primary_to_aws_peering_id
      route_id         = var.region_3_primary_to_aws_route_id
      peer_vpc_id      = data.terraform_remote_state.aws.outputs.vpc_region_3_id
      peer_vpc_region  = data.terraform_remote_state.aws.outputs.aws_region_3
      destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_3_cidr_block
    }
    region_2_dr_for_region_1 = {
      hvn_key          = "region_2_dr_for_region_1"
      peering_id       = var.region_2_dr_for_region_1_to_aws_peering_id
      route_id         = var.region_2_dr_for_region_1_to_aws_route_id
      peer_vpc_id      = data.terraform_remote_state.aws.outputs.vpc_region_2_id
      peer_vpc_region  = data.terraform_remote_state.aws.outputs.aws_region_2
      destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_2_cidr_block
    }
    region_3_dr_for_region_2 = {
      hvn_key          = "region_3_dr_for_region_2"
      peering_id       = var.region_3_dr_for_region_2_to_aws_peering_id
      route_id         = var.region_3_dr_for_region_2_to_aws_route_id
      peer_vpc_id      = data.terraform_remote_state.aws.outputs.vpc_region_3_id
      peer_vpc_region  = data.terraform_remote_state.aws.outputs.aws_region_3
      destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_3_cidr_block
    }
    region_1_dr_for_region_3 = {
      hvn_key          = "region_1_dr_for_region_3"
      peering_id       = var.region_1_dr_for_region_3_to_aws_peering_id
      route_id         = var.region_1_dr_for_region_3_to_aws_route_id
      peer_vpc_id      = data.terraform_remote_state.aws.outputs.vpc_region_1_id
      peer_vpc_region  = data.terraform_remote_state.aws.outputs.aws_region_1
      destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_1_cidr_block
    }
  }
}

module "hvn_aws_connectivity" {
  source   = "../modules/hvn_aws_connectivity"
  for_each = local.connectivity

  hvn_id           = module.hvn[each.value.hvn_key].hvn_id
  hvn_link         = module.hvn[each.value.hvn_key].self_link
  peering_id       = each.value.peering_id
  peer_vpc_id      = each.value.peer_vpc_id
  peer_account_id  = data.terraform_remote_state.aws.outputs.aws_account_id
  peer_vpc_region  = each.value.peer_vpc_region
  hvn_route_id     = each.value.route_id
  destination_cidr = each.value.destination_cidr
}

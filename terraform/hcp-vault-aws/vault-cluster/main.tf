locals {
  hvn_catalog = {
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

  vault_secondary_catalog = {
    region_2_primary = {
      cluster_id = var.region_2_primary_cluster_id
      hvn_key    = "region_2_primary"
      tier       = var.region_2_primary_cluster_tier
    }
    region_3_primary = {
      cluster_id = var.region_3_primary_cluster_id
      hvn_key    = "region_3_primary"
      tier       = var.region_3_primary_cluster_tier
    }
  }

  hvn_keys_by_scenario = {
    full          = toset(keys(local.hvn_catalog))
    dr_pair_r1_r2 = toset(["region_1_primary", "region_2_dr_for_region_1"])
  }

  vault_secondary_keys_by_scenario = {
    full          = toset(["region_2_primary", "region_3_primary"])
    dr_pair_r1_r2 = toset([])
  }

  hvns = {
    for key, value in local.hvn_catalog : key => value
    if contains(local.hvn_keys_by_scenario[var.topology_scenario], key)
  }

  vault_secondary_clusters = {
    for key, value in local.vault_secondary_catalog : key => value
    if contains(local.vault_secondary_keys_by_scenario[var.topology_scenario], key)
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

module "vault_primary" {
  source = "../modules/vault_cluster"

  cluster_id        = var.region_1_primary_cluster_id
  hvn_id            = module.hvn["region_1_primary"].hvn_id
  tier              = var.region_1_primary_cluster_tier
  project_id        = var.project_id
  primary_link      = null
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version
  ip_allowlist      = var.vault_ip_allowlist
}

module "vault_secondary" {
  source   = "../modules/vault_cluster"
  for_each = local.vault_secondary_clusters

  cluster_id        = each.value.cluster_id
  hvn_id            = module.hvn[each.value.hvn_key].hvn_id
  tier              = each.value.tier
  project_id        = var.project_id
  primary_link      = module.vault_primary.self_link
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version
  ip_allowlist      = var.vault_ip_allowlist
}

locals {
  connectivity = merge(
    {
      region_1_primary = {
        hvn_key            = "region_1_primary"
        tgw_attachment_id  = var.region_1_primary_to_aws_tgw_attachment_id
        transit_gateway_id = var.aws_tgw_region_1_id
        resource_share_arn = var.aws_tgw_region_1_share_arn
        route_id           = var.region_1_primary_to_aws_route_id
        destination_cidr   = var.aws_vpc_region_1_cidr_block
      }
      region_2_dr_for_region_1 = {
        hvn_key            = "region_2_dr_for_region_1"
        tgw_attachment_id  = var.region_2_dr_for_region_1_to_aws_tgw_attachment_id
        transit_gateway_id = var.aws_tgw_region_2_id
        resource_share_arn = var.aws_tgw_region_2_share_arn
        route_id           = var.region_2_dr_for_region_1_to_aws_route_id
        destination_cidr   = var.aws_vpc_region_2_cidr_block
      }
    },
    var.topology_scenario == "full" ? {
      region_2_primary = {
        hvn_key            = "region_2_primary"
        tgw_attachment_id  = var.region_2_primary_to_aws_tgw_attachment_id
        transit_gateway_id = var.aws_tgw_region_2_id
        resource_share_arn = var.aws_tgw_region_2_share_arn
        route_id           = var.region_2_primary_to_aws_route_id
        destination_cidr   = var.aws_vpc_region_2_cidr_block
      }
      region_3_primary = {
        hvn_key            = "region_3_primary"
        tgw_attachment_id  = var.region_3_primary_to_aws_tgw_attachment_id
        transit_gateway_id = var.aws_tgw_region_3_id
        resource_share_arn = var.aws_tgw_region_3_share_arn
        route_id           = var.region_3_primary_to_aws_route_id
        destination_cidr   = var.aws_vpc_region_3_cidr_block
      }
      region_3_dr_for_region_2 = {
        hvn_key            = "region_3_dr_for_region_2"
        tgw_attachment_id  = var.region_3_dr_for_region_2_to_aws_tgw_attachment_id
        transit_gateway_id = var.aws_tgw_region_3_id
        resource_share_arn = var.aws_tgw_region_3_share_arn
        route_id           = var.region_3_dr_for_region_2_to_aws_route_id
        destination_cidr   = var.aws_vpc_region_3_cidr_block
      }
      region_1_dr_for_region_3 = {
        hvn_key            = "region_1_dr_for_region_3"
        tgw_attachment_id  = var.region_1_dr_for_region_3_to_aws_tgw_attachment_id
        transit_gateway_id = var.aws_tgw_region_1_id
        resource_share_arn = var.aws_tgw_region_1_share_arn
        route_id           = var.region_1_dr_for_region_3_to_aws_route_id
        destination_cidr   = var.aws_vpc_region_1_cidr_block
      }
    } : {}
  )
}

module "hvn_aws_connectivity" {
  source   = "../modules/hvn_aws_connectivity"
  for_each = var.enable_hvn_peering ? local.connectivity : {}

  hvn_id                        = module.hvn[each.value.hvn_key].hvn_id
  hvn_link                      = module.hvn[each.value.hvn_key].self_link
  transit_gateway_attachment_id = each.value.tgw_attachment_id
  transit_gateway_id            = each.value.transit_gateway_id
  resource_share_arn            = each.value.resource_share_arn
  hvn_route_id                  = each.value.route_id
  destination_cidr              = each.value.destination_cidr
}

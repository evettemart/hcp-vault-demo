locals {
  active_cluster_keys_by_scenario = {
    prod     = toset(["cluster_1", "cluster_2", "cluster_3", "cluster_4", "cluster_5", "cluster_6"])
    non-prod = toset(["cluster_1", "cluster_2"])
  }

  secondary_keys_by_scenario = {
    prod     = toset(["cluster_3", "cluster_5"])
    non-prod = toset([])
  }

  cluster_catalog = var.cluster_configs

  active_clusters = {
    for key, value in local.cluster_catalog : key => value
    if contains(local.active_cluster_keys_by_scenario[var.topology_scenario], key)
  }

  secondary_to_cluster_1 = {
    for key, value in local.active_clusters : key => value
    if contains(local.secondary_keys_by_scenario[var.topology_scenario], key)
  }
}

module "hvn" {
  source   = "../modules/hvn"
  for_each = local.active_clusters

  hvn_id         = each.value.hvn_id
  cloud_provider = "aws"
  region         = each.value.hvn_region
  cidr_block     = each.value.hvn_cidr
  project_id     = var.project_id
}

module "vault_primary" {
  source = "../modules/vault_cluster"

  cluster_id        = local.active_clusters["cluster_1"].cluster_id
  hvn_id            = module.hvn["cluster_1"].hvn_id
  tier              = local.active_clusters["cluster_1"].tier
  project_id        = var.project_id
  primary_link      = null
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version
  ip_allowlist      = var.vault_ip_allowlist
}

module "vault_secondary_to_cluster_1" {
  source   = "../modules/vault_cluster"
  for_each = local.secondary_to_cluster_1

  cluster_id        = each.value.cluster_id
  hvn_id            = module.hvn[each.key].hvn_id
  tier              = each.value.tier
  project_id        = var.project_id
  primary_link      = module.vault_primary.self_link
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version
  ip_allowlist      = var.vault_ip_allowlist
}

locals {
  active_connectivity = {
    for key, cfg in var.cluster_configs : key => {
      hvn_key            = key
      tgw_attachment_id  = try(cfg.tgw_attachment_id, null)
      transit_gateway_id = try(var.aws_region_connectivity[key].transit_gateway_id, null)
      resource_share_arn = try(var.aws_region_connectivity[key].resource_share_arn, null)
      route_id           = try(cfg.route_id, null)
      destination_cidr   = try(var.aws_region_connectivity[key].destination_cidr, null)
    }
    if contains(local.active_cluster_keys_by_scenario[var.topology_scenario], key)
  }
}

module "hvn_aws_connectivity" {
  source   = "../modules/hvn_aws_connectivity"
  for_each = var.enable_hvn_peering ? local.active_connectivity : {}

  hvn_id                        = module.hvn[each.value.hvn_key].hvn_id
  hvn_link                      = module.hvn[each.value.hvn_key].self_link
  transit_gateway_attachment_id = each.value.tgw_attachment_id
  transit_gateway_id            = each.value.transit_gateway_id
  resource_share_arn            = each.value.resource_share_arn
  hvn_route_id                  = each.value.route_id
  destination_cidr              = each.value.destination_cidr
}

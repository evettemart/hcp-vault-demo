variable "project_id" {
  description = "HCP project ID"
  type        = string
}

variable "topology_scenario" {
  description = "Deployment topology scenario. Use prod for 6-cluster production and non-prod for 2-cluster non-production."
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["prod", "non-prod"], var.topology_scenario)
    error_message = "topology_scenario must be one of: prod, non-prod."
  }
}

variable "enable_hvn_peering" {
  description = "Enable HVN peering connectivity to AWS Transit Gateways (attachments and HVN routes)"
  type        = bool
  default     = true
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

variable "cluster_configs" {
  description = "Cluster map keyed by cluster_1..cluster_6 containing HVN and cluster configuration."
  type = map(object({
    hvn_id             = string
    hvn_region         = string
    hvn_cidr           = string
    cluster_id         = optional(string)
    tier               = optional(string, "plus_small")
    tgw_attachment_id  = optional(string)
    route_id           = optional(string)
  }))
}

variable "aws_region_connectivity" {
  description = "AWS connectivity map keyed by cluster_1..cluster_6 for one-to-one cluster/HVN to AWS region mapping."
  type = map(object({
    transit_gateway_id = string
    resource_share_arn = string
    destination_cidr   = string
  }))
  default = {}
}

locals {
  validation_active_cluster_keys_by_scenario = {
    prod     = toset(["cluster_1", "cluster_2", "cluster_3", "cluster_4", "cluster_5", "cluster_6"])
    non-prod = toset(["cluster_1", "cluster_2"])
  }

  validation_terraform_managed_cluster_keys_by_scenario = {
    prod     = toset(["cluster_1", "cluster_3", "cluster_5"])
    non-prod = toset(["cluster_1"])
  }

  required_cluster_keys_present = alltrue([
    for key in local.validation_active_cluster_keys_by_scenario[var.topology_scenario] :
    contains(keys(var.cluster_configs), key)
  ])

  required_connectivity_keys_present = alltrue([
    for key in local.validation_active_cluster_keys_by_scenario[var.topology_scenario] :
    contains(keys(var.aws_region_connectivity), key)
  ])

  required_peering_cluster_fields_present = alltrue([
    for key in local.validation_active_cluster_keys_by_scenario[var.topology_scenario] :
    can(var.cluster_configs[key].tgw_attachment_id) && try(var.cluster_configs[key].tgw_attachment_id, null) != null && trimspace(try(var.cluster_configs[key].tgw_attachment_id, "")) != "" &&
    can(var.cluster_configs[key].route_id) && try(var.cluster_configs[key].route_id, null) != null && trimspace(try(var.cluster_configs[key].route_id, "")) != ""
  ])

  required_managed_cluster_ids_present = alltrue([
    for key in local.validation_terraform_managed_cluster_keys_by_scenario[var.topology_scenario] :
    can(var.cluster_configs[key].cluster_id) && try(var.cluster_configs[key].cluster_id, null) != null && trimspace(try(var.cluster_configs[key].cluster_id, "")) != ""
  ])
}

check "cluster_config_keys" {
  assert {
    condition     = local.required_cluster_keys_present
    error_message = "cluster_configs must define all required keys for the selected topology_scenario."
  }
}

check "hvn_peering_keys" {
  assert {
    condition     = !var.enable_hvn_peering || (local.required_connectivity_keys_present && local.required_peering_cluster_fields_present)
    error_message = "When enable_hvn_peering is true, aws_region_connectivity must define all active cluster keys and cluster_configs must include non-empty tgw_attachment_id and route_id for each active key."
  }
}

check "managed_cluster_ids" {
  assert {
    condition     = local.required_managed_cluster_ids_present
    error_message = "cluster_configs must provide non-empty cluster_id for Terraform-managed clusters in the selected topology_scenario."
  }
}

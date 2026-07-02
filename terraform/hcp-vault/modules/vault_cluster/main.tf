resource "hcp_vault_cluster" "this" {
  cluster_id        = var.cluster_id
  hvn_id            = var.hvn_id
  tier              = var.tier
  project_id        = var.project_id
  public_endpoint   = var.public_endpoint
  proxy_endpoint    = var.proxy_endpoint
  min_vault_version = var.min_vault_version
  primary_link      = var.primary_link

  dynamic "ip_allowlist" {
    for_each = var.public_endpoint ? { for item in var.ip_allowlist : item.address => item } : {}
    content {
      address     = ip_allowlist.value.address
      description = ip_allowlist.value.description
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

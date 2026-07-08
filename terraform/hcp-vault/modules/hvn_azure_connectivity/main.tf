resource "hcp_azure_peering_connection" "this" {
  hvn_link                 = var.hvn_link
  peering_id               = var.peering_id
  peer_vnet_name           = var.peer_vnet_name
  peer_subscription_id     = var.peer_subscription_id
  peer_tenant_id           = var.peer_tenant_id
  peer_resource_group_name = var.peer_resource_group_name
  peer_vnet_region         = var.peer_vnet_region
  allow_forwarded_traffic  = var.allow_forwarded_traffic
  use_remote_gateways      = var.use_remote_gateways

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [peer_vnet_region]
  }
}

data "hcp_azure_peering_connection" "active" {
  hvn_link              = var.hvn_link
  peering_id            = hcp_azure_peering_connection.this.peering_id
  wait_for_active_state = true

  depends_on = [hcp_azure_peering_connection.this]
}

resource "hcp_hvn_route" "this" {
  hvn_link         = var.hvn_link
  hvn_route_id     = var.hvn_route_id
  destination_cidr = var.destination_cidr
  target_link      = data.hcp_azure_peering_connection.active.self_link

  lifecycle {
    prevent_destroy = true
  }
}

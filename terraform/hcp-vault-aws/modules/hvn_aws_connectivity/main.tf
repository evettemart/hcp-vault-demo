resource "hcp_aws_network_peering" "this" {
  hvn_id          = var.hvn_id
  peering_id      = var.peering_id
  peer_vpc_id     = var.peer_vpc_id
  peer_account_id = var.peer_account_id
  peer_vpc_region = var.peer_vpc_region
}

resource "hcp_hvn_route" "this" {
  hvn_link         = var.hvn_link
  hvn_route_id     = var.hvn_route_id
  destination_cidr = var.destination_cidr
  target_link      = hcp_aws_network_peering.this.self_link
}

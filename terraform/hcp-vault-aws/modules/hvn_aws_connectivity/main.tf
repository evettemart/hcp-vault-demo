resource "hcp_aws_transit_gateway_attachment" "this" {
  hvn_id                        = var.hvn_id
  transit_gateway_attachment_id = var.transit_gateway_attachment_id
  transit_gateway_id            = var.transit_gateway_id
  resource_share_arn            = var.resource_share_arn

  lifecycle {
    prevent_destroy = true
  }
}

resource "hcp_hvn_route" "this" {
  hvn_link         = var.hvn_link
  hvn_route_id     = var.hvn_route_id
  destination_cidr = var.destination_cidr
  target_link      = hcp_aws_transit_gateway_attachment.this.self_link

  lifecycle {
    prevent_destroy = true
  }
}

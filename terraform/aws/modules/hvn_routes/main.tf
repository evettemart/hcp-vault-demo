resource "aws_route" "public_to_hvn" {
  count = var.enabled && var.transit_gateway_id != null ? 1 : 0

  route_table_id         = var.public_route_table_id
  destination_cidr_block = var.destination_cidr_block
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route" "private_to_hvn" {
  count = var.enabled && var.transit_gateway_id != null ? 1 : 0

  route_table_id         = var.private_route_table_id
  destination_cidr_block = var.destination_cidr_block
  transit_gateway_id     = var.transit_gateway_id
}

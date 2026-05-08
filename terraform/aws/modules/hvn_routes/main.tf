resource "aws_route" "public_to_hvn" {
  count = var.enabled && var.peering_connection_id != null ? 1 : 0

  route_table_id            = var.public_route_table_id
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = var.peering_connection_id
}

resource "aws_route" "private_to_hvn" {
  count = var.enabled && var.peering_connection_id != null ? 1 : 0

  route_table_id            = var.private_route_table_id
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = var.peering_connection_id
}

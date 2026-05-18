resource "aws_ec2_transit_gateway" "this" {
  description = "Transit Gateway for ${var.region_label}"

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${var.region_short}-tgw"
    RegionGroup = var.region_group
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.region_short}-vpc-attach"
  })
}

resource "aws_ram_resource_share" "this" {
  name                      = "${var.name_prefix}-${var.region_short}-tgw-share"
  allow_external_principals = true
}

resource "aws_ram_resource_association" "this" {
  resource_share_arn = aws_ram_resource_share.this.arn
  resource_arn       = aws_ec2_transit_gateway.this.arn
}

resource "aws_ram_principal_association" "hcp" {
  count = var.hcp_provider_account_id != null ? 1 : 0

  resource_share_arn = aws_ram_resource_share.this.arn
  principal          = var.hcp_provider_account_id
}
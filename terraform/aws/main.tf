resource "aws_vpc" "region_1" {
  cidr_block           = var.vpc_region_1_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r1-vpc"
    RegionGroup = "region-1"
  })
}

resource "aws_internet_gateway" "region_1" {
  vpc_id = aws_vpc.region_1.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r1-igw"
    RegionGroup = "region-1"
  })
}

resource "aws_subnet" "public_region_1" {
  vpc_id                  = aws_vpc.region_1.id
  cidr_block              = var.public_subnet_region_1_cidr
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r1-public-subnet"
    RegionGroup = "region-1"
  })
}

resource "aws_subnet" "private_region_1" {
  vpc_id     = aws_vpc.region_1.id
  cidr_block = var.private_subnet_region_1_cidr

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r1-private-subnet"
    RegionGroup = "region-1"
  })
}

resource "aws_route_table" "public_region_1" {
  vpc_id = aws_vpc.region_1.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r1-public-rt"
    RegionGroup = "region-1"
  })
}

resource "aws_route" "public_default_internet_region_1" {
  route_table_id         = aws_route_table.public_region_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.region_1.id
}

resource "aws_route_table_association" "public_region_1" {
  subnet_id      = aws_subnet.public_region_1.id
  route_table_id = aws_route_table.public_region_1.id
}

resource "aws_route_table" "private_region_1" {
  vpc_id = aws_vpc.region_1.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r1-private-rt"
    RegionGroup = "region-1"
  })
}

resource "aws_route_table_association" "private_region_1" {
  subnet_id      = aws_subnet.private_region_1.id
  route_table_id = aws_route_table.private_region_1.id
}

resource "aws_vpc" "region_2" {
  provider = aws.region2

  cidr_block           = var.vpc_region_2_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r2-vpc"
    RegionGroup = "region-2"
  })
}

resource "aws_internet_gateway" "region_2" {
  provider = aws.region2

  vpc_id = aws_vpc.region_2.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r2-igw"
    RegionGroup = "region-2"
  })
}

resource "aws_subnet" "public_region_2" {
  provider = aws.region2

  vpc_id                  = aws_vpc.region_2.id
  cidr_block              = var.public_subnet_region_2_cidr
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r2-public-subnet"
    RegionGroup = "region-2"
  })
}

resource "aws_subnet" "private_region_2" {
  provider = aws.region2

  vpc_id     = aws_vpc.region_2.id
  cidr_block = var.private_subnet_region_2_cidr

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r2-private-subnet"
    RegionGroup = "region-2"
  })
}

resource "aws_route_table" "public_region_2" {
  provider = aws.region2

  vpc_id = aws_vpc.region_2.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r2-public-rt"
    RegionGroup = "region-2"
  })
}

resource "aws_route" "public_default_internet_region_2" {
  provider = aws.region2

  route_table_id         = aws_route_table.public_region_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.region_2.id
}

resource "aws_route_table_association" "public_region_2" {
  provider = aws.region2

  subnet_id      = aws_subnet.public_region_2.id
  route_table_id = aws_route_table.public_region_2.id
}

resource "aws_route_table" "private_region_2" {
  provider = aws.region2

  vpc_id = aws_vpc.region_2.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r2-private-rt"
    RegionGroup = "region-2"
  })
}

resource "aws_route_table_association" "private_region_2" {
  provider = aws.region2

  subnet_id      = aws_subnet.private_region_2.id
  route_table_id = aws_route_table.private_region_2.id
}

resource "aws_vpc" "region_3" {
  provider = aws.region3

  cidr_block           = var.vpc_region_3_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r3-vpc"
    RegionGroup = "region-3"
  })
}

resource "aws_internet_gateway" "region_3" {
  provider = aws.region3

  vpc_id = aws_vpc.region_3.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r3-igw"
    RegionGroup = "region-3"
  })
}

resource "aws_subnet" "public_region_3" {
  provider = aws.region3

  vpc_id                  = aws_vpc.region_3.id
  cidr_block              = var.public_subnet_region_3_cidr
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r3-public-subnet"
    RegionGroup = "region-3"
  })
}

resource "aws_subnet" "private_region_3" {
  provider = aws.region3

  vpc_id     = aws_vpc.region_3.id
  cidr_block = var.private_subnet_region_3_cidr

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r3-private-subnet"
    RegionGroup = "region-3"
  })
}

resource "aws_route_table" "public_region_3" {
  provider = aws.region3

  vpc_id = aws_vpc.region_3.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r3-public-rt"
    RegionGroup = "region-3"
  })
}

resource "aws_route" "public_default_internet_region_3" {
  provider = aws.region3

  route_table_id         = aws_route_table.public_region_3.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.region_3.id
}

resource "aws_route_table_association" "public_region_3" {
  provider = aws.region3

  subnet_id      = aws_subnet.public_region_3.id
  route_table_id = aws_route_table.public_region_3.id
}

resource "aws_route_table" "private_region_3" {
  provider = aws.region3

  vpc_id = aws_vpc.region_3.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-r3-private-rt"
    RegionGroup = "region-3"
  })
}

resource "aws_route_table_association" "private_region_3" {
  provider = aws.region3

  subnet_id      = aws_subnet.private_region_3.id
  route_table_id = aws_route_table.private_region_3.id
}

data "terraform_remote_state" "hcp_vault_aws" {
  count   = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? 1 : 0
  backend = "s3"

  config = {
    bucket = "hcp-vault-demo-terraform-state"
    key    = "terraform/hcp-vault-aws/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  r1_primary_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_region_1, null) : null
  r2_primary_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_region_2, null) : null
  r3_primary_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_region_3, null) : null

  r2_dr_for_r1_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_dr_region_2_for_region_1, null) : null
  r3_dr_for_r2_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_dr_region_3_for_region_2, null) : null
  r1_dr_for_r3_peering_id = var.enable_hcp_peering_acceptance || var.enable_hcp_routes ? try(data.terraform_remote_state.hcp_vault_aws[0].outputs.provider_peering_dr_region_1_for_region_3, null) : null
}

resource "aws_vpc_peering_connection_accepter" "region_1_primary" {
  count = var.enable_hcp_peering_acceptance && local.r1_primary_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r1_primary_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_2_primary" {
  provider = aws.region2

  count = var.enable_hcp_peering_acceptance && local.r2_primary_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r2_primary_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_3_primary" {
  provider = aws.region3

  count = var.enable_hcp_peering_acceptance && local.r3_primary_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r3_primary_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_2_dr_for_region_1" {
  provider = aws.region2

  count = var.enable_hcp_peering_acceptance && local.r2_dr_for_r1_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r2_dr_for_r1_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_3_dr_for_region_2" {
  provider = aws.region3

  count = var.enable_hcp_peering_acceptance && local.r3_dr_for_r2_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r3_dr_for_r2_peering_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "region_1_dr_for_region_3" {
  count = var.enable_hcp_peering_acceptance && local.r1_dr_for_r3_peering_id != null ? 1 : 0

  vpc_peering_connection_id = local.r1_dr_for_r3_peering_id
  auto_accept               = true
}

resource "aws_route" "public_to_region_1_primary_hvn" {
  count = var.enable_hcp_routes && local.r1_primary_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.public_region_1.id
  destination_cidr_block    = var.hvn_region_1_primary_cidr
  vpc_peering_connection_id = local.r1_primary_peering_id
}

resource "aws_route" "private_to_region_1_primary_hvn" {
  count = var.enable_hcp_routes && local.r1_primary_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.private_region_1.id
  destination_cidr_block    = var.hvn_region_1_primary_cidr
  vpc_peering_connection_id = local.r1_primary_peering_id
}

resource "aws_route" "public_to_region_2_primary_hvn" {
  provider = aws.region2

  count = var.enable_hcp_routes && local.r2_primary_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.public_region_2.id
  destination_cidr_block    = var.hvn_region_2_primary_cidr
  vpc_peering_connection_id = local.r2_primary_peering_id
}

resource "aws_route" "private_to_region_2_primary_hvn" {
  provider = aws.region2

  count = var.enable_hcp_routes && local.r2_primary_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.private_region_2.id
  destination_cidr_block    = var.hvn_region_2_primary_cidr
  vpc_peering_connection_id = local.r2_primary_peering_id
}

resource "aws_route" "public_to_region_3_primary_hvn" {
  provider = aws.region3

  count = var.enable_hcp_routes && local.r3_primary_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.public_region_3.id
  destination_cidr_block    = var.hvn_region_3_primary_cidr
  vpc_peering_connection_id = local.r3_primary_peering_id
}

resource "aws_route" "private_to_region_3_primary_hvn" {
  provider = aws.region3

  count = var.enable_hcp_routes && local.r3_primary_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.private_region_3.id
  destination_cidr_block    = var.hvn_region_3_primary_cidr
  vpc_peering_connection_id = local.r3_primary_peering_id
}

resource "aws_route" "public_to_region_2_dr_for_region_1_hvn" {
  provider = aws.region2

  count = var.enable_hcp_routes && local.r2_dr_for_r1_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.public_region_2.id
  destination_cidr_block    = var.hvn_region_2_dr_for_region_1_cidr
  vpc_peering_connection_id = local.r2_dr_for_r1_peering_id
}

resource "aws_route" "private_to_region_2_dr_for_region_1_hvn" {
  provider = aws.region2

  count = var.enable_hcp_routes && local.r2_dr_for_r1_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.private_region_2.id
  destination_cidr_block    = var.hvn_region_2_dr_for_region_1_cidr
  vpc_peering_connection_id = local.r2_dr_for_r1_peering_id
}

resource "aws_route" "public_to_region_3_dr_for_region_2_hvn" {
  provider = aws.region3

  count = var.enable_hcp_routes && local.r3_dr_for_r2_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.public_region_3.id
  destination_cidr_block    = var.hvn_region_3_dr_for_region_2_cidr
  vpc_peering_connection_id = local.r3_dr_for_r2_peering_id
}

resource "aws_route" "private_to_region_3_dr_for_region_2_hvn" {
  provider = aws.region3

  count = var.enable_hcp_routes && local.r3_dr_for_r2_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.private_region_3.id
  destination_cidr_block    = var.hvn_region_3_dr_for_region_2_cidr
  vpc_peering_connection_id = local.r3_dr_for_r2_peering_id
}

resource "aws_route" "public_to_region_1_dr_for_region_3_hvn" {
  count = var.enable_hcp_routes && local.r1_dr_for_r3_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.public_region_1.id
  destination_cidr_block    = var.hvn_region_1_dr_for_region_3_cidr
  vpc_peering_connection_id = local.r1_dr_for_r3_peering_id
}

resource "aws_route" "private_to_region_1_dr_for_region_3_hvn" {
  count = var.enable_hcp_routes && local.r1_dr_for_r3_peering_id != null ? 1 : 0

  route_table_id            = aws_route_table.private_region_1.id
  destination_cidr_block    = var.hvn_region_1_dr_for_region_3_cidr
  vpc_peering_connection_id = local.r1_dr_for_r3_peering_id
}

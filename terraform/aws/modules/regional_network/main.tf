resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${var.region_short}-vpc"
    RegionGroup = var.region_group
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${var.region_short}-igw"
    RegionGroup = var.region_group
  })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${var.region_short}-public-subnet"
    RegionGroup = var.region_group
  })
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${var.region_short}-private-subnet"
    RegionGroup = var.region_group
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${var.region_short}-public-rt"
    RegionGroup = var.region_group
  })
}

resource "aws_route" "public_default_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${var.region_short}-private-rt"
    RegionGroup = var.region_group
  })
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

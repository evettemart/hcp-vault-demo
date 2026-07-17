locals {
  identifier = substr(replace(lower("${var.name_prefix}-${var.region_short}-pg"), "/[^a-z0-9-]/", "-"), 0, 63)
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name        = "${local.identifier}-subnet-group"
    RegionGroup = var.region_group
  })
}

resource "aws_security_group" "this" {
  name        = "${local.identifier}-sg"
  description = "RDS PostgreSQL access for Vault testing"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name        = "${local.identifier}-sg"
    RegionGroup = var.region_group
  })
}

resource "aws_vpc_security_group_ingress_rule" "postgres" {
  for_each = toset(var.allowed_cidrs)

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.key
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
  description       = "Allow PostgreSQL access"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

resource "aws_db_instance" "this" {
  identifier                 = local.identifier
  engine                     = "postgres"
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  storage_type               = "gp3"
  db_name                    = var.db_name
  username                   = var.username
  password                   = var.password
  port                       = 5432
  publicly_accessible        = false
  multi_az                   = false
  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = [aws_security_group.this.id]
  backup_retention_period    = 0
  skip_final_snapshot        = true
  deletion_protection        = false
  delete_automated_backups   = true
  apply_immediately          = true
  auto_minor_version_upgrade = true

  tags = merge(var.tags, {
    Name        = local.identifier
    RegionGroup = var.region_group
  })
}

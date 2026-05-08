resource "hcp_hvn" "hvn_region_1" {
  hvn_id         = var.region_1_primary_hvn_id
  cloud_provider = "aws"
  region         = var.region_1_primary_hvn_region
  cidr_block     = var.region_1_primary_hvn_cidr
  project_id     = var.project_id
}

resource "hcp_hvn" "hvn_region_2" {
  hvn_id         = var.region_2_primary_hvn_id
  cloud_provider = "aws"
  region         = var.region_2_primary_hvn_region
  cidr_block     = var.region_2_primary_hvn_cidr
  project_id     = var.project_id
}

resource "hcp_hvn" "hvn_region_3" {
  hvn_id         = var.region_3_primary_hvn_id
  cloud_provider = "aws"
  region         = var.region_3_primary_hvn_region
  cidr_block     = var.region_3_primary_hvn_cidr
  project_id     = var.project_id
}

resource "hcp_hvn" "hvn_dr_region_2_for_region_1" {
  hvn_id         = var.region_2_dr_for_region_1_hvn_id
  cloud_provider = "aws"
  region         = var.region_2_dr_for_region_1_hvn_region
  cidr_block     = var.region_2_dr_for_region_1_hvn_cidr
  project_id     = var.project_id
}

resource "hcp_hvn" "hvn_dr_region_3_for_region_2" {
  hvn_id         = var.region_3_dr_for_region_2_hvn_id
  cloud_provider = "aws"
  region         = var.region_3_dr_for_region_2_hvn_region
  cidr_block     = var.region_3_dr_for_region_2_hvn_cidr
  project_id     = var.project_id
}

resource "hcp_hvn" "hvn_dr_region_1_for_region_3" {
  hvn_id         = var.region_1_dr_for_region_3_hvn_id
  cloud_provider = "aws"
  region         = var.region_1_dr_for_region_3_hvn_region
  cidr_block     = var.region_1_dr_for_region_3_hvn_cidr
  project_id     = var.project_id
}

resource "hcp_vault_cluster" "vault_region_1" {
  cluster_id        = var.region_1_primary_cluster_id
  hvn_id            = hcp_hvn.hvn_region_1.hvn_id
  tier              = var.region_1_primary_cluster_tier
  project_id        = var.project_id
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version

  dynamic "ip_allowlist" {
    for_each = var.vault_public_endpoint ? { for item in var.vault_ip_allowlist : item.address => item } : {}
    content {
      address     = ip_allowlist.value.address
      description = ip_allowlist.value.description
    }
  }
}

resource "hcp_vault_cluster" "vault_region_2" {
  cluster_id        = var.region_2_primary_cluster_id
  hvn_id            = hcp_hvn.hvn_region_2.hvn_id
  tier              = var.region_2_primary_cluster_tier
  project_id        = var.project_id
  primary_link      = hcp_vault_cluster.vault_region_1.self_link
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version

  dynamic "ip_allowlist" {
    for_each = var.vault_public_endpoint ? { for item in var.vault_ip_allowlist : item.address => item } : {}
    content {
      address     = ip_allowlist.value.address
      description = ip_allowlist.value.description
    }
  }

  depends_on = [hcp_vault_cluster.vault_region_1]
}

resource "hcp_vault_cluster" "vault_region_3" {
  cluster_id        = var.region_3_primary_cluster_id
  hvn_id            = hcp_hvn.hvn_region_3.hvn_id
  tier              = var.region_3_primary_cluster_tier
  project_id        = var.project_id
  primary_link      = hcp_vault_cluster.vault_region_1.self_link
  public_endpoint   = var.vault_public_endpoint
  proxy_endpoint    = var.vault_proxy_endpoint
  min_vault_version = var.vault_min_vault_version

  dynamic "ip_allowlist" {
    for_each = var.vault_public_endpoint ? { for item in var.vault_ip_allowlist : item.address => item } : {}
    content {
      address     = ip_allowlist.value.address
      description = ip_allowlist.value.description
    }
  }

  depends_on = [hcp_vault_cluster.vault_region_1]
}

data "terraform_remote_state" "aws" {
  backend = "s3"
  config = {
    bucket = var.aws_state_bucket
    key    = var.aws_state_key
    region = var.aws_state_region
  }
}

resource "hcp_aws_network_peering" "peer_region_1" {
  hvn_id          = hcp_hvn.hvn_region_1.hvn_id
  peering_id      = var.region_1_primary_to_aws_peering_id
  peer_vpc_id     = data.terraform_remote_state.aws.outputs.vpc_region_1_id
  peer_account_id = data.terraform_remote_state.aws.outputs.aws_account_id
  peer_vpc_region = data.terraform_remote_state.aws.outputs.aws_region_1
}

resource "hcp_aws_network_peering" "peer_region_2" {
  hvn_id          = hcp_hvn.hvn_region_2.hvn_id
  peering_id      = var.region_2_primary_to_aws_peering_id
  peer_vpc_id     = data.terraform_remote_state.aws.outputs.vpc_region_2_id
  peer_account_id = data.terraform_remote_state.aws.outputs.aws_account_id
  peer_vpc_region = data.terraform_remote_state.aws.outputs.aws_region_2
}

resource "hcp_aws_network_peering" "peer_region_3" {
  hvn_id          = hcp_hvn.hvn_region_3.hvn_id
  peering_id      = var.region_3_primary_to_aws_peering_id
  peer_vpc_id     = data.terraform_remote_state.aws.outputs.vpc_region_3_id
  peer_account_id = data.terraform_remote_state.aws.outputs.aws_account_id
  peer_vpc_region = data.terraform_remote_state.aws.outputs.aws_region_3
}

resource "hcp_aws_network_peering" "peer_dr_region_2_for_region_1" {
  hvn_id          = hcp_hvn.hvn_dr_region_2_for_region_1.hvn_id
  peering_id      = var.region_2_dr_for_region_1_to_aws_peering_id
  peer_vpc_id     = data.terraform_remote_state.aws.outputs.vpc_region_2_id
  peer_account_id = data.terraform_remote_state.aws.outputs.aws_account_id
  peer_vpc_region = data.terraform_remote_state.aws.outputs.aws_region_2
}

resource "hcp_aws_network_peering" "peer_dr_region_3_for_region_2" {
  hvn_id          = hcp_hvn.hvn_dr_region_3_for_region_2.hvn_id
  peering_id      = var.region_3_dr_for_region_2_to_aws_peering_id
  peer_vpc_id     = data.terraform_remote_state.aws.outputs.vpc_region_3_id
  peer_account_id = data.terraform_remote_state.aws.outputs.aws_account_id
  peer_vpc_region = data.terraform_remote_state.aws.outputs.aws_region_3
}

resource "hcp_aws_network_peering" "peer_dr_region_1_for_region_3" {
  hvn_id          = hcp_hvn.hvn_dr_region_1_for_region_3.hvn_id
  peering_id      = var.region_1_dr_for_region_3_to_aws_peering_id
  peer_vpc_id     = data.terraform_remote_state.aws.outputs.vpc_region_1_id
  peer_account_id = data.terraform_remote_state.aws.outputs.aws_account_id
  peer_vpc_region = data.terraform_remote_state.aws.outputs.aws_region_1
}

resource "hcp_hvn_route" "route_region_1_to_aws" {
  hvn_link         = hcp_hvn.hvn_region_1.self_link
  hvn_route_id     = var.region_1_primary_to_aws_route_id
  destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_1_cidr_block
  target_link      = hcp_aws_network_peering.peer_region_1.self_link
}

resource "hcp_hvn_route" "route_region_2_to_aws" {
  hvn_link         = hcp_hvn.hvn_region_2.self_link
  hvn_route_id     = var.region_2_primary_to_aws_route_id
  destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_2_cidr_block
  target_link      = hcp_aws_network_peering.peer_region_2.self_link
}

resource "hcp_hvn_route" "route_region_3_to_aws" {
  hvn_link         = hcp_hvn.hvn_region_3.self_link
  hvn_route_id     = var.region_3_primary_to_aws_route_id
  destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_3_cidr_block
  target_link      = hcp_aws_network_peering.peer_region_3.self_link
}

resource "hcp_hvn_route" "route_dr_region_2_for_region_1_to_aws" {
  hvn_link         = hcp_hvn.hvn_dr_region_2_for_region_1.self_link
  hvn_route_id     = var.region_2_dr_for_region_1_to_aws_route_id
  destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_2_cidr_block
  target_link      = hcp_aws_network_peering.peer_dr_region_2_for_region_1.self_link
}

resource "hcp_hvn_route" "route_dr_region_3_for_region_2_to_aws" {
  hvn_link         = hcp_hvn.hvn_dr_region_3_for_region_2.self_link
  hvn_route_id     = var.region_3_dr_for_region_2_to_aws_route_id
  destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_3_cidr_block
  target_link      = hcp_aws_network_peering.peer_dr_region_3_for_region_2.self_link
}

resource "hcp_hvn_route" "route_dr_region_1_for_region_3_to_aws" {
  hvn_link         = hcp_hvn.hvn_dr_region_1_for_region_3.self_link
  hvn_route_id     = var.region_1_dr_for_region_3_to_aws_route_id
  destination_cidr = data.terraform_remote_state.aws.outputs.vpc_region_1_cidr_block
  target_link      = hcp_aws_network_peering.peer_dr_region_1_for_region_3.self_link
}

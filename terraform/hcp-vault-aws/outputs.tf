output "cluster_region_1_id" {
  value       = hcp_vault_cluster.vault_region_1.cluster_id
  description = "Region 1 primary Vault cluster ID"
}

output "cluster_region_2_id" {
  value       = hcp_vault_cluster.vault_region_2.cluster_id
  description = "Region 2 primary Vault cluster ID"
}

output "cluster_region_3_id" {
  value       = hcp_vault_cluster.vault_region_3.cluster_id
  description = "Region 3 primary Vault cluster ID"
}

output "cluster_region_1_public_endpoint" {
  value       = hcp_vault_cluster.vault_region_1.vault_public_endpoint_url
  description = "Region 1 public endpoint"
}

output "cluster_region_2_public_endpoint" {
  value       = hcp_vault_cluster.vault_region_2.vault_public_endpoint_url
  description = "Region 2 public endpoint"
}

output "cluster_region_3_public_endpoint" {
  value       = hcp_vault_cluster.vault_region_3.vault_public_endpoint_url
  description = "Region 3 public endpoint"
}

output "provider_peering_region_1" {
  value       = hcp_aws_network_peering.peer_region_1.provider_peering_id
  description = "Provider-side peering ID for region 1 HVN"
}

output "provider_peering_region_2" {
  value       = hcp_aws_network_peering.peer_region_2.provider_peering_id
  description = "Provider-side peering ID for region 2 HVN"
}

output "provider_peering_region_3" {
  value       = hcp_aws_network_peering.peer_region_3.provider_peering_id
  description = "Provider-side peering ID for region 3 HVN"
}

output "provider_peering_dr_region_2_for_region_1" {
  value       = hcp_aws_network_peering.peer_dr_region_2_for_region_1.provider_peering_id
  description = "Provider-side peering ID for region 2 DR HVN (for region 1)"
}

output "provider_peering_dr_region_3_for_region_2" {
  value       = hcp_aws_network_peering.peer_dr_region_3_for_region_2.provider_peering_id
  description = "Provider-side peering ID for region 3 DR HVN (for region 2)"
}

output "provider_peering_dr_region_1_for_region_3" {
  value       = hcp_aws_network_peering.peer_dr_region_1_for_region_3.provider_peering_id
  description = "Provider-side peering ID for region 1 DR HVN (for region 3)"
}

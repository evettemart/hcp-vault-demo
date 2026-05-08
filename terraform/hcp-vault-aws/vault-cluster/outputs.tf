output "cluster_region_1_id" {
  value       = module.vault_region_1.cluster_id
  description = "Region 1 primary Vault cluster ID"
}

output "cluster_region_2_id" {
  value       = module.vault_region_2.cluster_id
  description = "Region 2 primary Vault cluster ID"
}

output "cluster_region_3_id" {
  value       = module.vault_region_3.cluster_id
  description = "Region 3 primary Vault cluster ID"
}

output "cluster_region_1_public_endpoint" {
  value       = module.vault_region_1.public_endpoint_url
  description = "Region 1 public endpoint"
}

output "cluster_region_2_public_endpoint" {
  value       = module.vault_region_2.public_endpoint_url
  description = "Region 2 public endpoint"
}

output "cluster_region_3_public_endpoint" {
  value       = module.vault_region_3.public_endpoint_url
  description = "Region 3 public endpoint"
}

output "provider_peering_region_1" {
  value       = module.hvn_aws_connectivity["region_1_primary"].provider_peering_id
  description = "Provider-side peering ID for region 1 HVN"
}

output "provider_peering_region_2" {
  value       = module.hvn_aws_connectivity["region_2_primary"].provider_peering_id
  description = "Provider-side peering ID for region 2 HVN"
}

output "provider_peering_region_3" {
  value       = module.hvn_aws_connectivity["region_3_primary"].provider_peering_id
  description = "Provider-side peering ID for region 3 HVN"
}

output "provider_peering_dr_region_2_for_region_1" {
  value       = module.hvn_aws_connectivity["region_2_dr_for_region_1"].provider_peering_id
  description = "Provider-side peering ID for region 2 DR HVN (for region 1)"
}

output "provider_peering_dr_region_3_for_region_2" {
  value       = module.hvn_aws_connectivity["region_3_dr_for_region_2"].provider_peering_id
  description = "Provider-side peering ID for region 3 DR HVN (for region 2)"
}

output "provider_peering_dr_region_1_for_region_3" {
  value       = module.hvn_aws_connectivity["region_1_dr_for_region_3"].provider_peering_id
  description = "Provider-side peering ID for region 1 DR HVN (for region 3)"
}

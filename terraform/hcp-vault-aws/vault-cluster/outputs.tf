output "cluster_region_1_id" {
  value       = try(module.vault_primary.cluster_id, null)
  description = "Region 1 primary Vault cluster ID"
}

output "cluster_region_2_id" {
  value       = try(module.vault_secondary["region_2_primary"].cluster_id, null)
  description = "Region 2 primary Vault cluster ID"
}

output "cluster_region_3_id" {
  value       = try(module.vault_secondary["region_3_primary"].cluster_id, null)
  description = "Region 3 primary Vault cluster ID"
}

output "cluster_region_1_public_endpoint" {
  value       = try(module.vault_primary.public_endpoint_url, null)
  description = "Region 1 public endpoint"
}

output "cluster_region_2_public_endpoint" {
  value       = try(module.vault_secondary["region_2_primary"].public_endpoint_url, null)
  description = "Region 2 public endpoint"
}

output "cluster_region_3_public_endpoint" {
  value       = try(module.vault_secondary["region_3_primary"].public_endpoint_url, null)
  description = "Region 3 public endpoint"
}

output "provider_tgw_attachment_region_1" {
  value       = try(module.hvn_aws_connectivity["region_1_primary"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side transit gateway attachment ID for region 1 HVN"
}

output "provider_tgw_attachment_region_2" {
  value       = try(module.hvn_aws_connectivity["region_2_primary"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side transit gateway attachment ID for region 2 HVN"
}

output "provider_tgw_attachment_region_3" {
  value       = try(module.hvn_aws_connectivity["region_3_primary"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side transit gateway attachment ID for region 3 HVN"
}

output "provider_tgw_attachment_dr_region_2_for_region_1" {
  value       = try(module.hvn_aws_connectivity["region_2_dr_for_region_1"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side transit gateway attachment ID for region 2 DR HVN (for region 1)"
}

output "provider_tgw_attachment_dr_region_3_for_region_2" {
  value       = try(module.hvn_aws_connectivity["region_3_dr_for_region_2"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side transit gateway attachment ID for region 3 DR HVN (for region 2)"
}

output "provider_tgw_attachment_dr_region_1_for_region_3" {
  value       = try(module.hvn_aws_connectivity["region_1_dr_for_region_3"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side transit gateway attachment ID for region 1 DR HVN (for region 3)"
}

output "hvn_provider_account_id_region_1_primary" {
  value       = try(module.hvn["region_1_primary"].provider_account_id, null)
  description = "HCP provider AWS account ID for Region 1 primary HVN"
}

output "hvn_provider_account_id_region_2_primary" {
  value       = try(module.hvn["region_2_primary"].provider_account_id, null)
  description = "HCP provider AWS account ID for Region 2 primary HVN"
}

output "hvn_provider_account_id_region_3_primary" {
  value       = try(module.hvn["region_3_primary"].provider_account_id, null)
  description = "HCP provider AWS account ID for Region 3 primary HVN"
}

output "hvn_provider_account_id_region_2_dr_for_region_1" {
  value       = try(module.hvn["region_2_dr_for_region_1"].provider_account_id, null)
  description = "HCP provider AWS account ID for Region 2 DR HVN"
}

output "hvn_provider_account_id_region_3_dr_for_region_2" {
  value       = try(module.hvn["region_3_dr_for_region_2"].provider_account_id, null)
  description = "HCP provider AWS account ID for Region 3 DR HVN"
}

output "hvn_provider_account_id_region_1_dr_for_region_3" {
  value       = try(module.hvn["region_1_dr_for_region_3"].provider_account_id, null)
  description = "HCP provider AWS account ID for Region 1 DR HVN"
}

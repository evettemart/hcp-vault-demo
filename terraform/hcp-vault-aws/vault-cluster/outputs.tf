output "cluster_1_id" {
  value       = try(module.vault_primary.cluster_id, null)
  description = "Cluster 1 ID (primary)"
}

output "cluster_2_id" {
  value       = try(module.vault_secondary_to_cluster_1["cluster_2"].cluster_id, null)
  description = "Cluster 2 ID (manual DR cluster; null when not Terraform-managed)"
}

output "cluster_3_id" {
  value       = try(module.vault_secondary_to_cluster_1["cluster_3"].cluster_id, null)
  description = "Cluster 3 ID (performance replica to cluster 1 in prod; null in non-prod)"
}

output "cluster_5_id" {
  value       = try(module.vault_secondary_to_cluster_1["cluster_5"].cluster_id, null)
  description = "Cluster 5 ID (performance replica to cluster 1 in prod; null in non-prod)"
}

output "cluster_1_public_endpoint" {
  value       = try(module.vault_primary.public_endpoint_url, null)
  description = "Cluster 1 public endpoint"
}

output "cluster_2_public_endpoint" {
  value       = try(module.vault_secondary_to_cluster_1["cluster_2"].public_endpoint_url, null)
  description = "Cluster 2 public endpoint (null when not Terraform-managed)"
}

output "cluster_3_public_endpoint" {
  value       = try(module.vault_secondary_to_cluster_1["cluster_3"].public_endpoint_url, null)
  description = "Cluster 3 public endpoint"
}

output "cluster_5_public_endpoint" {
  value       = try(module.vault_secondary_to_cluster_1["cluster_5"].public_endpoint_url, null)
  description = "Cluster 5 public endpoint"
}

output "provider_tgw_attachment_cluster_1" {
  value       = try(module.hvn_aws_connectivity["cluster_1"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side TGW attachment ID for cluster 1"
}

output "provider_tgw_attachment_cluster_2" {
  value       = try(module.hvn_aws_connectivity["cluster_2"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side TGW attachment ID for cluster 2"
}

output "provider_tgw_attachment_cluster_3" {
  value       = try(module.hvn_aws_connectivity["cluster_3"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side TGW attachment ID for cluster 3"
}

output "provider_tgw_attachment_cluster_4" {
  value       = try(module.hvn_aws_connectivity["cluster_4"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side TGW attachment ID for cluster 4"
}

output "provider_tgw_attachment_cluster_5" {
  value       = try(module.hvn_aws_connectivity["cluster_5"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side TGW attachment ID for cluster 5"
}

output "provider_tgw_attachment_cluster_6" {
  value       = try(module.hvn_aws_connectivity["cluster_6"].provider_transit_gateway_attachment_id, null)
  description = "Provider-side TGW attachment ID for cluster 6"
}

output "hvn_provider_account_id_cluster_1" {
  value       = try(module.hvn["cluster_1"].provider_account_id, null)
  description = "HCP provider AWS account ID for cluster 1 HVN"
}

output "hvn_provider_account_id_cluster_2" {
  value       = try(module.hvn["cluster_2"].provider_account_id, null)
  description = "HCP provider AWS account ID for cluster 2 HVN"
}

output "hvn_provider_account_id_cluster_3" {
  value       = try(module.hvn["cluster_3"].provider_account_id, null)
  description = "HCP provider AWS account ID for cluster 3 HVN"
}

output "hvn_provider_account_id_cluster_4" {
  value       = try(module.hvn["cluster_4"].provider_account_id, null)
  description = "HCP provider AWS account ID for cluster 4 HVN"
}

output "hvn_provider_account_id_cluster_5" {
  value       = try(module.hvn["cluster_5"].provider_account_id, null)
  description = "HCP provider AWS account ID for cluster 5 HVN"
}

output "hvn_provider_account_id_cluster_6" {
  value       = try(module.hvn["cluster_6"].provider_account_id, null)
  description = "HCP provider AWS account ID for cluster 6 HVN"
}

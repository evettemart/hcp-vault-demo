output "cluster_id" {
  description = "Vault cluster ID"
  value       = hcp_vault_cluster.this.cluster_id
}

output "self_link" {
  description = "Vault cluster self link"
  value       = hcp_vault_cluster.this.self_link
}

output "public_endpoint_url" {
  description = "Vault public endpoint URL"
  value       = hcp_vault_cluster.this.vault_public_endpoint_url
}

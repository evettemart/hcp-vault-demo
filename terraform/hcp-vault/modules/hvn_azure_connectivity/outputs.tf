output "peering_id" {
  description = "Azure peering connection ID"
  value       = hcp_azure_peering_connection.this.peering_id
}

output "peering_self_link" {
  description = "Azure peering self link"
  value       = hcp_azure_peering_connection.this.self_link
}

output "peering_state" {
  description = "Azure peering connection state"
  value       = hcp_azure_peering_connection.this.state
}

output "peering_application_id" {
  description = "HCP application ID used for Azure peering acceptance"
  value       = hcp_azure_peering_connection.this.application_id
}

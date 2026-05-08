output "provider_peering_id" {
  description = "Provider-side peering ID"
  value       = hcp_aws_network_peering.this.provider_peering_id
}

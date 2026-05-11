output "hvn_id" {
  description = "HVN ID"
  value       = hcp_hvn.this.hvn_id
}

output "self_link" {
  description = "HVN self link"
  value       = hcp_hvn.this.self_link
}

output "provider_account_id" {
  description = "HCP-managed AWS provider account ID for this HVN"
  value       = hcp_hvn.this.provider_account_id
}

output "provider_transit_gateway_attachment_id" {
  description = "Provider-side transit gateway attachment ID"
  value       = hcp_aws_transit_gateway_attachment.this.provider_transit_gateway_attachment_id
}

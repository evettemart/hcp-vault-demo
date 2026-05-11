output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = aws_ec2_transit_gateway.this.id
}

output "resource_share_arn" {
  description = "RAM resource share ARN"
  value       = aws_ram_resource_share.this.arn
}
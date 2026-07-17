output "identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.this.identifier
}

output "address" {
  description = "RDS instance endpoint address"
  value       = aws_db_instance.this.address
}

output "endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "RDS instance port"
  value       = aws_db_instance.this.port
}

output "username" {
  description = "Master username"
  value       = aws_db_instance.this.username
}

output "password" {
  description = "Master password"
  value       = var.password
  sensitive   = true
}

output "security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.this.id
}

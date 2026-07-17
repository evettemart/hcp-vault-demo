output "mount_path" {
  description = "Database secrets engine mount path"
  value       = vault_mount.this.path
}

output "connection_names" {
  description = "Database connection names"
  value       = sort(keys(vault_generic_endpoint.connection))
}

output "role_names" {
  description = "Database secrets engine role names"
  value       = sort(keys(vault_generic_endpoint.role))
}

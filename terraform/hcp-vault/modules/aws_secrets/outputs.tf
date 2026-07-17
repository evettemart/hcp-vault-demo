output "mount_path" {
  description = "AWS secrets engine mount path"
  value       = vault_mount.this.path
}

output "role_names" {
  description = "AWS secrets engine role names"
  value       = sort(keys(vault_generic_endpoint.role))
}

output "config_root_path" {
  description = "AWS root config endpoint path when configured"
  value       = try(one(vault_generic_endpoint.config[*].path), null)
}

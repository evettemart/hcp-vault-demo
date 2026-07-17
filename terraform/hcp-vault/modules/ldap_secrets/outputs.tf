output "mount_path" {
  description = "LDAP secrets engine mount path"
  value       = vault_mount.this.path
}

output "role_names" {
  description = "LDAP secrets engine role names"
  value       = sort(keys(vault_generic_endpoint.role))
}

output "config_path" {
  description = "LDAP config endpoint path when configured"
  value       = try(one(vault_generic_endpoint.config[*].path), null)
}

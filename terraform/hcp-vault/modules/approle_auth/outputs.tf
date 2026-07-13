output "path" {
  description = "AppRole auth backend mount path"
  value       = vault_auth_backend.this.path
}

output "accessor" {
  description = "AppRole auth backend accessor"
  value       = vault_auth_backend.this.accessor
}

output "role_names" {
  description = "AppRole role names configured for this backend"
  value       = sort(keys(vault_generic_endpoint.role))
}

output "config_path" {
  description = "AppRole auth backend config endpoint path when configured"
  value       = one(vault_generic_endpoint.config[*].path)
}

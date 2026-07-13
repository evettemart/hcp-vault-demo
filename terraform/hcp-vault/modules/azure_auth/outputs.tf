output "path" {
  description = "Azure auth backend mount path"
  value       = vault_auth_backend.this.path
}

output "accessor" {
  description = "Azure auth backend accessor"
  value       = vault_auth_backend.this.accessor
}

output "role_names" {
  description = "Azure auth role names configured for this backend"
  value       = sort(keys(vault_generic_endpoint.role))
}

output "config_path" {
  description = "Azure auth backend config endpoint path when configured"
  value       = one(vault_generic_endpoint.config[*].path)
}

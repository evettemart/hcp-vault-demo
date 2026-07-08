output "path" {
  description = "OIDC auth backend mount path"
  value       = vault_jwt_auth_backend.this.path
}

output "accessor" {
  description = "OIDC auth backend accessor"
  value       = vault_jwt_auth_backend.this.accessor
}

output "role_names" {
  description = "OIDC/JWT role names configured for this auth backend"
  value       = sort(keys(vault_jwt_auth_backend_role.this))
}

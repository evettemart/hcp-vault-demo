output "group_names" {
  description = "Managed identity group names"
  value       = sort(keys(vault_identity_group.this))
}

output "alias_names" {
  description = "Managed identity group alias names"
  value       = sort([for alias in values(vault_identity_group_alias.this) : alias.name])
}

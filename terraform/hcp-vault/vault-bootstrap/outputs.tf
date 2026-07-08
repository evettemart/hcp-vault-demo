output "admin_namespace" {
  description = "Admin namespace path"
  value       = var.admin_namespace
}

output "child_namespaces" {
  description = "Child namespaces created under admin"
  value       = sort(keys(vault_namespace.admin_children))
}

output "auth_method_paths" {
  description = "Enabled auth method mount paths in admin namespace"
  value       = sort(keys(vault_auth_backend.admin))
}

output "policy_names" {
  description = "Policy names managed in admin namespace"
  value       = sort(keys(vault_policy.admin))
}

output "identity_group_names_by_namespace" {
  description = "Identity group names managed per namespace"
  value = {
    for namespace_name, mod in module.identity_groups :
    namespace_name => mod.group_names
  }
}

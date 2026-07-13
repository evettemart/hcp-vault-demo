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

output "oidc_auth_paths" {
  description = "OIDC auth backend mount paths keyed by mount path"
  value = {
    for mount_path, mod in module.oidc_admin :
    mount_path => mod.path
  }
}

output "oidc_auth_accessors" {
  description = "OIDC auth backend accessors keyed by mount path"
  value = {
    for mount_path, mod in module.oidc_admin :
    mount_path => mod.accessor
  }
}

output "oidc_role_names_by_mount" {
  description = "OIDC role names keyed by OIDC auth mount path"
  value = {
    for mount_path, mod in module.oidc_admin :
    mount_path => mod.role_names
  }
}

output "aws_auth_paths" {
  description = "AWS auth backend mount paths keyed by mount path"
  value = {
    for mount_path, mod in module.aws_auth_admin :
    mount_path => mod.path
  }
}

output "aws_auth_accessors" {
  description = "AWS auth backend accessors keyed by mount path"
  value = {
    for mount_path, mod in module.aws_auth_admin :
    mount_path => mod.accessor
  }
}

output "aws_role_names_by_mount" {
  description = "AWS role names keyed by AWS auth mount path"
  value = {
    for mount_path, mod in module.aws_auth_admin :
    mount_path => mod.role_names
  }
}

output "azure_auth_paths" {
  description = "Azure auth backend mount paths keyed by mount path"
  value = {
    for mount_path, mod in module.azure_auth_admin :
    mount_path => mod.path
  }
}

output "azure_auth_accessors" {
  description = "Azure auth backend accessors keyed by mount path"
  value = {
    for mount_path, mod in module.azure_auth_admin :
    mount_path => mod.accessor
  }
}

output "azure_role_names_by_mount" {
  description = "Azure role names keyed by Azure auth mount path"
  value = {
    for mount_path, mod in module.azure_auth_admin :
    mount_path => mod.role_names
  }
}

output "gcp_auth_paths" {
  description = "GCP auth backend mount paths keyed by mount path"
  value = {
    for mount_path, mod in module.gcp_auth_admin :
    mount_path => mod.path
  }
}

output "gcp_auth_accessors" {
  description = "GCP auth backend accessors keyed by mount path"
  value = {
    for mount_path, mod in module.gcp_auth_admin :
    mount_path => mod.accessor
  }
}

output "gcp_role_names_by_mount" {
  description = "GCP role names keyed by GCP auth mount path"
  value = {
    for mount_path, mod in module.gcp_auth_admin :
    mount_path => mod.role_names
  }
}

output "approle_auth_paths" {
  description = "AppRole auth backend mount paths keyed by mount path"
  value = {
    for mount_path, mod in module.approle_auth_admin :
    mount_path => mod.path
  }
}

output "approle_auth_accessors" {
  description = "AppRole auth backend accessors keyed by mount path"
  value = {
    for mount_path, mod in module.approle_auth_admin :
    mount_path => mod.accessor
  }
}

output "approle_role_names_by_mount" {
  description = "AppRole role names keyed by AppRole auth mount path"
  value = {
    for mount_path, mod in module.approle_auth_admin :
    mount_path => mod.role_names
  }
}

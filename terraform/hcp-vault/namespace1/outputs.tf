output "namespace" {
  description = "Namespace where SSH resources are managed"
  value       = var.namespace
}

output "kv_mount_paths" {
  description = "KV v2 mount paths"
  value = {
    for mount_path, mod in module.kv_v2 :
    mount_path => mod.mount_path
  }
}

output "policy_names" {
  description = "Vault policies applied from the namespace policy folder"
  value       = sort(keys(vault_policy.namespace))
}

output "ssh_mount_paths" {
  description = "SSH mount paths"
  value = {
    for mount_path, mod in module.ssh :
    mount_path => mod.mount_path
  }
}

output "ssh_ca_public_keys" {
  description = "SSH CA public keys by mount path"
  value = {
    for mount_path, mod in module.ssh :
    mount_path => mod.ssh_ca_public_key
  }
}

output "ssh_role_names_by_mount" {
  description = "SSH role names configured per mount path"
  value = {
    for mount_path, mod in module.ssh :
    mount_path => mod.role_names
  }
}

output "aws_secret_mount_paths" {
  description = "AWS secret engine mount paths"
  value = {
    for mount_path, mod in module.aws_secrets :
    mount_path => mod.mount_path
  }
}

output "aws_secret_role_names_by_mount" {
  description = "AWS secret engine role names by mount path"
  value = {
    for mount_path, mod in module.aws_secrets :
    mount_path => mod.role_names
  }
}

output "database_secret_mount_paths" {
  description = "Database secret engine mount paths"
  value = {
    for mount_path, mod in module.database_secrets :
    mount_path => mod.mount_path
  }
}

output "database_connection_names_by_mount" {
  description = "Database connection names by mount path"
  value = {
    for mount_path, mod in module.database_secrets :
    mount_path => mod.connection_names
  }
}

output "database_role_names_by_mount" {
  description = "Database role names by mount path"
  value = {
    for mount_path, mod in module.database_secrets :
    mount_path => mod.role_names
  }
}

output "ldap_secret_mount_paths" {
  description = "LDAP secret engine mount paths"
  value = {
    for mount_path, mod in module.ldap_secrets :
    mount_path => mod.mount_path
  }
}

output "ldap_secret_role_names_by_mount" {
  description = "LDAP secret engine role names by mount path"
  value = {
    for mount_path, mod in module.ldap_secrets :
    mount_path => mod.role_names
  }
}

output "kubernetes_secret_mount_paths" {
  description = "Kubernetes secret engine mount paths"
  value = {
    for mount_path, mod in module.kubernetes_secrets :
    mount_path => mod.mount_path
  }
}

output "kubernetes_secret_role_names_by_mount" {
  description = "Kubernetes secret engine role names by mount path"
  value = {
    for mount_path, mod in module.kubernetes_secrets :
    mount_path => mod.role_names
  }
}

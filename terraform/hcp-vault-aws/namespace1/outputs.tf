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

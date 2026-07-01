output "mount_path" {
  description = "SSH mount path"
  value       = vault_mount.ssh.path
}

output "ssh_ca_public_key" {
  description = "SSH CA public key for the mounted backend"
  value       = vault_ssh_secret_backend_ca.ssh.public_key
}

output "role_names" {
  description = "Managed SSH role names"
  value       = sort(keys(vault_ssh_secret_backend_role.ssh))
}

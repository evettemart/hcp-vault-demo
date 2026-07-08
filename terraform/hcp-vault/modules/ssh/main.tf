resource "vault_mount" "ssh" {
  path        = var.mount_path
  type        = "ssh"
  description = var.mount_description
}

resource "vault_ssh_secret_backend_ca" "ssh" {
  backend              = vault_mount.ssh.path
  generate_signing_key = var.generate_signing_key
}

resource "vault_ssh_secret_backend_role" "ssh" {
  for_each = var.roles

  backend                 = vault_mount.ssh.path
  name                    = each.key
  key_type                = try(each.value.key_type, null)
  allow_user_certificates = try(each.value.allow_user_certificates, null)
  allowed_users           = try(each.value.allowed_users, null)
  default_user            = try(each.value.default_user, null)
  ttl                     = try(each.value.ttl, null)
  algorithm_signer        = try(each.value.algorithm_signer, null)
  allowed_extensions      = try(each.value.allowed_extensions, null)
  default_extensions      = try(each.value.default_extensions, null)
}

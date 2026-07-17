resource "vault_mount" "this" {
  namespace   = var.namespace
  path        = var.mount_path
  type        = "ldap"
  description = var.mount_description
}

resource "vault_generic_endpoint" "config" {
  count = length(var.config) > 0 ? 1 : 0

  namespace            = var.namespace
  path                 = "${vault_mount.this.path}/config"
  data_json            = jsonencode(var.config)
  disable_delete       = var.disable_delete
  ignore_absent_fields = var.ignore_absent_fields
}

resource "vault_generic_endpoint" "role" {
  for_each = var.roles

  namespace            = var.namespace
  path                 = "${vault_mount.this.path}/role/${each.key}"
  data_json            = jsonencode(each.value)
  disable_delete       = var.disable_delete
  ignore_absent_fields = var.ignore_absent_fields
}

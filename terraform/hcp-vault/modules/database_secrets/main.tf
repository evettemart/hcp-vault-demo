resource "vault_mount" "this" {
  namespace   = var.namespace
  path        = var.mount_path
  type        = "database"
  description = var.mount_description
}

resource "vault_generic_endpoint" "connection" {
  for_each = var.connections

  namespace            = var.namespace
  path                 = "${vault_mount.this.path}/config/${each.key}"
  data_json            = jsonencode(each.value)
  disable_delete       = var.disable_delete
  ignore_absent_fields = var.ignore_absent_fields
}

resource "vault_generic_endpoint" "role" {
  for_each = var.roles

  namespace            = var.namespace
  path                 = "${vault_mount.this.path}/roles/${each.key}"
  data_json            = jsonencode(each.value)
  disable_delete       = var.disable_delete
  ignore_absent_fields = var.ignore_absent_fields
}

resource "vault_mount" "this" {
  namespace   = var.namespace
  path        = var.mount_path
  type        = "aws"
  description = var.mount_description
}

resource "vault_generic_endpoint" "config" {
  count = length(var.config_root) > 0 ? 1 : 0

  namespace            = var.namespace
  path                 = "${vault_mount.this.path}/config/root"
  data_json            = jsonencode(var.config_root)
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

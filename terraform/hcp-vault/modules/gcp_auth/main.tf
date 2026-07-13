resource "vault_auth_backend" "this" {
  type        = "gcp"
  path        = var.path
  description = var.description
}

resource "vault_generic_endpoint" "config" {
  count = length(var.config) > 0 ? 1 : 0

  path                 = "auth/${vault_auth_backend.this.path}/${var.config_endpoint}"
  data_json            = jsonencode(var.config)
  disable_delete       = var.disable_delete
  ignore_absent_fields = var.ignore_absent_fields
}

resource "vault_generic_endpoint" "role" {
  for_each = var.roles

  path                 = "auth/${vault_auth_backend.this.path}/role/${each.key}"
  data_json            = jsonencode(each.value)
  disable_delete       = var.disable_delete
  ignore_absent_fields = var.ignore_absent_fields
}

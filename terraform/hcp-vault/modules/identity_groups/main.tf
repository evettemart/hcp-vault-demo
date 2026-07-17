resource "vault_identity_group" "this" {
  for_each = var.groups

  namespace        = var.namespace
  name             = each.key
  type             = each.value.group_type
  policies         = try(each.value.policies, null)
  member_group_ids = try(each.value.member_group_ids, null)
}

resource "vault_identity_group_alias" "this" {
  for_each = {
    for group_name, group_config in var.groups : group_name => group_config
    if lower(group_config.group_type) == "external" &&
    try(group_config.alias_name, null) != null &&
    trimspace(try(group_config.alias_name, "")) != ""
  }

  namespace      = var.namespace
  name           = each.value.alias_name
  mount_accessor = lookup(var.group_oidc_accessors, each.key, var.oidc_accessor)
  canonical_id   = vault_identity_group.this[each.key].id
}

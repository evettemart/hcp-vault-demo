resource "vault_mount" "kv_v2" {
  path        = var.mount_path
  type        = "kv-v2"
  description = var.mount_description
}

resource "vault_kv_secret_backend_v2" "kv_v2" {
  mount                = vault_mount.kv_v2.path
  max_versions         = var.max_versions
  cas_required         = var.cas_required
  delete_version_after = var.delete_version_after
}

locals {
  member_bindings = flatten([
    for team_name, team_cfg in var.teams : [
      for member_name in team_cfg.members : {
        team        = team_name
        member      = member_name
        key         = "${team_name}/${member_name}"
        policy_name = regexreplace("${var.policy_name_prefix}-${team_name}-${member_name}", "[^a-zA-Z0-9_-]", "-")
      }
    ]
  ])

  member_bindings_by_key = {
    for b in local.member_bindings : b.key => b
  }
}

resource "vault_policy" "member" {
  for_each = local.member_bindings_by_key

  name = each.value.policy_name

  policy = <<-EOT
path "${var.mount_path}/data/${each.value.team}/${each.value.member}/*" {
  capabilities = ["create", "update", "patch", "read", "delete"]
}

path "${var.mount_path}/metadata/${each.value.team}/${each.value.member}" {
  capabilities = ["read", "list"]
}

path "${var.mount_path}/metadata/${each.value.team}/${each.value.member}/*" {
  capabilities = ["read", "list"]
}
EOT
}

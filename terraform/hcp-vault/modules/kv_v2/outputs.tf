output "mount_path" {
  description = "KV v2 mount path"
  value       = vault_mount.kv_v2.path
}

output "member_policy_names" {
  description = "Generated member policy names keyed by team/member"
  value = {
    for binding_key, binding in local.member_bindings_by_key :
    binding_key => vault_policy.member[binding_key].name
  }
}

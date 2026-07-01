locals {
  policy_root_path = abspath("${path.module}/../policies/${var.policy_folder}")

  namespace_policies = {
    # Nested policy paths are supported. The relative path (without .hcl)
    # becomes the Vault policy name, for example:
    # policies/namespace1/pcs/cloudaccount1/non-prod/kv-v2-test-writer.hcl
    # => policy name pcs/cloudaccount1/non-prod/kv-v2-test-writer
    for policy_file in fileset(local.policy_root_path, "**/*.hcl") :
    trimsuffix(policy_file, ".hcl") => file("${local.policy_root_path}/${policy_file}")
  }
}

module "kv_v2" {
  source = "../modules/kv_v2"
  for_each = var.kv_engines

  providers = {
    vault = vault.namespace
  }

  mount_path           = each.key
  mount_description    = each.value.mount_description
  max_versions         = each.value.max_versions
  cas_required         = each.value.cas_required
  delete_version_after = each.value.delete_version_after
  teams                = each.value.teams
}

module "ssh" {
  source = "../modules/ssh"
  for_each = var.ssh_engines

  providers = {
    vault = vault.namespace
  }

  mount_path           = each.key
  mount_description    = each.value.mount_description
  generate_signing_key = each.value.generate_signing_key
  roles                = each.value.roles
}

resource "vault_policy" "namespace" {
  provider = vault.namespace
  for_each = local.namespace_policies

  name   = each.key
  policy = each.value
}

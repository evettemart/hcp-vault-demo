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
  source   = "../modules/kv_v2"
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
  source   = "../modules/ssh"
  for_each = var.ssh_engines

  providers = {
    vault = vault.namespace
  }

  mount_path           = each.key
  mount_description    = each.value.mount_description
  generate_signing_key = each.value.generate_signing_key
  roles                = each.value.roles
}

module "aws_secrets" {
  source   = "../modules/aws_secrets"
  for_each = var.aws_secret_engines

  providers = {
    vault = vault.namespace
  }

  mount_path        = each.key
  mount_description = each.value.mount_description
  config_root       = each.value.config_root
  roles = {
    for role_name, role_cfg in each.value.roles :
    role_name => merge(
      {
        for key, value in role_cfg :
        key => value if key != "policy_document_file"
      },
      lookup(role_cfg, "policy_document_file", null) != null && trimspace(lookup(role_cfg, "policy_document_file", "")) != "" && lookup(role_cfg, "policy_document", null) == null ? {
        policy_document = file("${local.policy_root_path}/${lookup(role_cfg, "policy_document_file", "")}")
      } : {}
    )
  }
  disable_delete       = each.value.disable_delete
  ignore_absent_fields = each.value.ignore_absent_fields
}

module "database_secrets" {
  source   = "../modules/database_secrets"
  for_each = var.database_secret_engines

  providers = {
    vault = vault.namespace
  }

  mount_path           = each.key
  mount_description    = each.value.mount_description
  connections          = each.value.connections
  roles                = each.value.roles
  disable_delete       = each.value.disable_delete
  ignore_absent_fields = each.value.ignore_absent_fields
}

module "ldap_secrets" {
  source   = "../modules/ldap_secrets"
  for_each = var.ldap_secret_engines

  providers = {
    vault = vault.namespace
  }

  mount_path           = each.key
  mount_description    = each.value.mount_description
  config               = each.value.config
  roles                = each.value.roles
  disable_delete       = each.value.disable_delete
  ignore_absent_fields = each.value.ignore_absent_fields
}

module "kubernetes_secrets" {
  source   = "../modules/kubernetes_secrets"
  for_each = var.kubernetes_secret_engines

  providers = {
    vault = vault.namespace
  }

  mount_path           = each.key
  mount_description    = each.value.mount_description
  config               = each.value.config
  roles                = each.value.roles
  disable_delete       = each.value.disable_delete
  ignore_absent_fields = each.value.ignore_absent_fields
}

resource "vault_policy" "namespace" {
  provider = vault.namespace
  for_each = local.namespace_policies

  name   = each.key
  policy = each.value
}

locals {
  policies_root_path         = abspath("${path.module}/../policies")
  child_namespaces_effective = var.create_child_namespaces ? var.child_namespaces : []
  oidc_auth_methods_effective = length(var.oidc_auth_methods) > 0 ? var.oidc_auth_methods : (
    var.configure_oidc ? {
      (var.oidc_auth_path) = {
        description        = var.oidc_auth_description
        oidc_discovery_url = var.oidc_discovery_url
        oidc_client_id     = var.oidc_client_id
        oidc_client_secret = var.oidc_client_secret
        default_role       = var.oidc_default_role
        provider_config    = var.oidc_provider_config
        roles              = var.oidc_roles
      }
    } : {}
  )
  configure_oidc_effective         = length(local.oidc_auth_methods_effective) > 0
  configure_aws_auth_effective     = length(var.aws_auth_methods) > 0
  configure_azure_auth_effective   = length(var.azure_auth_methods) > 0
  configure_gcp_auth_effective     = length(var.gcp_auth_methods) > 0
  configure_approle_auth_effective = length(var.approle_auth_methods) > 0

  disabled_auth_types = toset(concat(
    local.configure_oidc_effective ? ["oidc"] : [],
    local.configure_aws_auth_effective ? ["aws"] : [],
    local.configure_azure_auth_effective ? ["azure"] : [],
    local.configure_gcp_auth_effective ? ["gcp"] : [],
    local.configure_approle_auth_effective ? ["approle"] : []
  ))

  auth_methods_effective = local.configure_oidc_effective ? {
    for mount_path, config in var.auth_methods :
    mount_path => config
    if !contains(local.disabled_auth_types, lower(config.type))
    } : {
    for mount_path, config in var.auth_methods :
    mount_path => config
    if !contains(local.disabled_auth_types, lower(config.type))
  }

  # Read policy definitions from ../policies/<admin-namespace>/*.hcl (aligned with
  # hashicorp-validated-designs/terraform-vault-policies pattern).
  standard_admin_policies = {
    for policy_file in fileset("${local.policies_root_path}/${var.admin_namespace}", "*.hcl") :
    trimsuffix(policy_file, ".hcl") => file("${local.policies_root_path}/${var.admin_namespace}/${policy_file}")
  }

  effective_policies = merge(
    var.create_standard_admin_policies ? local.standard_admin_policies : {},
    var.policies
  )

  admin_default_oidc_accessor = length(module.oidc_admin) == 1 ? one([
    for mount_path, mod in module.oidc_admin : mod.accessor
    ]) : (
    contains(keys(module.oidc_admin), "oidc") ? module.oidc_admin["oidc"].accessor : null
  )

  namespace_oidc_accessors = {
    for namespace_name, namespace_config in var.namespace_groups :
    namespace_name => (
      try(namespace_config.oidc_accessor, null) != null && trimspace(try(namespace_config.oidc_accessor, "")) != ""
      ? namespace_config.oidc_accessor
      : local.admin_default_oidc_accessor
    )
  }
}

module "oidc_admin" {
  source   = "../modules/oidc"
  for_each = local.oidc_auth_methods_effective

  providers = {
    vault = vault.admin
  }

  path               = each.key
  description        = try(each.value.description, "OIDC auth backend")
  oidc_discovery_url = each.value.oidc_discovery_url
  oidc_client_id     = each.value.oidc_client_id
  oidc_client_secret = each.value.oidc_client_secret
  default_role       = try(each.value.default_role, null)
  provider_config    = try(each.value.provider_config, {})
  roles              = try(each.value.roles, {})
}

module "aws_auth_admin" {
  source   = "../modules/aws_auth"
  for_each = var.aws_auth_methods

  providers = {
    vault = vault.admin
  }

  path                 = each.key
  description          = try(each.value.description, "AWS auth backend")
  config_endpoint      = try(each.value.config_endpoint, "config/client")
  config               = try(each.value.config, {})
  roles                = try(each.value.roles, {})
  disable_delete       = try(each.value.disable_delete, false)
  ignore_absent_fields = try(each.value.ignore_absent_fields, true)
}

module "azure_auth_admin" {
  source   = "../modules/azure_auth"
  for_each = var.azure_auth_methods

  providers = {
    vault = vault.admin
  }

  path                 = each.key
  description          = try(each.value.description, "Azure auth backend")
  config_endpoint      = try(each.value.config_endpoint, "config")
  config               = try(each.value.config, {})
  roles                = try(each.value.roles, {})
  disable_delete       = try(each.value.disable_delete, false)
  ignore_absent_fields = try(each.value.ignore_absent_fields, true)
}

module "gcp_auth_admin" {
  source   = "../modules/gcp_auth"
  for_each = var.gcp_auth_methods

  providers = {
    vault = vault.admin
  }

  path                 = each.key
  description          = try(each.value.description, "GCP auth backend")
  config_endpoint      = try(each.value.config_endpoint, "config")
  config               = try(each.value.config, {})
  roles                = try(each.value.roles, {})
  disable_delete       = try(each.value.disable_delete, false)
  ignore_absent_fields = try(each.value.ignore_absent_fields, true)
}

module "approle_auth_admin" {
  source   = "../modules/approle_auth"
  for_each = var.approle_auth_methods

  providers = {
    vault = vault.admin
  }

  path                 = each.key
  description          = try(each.value.description, "AppRole auth backend")
  config_endpoint      = try(each.value.config_endpoint, "config")
  config               = try(each.value.config, {})
  roles                = try(each.value.roles, {})
  disable_delete       = try(each.value.disable_delete, false)
  ignore_absent_fields = try(each.value.ignore_absent_fields, true)
}

resource "vault_namespace" "admin_children" {
  provider = vault.admin
  for_each = toset(local.child_namespaces_effective)

  path = each.value
}

resource "vault_auth_backend" "admin" {
  provider = vault.admin
  for_each = local.auth_methods_effective

  type        = each.value.type
  path        = each.key
  description = try(each.value.description, null)
  local       = try(each.value.local, false)
}

resource "vault_policy" "admin" {
  provider = vault.admin
  for_each = local.effective_policies

  name   = each.key
  policy = each.value
}

module "identity_groups" {
  source   = "../modules/identity_groups"
  for_each = var.namespace_groups

  providers = {
    vault = vault.admin
  }

  namespace     = each.key == var.admin_namespace ? null : each.key
  oidc_accessor = lookup(local.namespace_oidc_accessors, each.key, null)
  groups        = each.value.groups

  depends_on = [vault_namespace.admin_children]
}

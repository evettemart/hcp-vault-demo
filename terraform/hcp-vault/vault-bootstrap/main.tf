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
  configure_oidc_effective = length(local.oidc_auth_methods_effective) > 0
  auth_methods_effective = local.configure_oidc_effective ? {
    for mount_path, config in var.auth_methods :
    mount_path => config
    if lower(config.type) != "oidc"
  } : var.auth_methods

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

  admin_default_oidc_accessor = contains(keys(module.oidc_admin), "oidc") ? module.oidc_admin["oidc"].accessor : null

  namespace_oidc_accessors = merge(
    local.admin_default_oidc_accessor != null ? { (var.admin_namespace) = local.admin_default_oidc_accessor } : {},
    {
      for namespace_name, namespace_config in var.namespace_groups :
      namespace_name => namespace_config.oidc_accessor
      if try(namespace_config.oidc_accessor, null) != null && trimspace(try(namespace_config.oidc_accessor, "")) != ""
    }
  )
}

module "oidc_admin" {
  source = "../modules/oidc"
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

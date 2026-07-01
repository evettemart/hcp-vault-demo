resource "vault_jwt_auth_backend" "this" {
  type              = "oidc"
  path              = var.path
  description       = var.description
  oidc_discovery_url = var.oidc_discovery_url
  oidc_client_id    = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  default_role      = var.default_role
  provider_config   = var.provider_config
}

resource "vault_jwt_auth_backend_role" "this" {
  for_each = var.roles

  backend                  = vault_jwt_auth_backend.this.path
  role_name                = each.key
  role_type                = try(each.value.role_type, null)
  user_claim               = each.value.user_claim
  user_claim_json_pointer  = try(each.value.user_claim_json_pointer, null)
  allowed_redirect_uris    = try(each.value.allowed_redirect_uris, null)
  bound_audiences          = try(each.value.bound_audiences, null)
  bound_claims             = try(each.value.bound_claims, null)
  bound_claims_type        = try(each.value.bound_claims_type, null)
  groups_claim             = try(each.value.groups_claim, null)
  oidc_scopes              = try(each.value.oidc_scopes, null)
  claim_mappings           = try(each.value.claim_mappings, null)
  token_policies           = try(each.value.token_policies, null)
  verbose_oidc_logging     = try(each.value.verbose_oidc_logging, null)
}

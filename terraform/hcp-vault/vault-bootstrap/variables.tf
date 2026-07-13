variable "vault_addr" {
  description = "Vault API address, for example https://vault.example.com:8200"
  type        = string
}

variable "vault_token" {
  description = "Vault token with permissions to manage root/admin namespace resources"
  type        = string
  sensitive   = true
}

variable "admin_namespace" {
  description = "Admin namespace path in HCP Vault. This namespace is expected to already exist."
  type        = string
  default     = "admin"
}

variable "create_child_namespaces" {
  description = "Create child namespaces below the admin namespace"
  type        = bool
  default     = true
}

variable "child_namespaces" {
  description = "Child namespace names to create under the admin namespace"
  type        = set(string)
  default     = ["namespace1", "namespace2", "namespace3"]
}

variable "auth_methods" {
  description = "Auth methods to enable in the admin namespace keyed by mount path"
  type = map(object({
    type        = string
    description = optional(string)
    local       = optional(bool, false)
  }))
  default = {
    "oidc" = {
      type        = "oidc"
      description = "Admin OIDC auth"
    }
    "jwt" = {
      type        = "jwt"
      description = "Admin JWT auth"
    }
  }
}

variable "configure_oidc" {
  description = "Configure OIDC auth backend using the reusable OIDC module"
  type        = bool
  default     = false
}

variable "oidc_auth_methods" {
  description = "OIDC auth methods keyed by mount path to allow multiple OIDC backends per namespace"
  type = map(object({
    description        = optional(string, "OIDC auth backend")
    oidc_discovery_url = string
    oidc_client_id     = string
    oidc_client_secret = string
    default_role       = optional(string)
    provider_config    = optional(map(string), {})
    roles = optional(map(object({
      user_claim              = string
      role_type               = optional(string, "oidc")
      user_claim_json_pointer = optional(bool, false)
      allowed_redirect_uris   = optional(list(string), [])
      bound_audiences         = optional(list(string), [])
      bound_claims            = optional(map(string), {})
      bound_claims_type       = optional(string, "string")
      groups_claim            = optional(string)
      oidc_scopes             = optional(list(string), [])
      claim_mappings          = optional(map(string), {})
      token_policies          = optional(list(string), [])
      verbose_oidc_logging    = optional(bool, false)
    })), {})
  }))
  default = {}
}

variable "oidc_auth_path" {
  description = "Mount path for OIDC auth backend"
  type        = string
  default     = "oidc"
}

variable "oidc_auth_description" {
  description = "Description for OIDC auth backend"
  type        = string
  default     = "Admin OIDC auth"
}

variable "oidc_discovery_url" {
  description = "OIDC discovery URL used by the OIDC auth backend"
  type        = string
  default     = null

  validation {
    condition     = !(var.configure_oidc && length(var.oidc_auth_methods) == 0) || (var.oidc_discovery_url != null && trimspace(var.oidc_discovery_url) != "")
    error_message = "oidc_discovery_url must be set when configure_oidc is true and oidc_auth_methods is empty."
  }
}

variable "oidc_client_id" {
  description = "OIDC client ID used by the OIDC auth backend"
  type        = string
  default     = null

  validation {
    condition     = !(var.configure_oidc && length(var.oidc_auth_methods) == 0) || (var.oidc_client_id != null && trimspace(var.oidc_client_id) != "")
    error_message = "oidc_client_id must be set when configure_oidc is true and oidc_auth_methods is empty."
  }
}

variable "oidc_client_secret" {
  description = "OIDC client secret used by the OIDC auth backend"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = !(var.configure_oidc && length(var.oidc_auth_methods) == 0) || (var.oidc_client_secret != null && trimspace(var.oidc_client_secret) != "")
    error_message = "oidc_client_secret must be set when configure_oidc is true and oidc_auth_methods is empty."
  }
}

variable "oidc_default_role" {
  description = "Optional default OIDC role"
  type        = string
  default     = null
}

variable "oidc_provider_config" {
  description = "Provider-specific OIDC configuration"
  type        = map(string)
  default     = {}
}

variable "oidc_roles" {
  description = "OIDC/JWT auth roles keyed by role name"
  type = map(object({
    user_claim              = string
    role_type               = optional(string, "oidc")
    user_claim_json_pointer = optional(bool, false)
    allowed_redirect_uris   = optional(list(string), [])
    bound_audiences         = optional(list(string), [])
    bound_claims            = optional(map(string), {})
    bound_claims_type       = optional(string, "string")
    groups_claim            = optional(string)
    oidc_scopes             = optional(list(string), [])
    claim_mappings          = optional(map(string), {})
    token_policies          = optional(list(string), [])
    verbose_oidc_logging    = optional(bool, false)
  }))
  default = {}
}

variable "aws_auth_methods" {
  description = "AWS auth backends keyed by mount path to configure in the admin namespace"
  type = map(object({
    description          = optional(string, "AWS auth backend")
    config_endpoint      = optional(string, "config/client")
    config               = optional(map(any), {})
    roles                = optional(map(map(any)), {})
    disable_delete       = optional(bool, false)
    ignore_absent_fields = optional(bool, true)
  }))
  default = {}
}

variable "azure_auth_methods" {
  description = "Azure auth backends keyed by mount path to configure in the admin namespace"
  type = map(object({
    description          = optional(string, "Azure auth backend")
    config_endpoint      = optional(string, "config")
    config               = optional(map(any), {})
    roles                = optional(map(map(any)), {})
    disable_delete       = optional(bool, false)
    ignore_absent_fields = optional(bool, true)
  }))
  default = {}
}

variable "gcp_auth_methods" {
  description = "GCP auth backends keyed by mount path to configure in the admin namespace"
  type = map(object({
    description          = optional(string, "GCP auth backend")
    config_endpoint      = optional(string, "config")
    config               = optional(map(any), {})
    roles                = optional(map(map(any)), {})
    disable_delete       = optional(bool, false)
    ignore_absent_fields = optional(bool, true)
  }))
  default = {}
}

variable "approle_auth_methods" {
  description = "AppRole auth backends keyed by mount path to configure in the admin namespace"
  type = map(object({
    description          = optional(string, "AppRole auth backend")
    config_endpoint      = optional(string, "config")
    config               = optional(map(any), {})
    roles                = optional(map(map(any)), {})
    disable_delete       = optional(bool, false)
    ignore_absent_fields = optional(bool, true)
  }))
  default = {}
}

variable "namespace_groups" {
  description = "Namespace-specific identity group configuration keyed by namespace. Use the admin_namespace key (for example, admin) for admin groups, and child namespace keys (for example, namespace1) for namespaces under admin."
  type = map(object({
    oidc_accessor = optional(string)
    groups = map(object({
      group_type       = string
      policies         = optional(list(string), [])
      member_group_ids = optional(list(string), [])
      alias_name       = optional(string)
    }))
  }))
  default = {}
}

variable "policies" {
  description = "Additional or override policy documents keyed by policy name. Baseline policies are loaded from ../policies/<admin-namespace>/*.hcl"
  type        = map(string)
  default     = {}
}

variable "create_standard_admin_policies" {
  description = "Create baseline policies loaded from ../policies/<admin-namespace>/*.hcl (guided by hashicorp-validated-designs/terraform-vault-policies)"
  type        = bool
  default     = true
}

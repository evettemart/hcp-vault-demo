variable "path" {
  description = "Mount path for the OIDC auth backend"
  type        = string
  default     = "oidc"
}

variable "description" {
  description = "Description for the OIDC auth backend"
  type        = string
  default     = "OIDC auth backend"
}

variable "oidc_discovery_url" {
  description = "OIDC discovery URL"
  type        = string
  default     = null
}

variable "oidc_client_id" {
  description = "OIDC client ID"
  type        = string
  default     = null
}

variable "oidc_client_secret" {
  description = "OIDC client secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "default_role" {
  description = "Default role name for OIDC auth"
  type        = string
  default     = null
}

variable "provider_config" {
  description = "Provider-specific OIDC configuration"
  type        = map(string)
  default     = {}
}

variable "roles" {
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

variable "namespace" {
  description = "Vault namespace where groups are managed. Set to null to use the provider namespace as-is."
  type        = string
  nullable    = true
}

variable "oidc_accessor" {
  description = "Default OIDC auth mount accessor used for external group aliases when a per-group accessor is not provided"
  type        = string
  default     = null
}

variable "group_oidc_accessors" {
  description = "Optional per-group OIDC auth mount accessors keyed by group name. Overrides oidc_accessor for that group."
  type        = map(string)
  default     = {}
}

variable "groups" {
  description = "Identity groups keyed by group name"
  type = map(object({
    group_type       = string
    policies         = optional(list(string), [])
    member_group_ids = optional(list(string), [])
    alias_name       = optional(string)
    oidc_mount       = optional(string)
  }))
  default = {}
}

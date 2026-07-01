variable "namespace" {
  description = "Vault namespace where groups are managed"
  type        = string
}

variable "oidc_accessor" {
  description = "OIDC auth mount accessor used for external group aliases"
  type        = string
  default     = null
}

variable "groups" {
  description = "Identity groups keyed by group name"
  type = map(object({
    group_type       = string
    policies         = optional(list(string), [])
    member_group_ids = optional(list(string), [])
    alias_name       = optional(string)
  }))
  default = {}
}

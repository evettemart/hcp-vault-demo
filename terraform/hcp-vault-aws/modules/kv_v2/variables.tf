variable "mount_path" {
  description = "Mount path for the KV v2 secrets engine"
  type        = string
}

variable "mount_description" {
  description = "Description for the KV v2 mount"
  type        = string
  default     = "KV v2 secrets engine"
}

variable "max_versions" {
  description = "Maximum versions per secret (0 means Vault default)"
  type        = number
  default     = 20
}

variable "cas_required" {
  description = "Require check-and-set for writes"
  type        = bool
  default     = false
}

variable "delete_version_after" {
  description = "Seconds after which secret versions are deleted (0 disables)"
  type        = number
  default     = 0
}

variable "teams" {
  description = "Team/member mapping used to generate per-user least-privilege policies"
  type = map(object({
    members = set(string)
  }))
  default = {}
}

variable "policy_name_prefix" {
  description = "Prefix for generated Vault ACL policy names"
  type        = string
  default     = "kvv2"
}

variable "mount_path" {
  description = "Mount path for the SSH secrets engine"
  type        = string
  default     = "ssh-client-signer"
}

variable "mount_description" {
  description = "Description for the SSH mount"
  type        = string
  default     = "SSH client signer"
}

variable "generate_signing_key" {
  description = "Whether Vault should generate a new SSH signing key"
  type        = bool
  default     = true
}

variable "roles" {
  description = "SSH signing roles keyed by role name"
  type = map(object({
    key_type                = optional(string, "ca")
    allow_user_certificates = optional(bool, true)
    allowed_users           = string
    default_user            = optional(string)
    ttl                     = optional(string)
    algorithm_signer        = optional(string)
    allowed_extensions      = optional(string)
    default_extensions      = optional(map(string), {})
  }))
  default = {}
}

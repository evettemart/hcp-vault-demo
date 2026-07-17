variable "namespace" {
  description = "Vault namespace where the LDAP secrets engine is managed"
  type        = string
  default     = null
}

variable "mount_path" {
  description = "Mount path for the LDAP secrets engine"
  type        = string
}

variable "mount_description" {
  description = "Description for the LDAP secrets engine mount"
  type        = string
  default     = "LDAP secrets engine"
}

variable "config" {
  description = "LDAP engine config payload written to <mount>/config"
  type        = map(any)
  default     = {}
}

variable "roles" {
  description = "LDAP static roles keyed by role name written to <mount>/role/<name>"
  type        = any
  default     = {}
}

variable "disable_delete" {
  description = "Disable delete on generic endpoints"
  type        = bool
  default     = false
}

variable "ignore_absent_fields" {
  description = "Ignore fields missing from Vault responses on generic endpoints"
  type        = bool
  default     = true
}

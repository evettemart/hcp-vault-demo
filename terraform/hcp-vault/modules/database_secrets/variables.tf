variable "namespace" {
  description = "Vault namespace where the Database secrets engine is managed"
  type        = string
  default     = null
}

variable "mount_path" {
  description = "Mount path for the Database secrets engine"
  type        = string
}

variable "mount_description" {
  description = "Description for the Database secrets engine mount"
  type        = string
  default     = "Database secrets engine"
}

variable "connections" {
  description = "Database connection definitions keyed by connection name written to <mount>/config/<name>"
  type        = any
  default     = {}
}

variable "roles" {
  description = "Database roles keyed by role name written to <mount>/roles/<name>"
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

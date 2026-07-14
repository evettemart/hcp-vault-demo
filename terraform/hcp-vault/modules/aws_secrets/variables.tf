variable "namespace" {
  description = "Vault namespace where the AWS secrets engine is managed"
  type        = string
  default     = null
}

variable "mount_path" {
  description = "Mount path for the AWS secrets engine"
  type        = string
}

variable "mount_description" {
  description = "Description for the AWS secrets engine mount"
  type        = string
  default     = "AWS secrets engine"
}

variable "config_root" {
  description = "AWS root config payload written to <mount>/config/root"
  type        = map(any)
  default     = {}
}

variable "roles" {
  description = "AWS secrets engine roles keyed by role name written to <mount>/roles/<name>"
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

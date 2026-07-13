variable "path" {
  description = "Mount path for the AppRole auth backend"
  type        = string
  default     = "approle"
}

variable "description" {
  description = "Description for the AppRole auth backend"
  type        = string
  default     = "AppRole auth backend"
}

variable "config_endpoint" {
  description = "Relative config endpoint under auth/<path>/ used for backend configuration"
  type        = string
  default     = "config"
}

variable "config" {
  description = "AppRole auth backend config payload written to auth/<path>/<config_endpoint>"
  type        = map(any)
  default     = {}
}

variable "roles" {
  description = "AppRole roles keyed by role name. Each value is written to auth/<path>/role/<name>"
  type        = map(map(any))
  default     = {}
}

variable "disable_delete" {
  description = "Disable delete on generic endpoints to avoid removing auth config/roles"
  type        = bool
  default     = false
}

variable "ignore_absent_fields" {
  description = "Ignore fields missing from Vault responses on generic endpoints"
  type        = bool
  default     = true
}

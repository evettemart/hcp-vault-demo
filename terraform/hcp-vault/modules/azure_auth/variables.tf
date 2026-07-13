variable "path" {
  description = "Mount path for the Azure auth backend"
  type        = string
  default     = "azure"
}

variable "description" {
  description = "Description for the Azure auth backend"
  type        = string
  default     = "Azure auth backend"
}

variable "config_endpoint" {
  description = "Relative config endpoint under auth/<path>/ used for backend configuration"
  type        = string
  default     = "config"
}

variable "config" {
  description = "Azure auth backend config payload written to auth/<path>/<config_endpoint>"
  type        = map(any)
  default     = {}
}

variable "roles" {
  description = "Azure auth roles keyed by role name. Each value is written to auth/<path>/role/<name>"
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

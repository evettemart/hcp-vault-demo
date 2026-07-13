variable "path" {
  description = "Mount path for the AWS auth backend"
  type        = string
  default     = "aws"
}

variable "description" {
  description = "Description for the AWS auth backend"
  type        = string
  default     = "AWS auth backend"
}

variable "config_endpoint" {
  description = "Relative config endpoint under auth/<path>/ used for backend client configuration"
  type        = string
  default     = "config/client"
}

variable "config" {
  description = "AWS auth backend config payload written to auth/<path>/<config_endpoint>"
  type        = map(any)
  default     = {}
}

variable "roles" {
  description = "AWS auth roles keyed by role name. Each value is written to auth/<path>/role/<name>"
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

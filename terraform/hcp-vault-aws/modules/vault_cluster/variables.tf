variable "cluster_id" {
  description = "Vault cluster ID"
  type        = string
}

variable "hvn_id" {
  description = "HVN ID for this cluster"
  type        = string
}

variable "tier" {
  description = "Vault cluster tier"
  type        = string
}

variable "project_id" {
  description = "HCP project ID"
  type        = string
}

variable "public_endpoint" {
  description = "Enable public endpoint"
  type        = bool
}

variable "proxy_endpoint" {
  description = "Proxy endpoint mode"
  type        = string
}

variable "min_vault_version" {
  description = "Optional minimum Vault version"
  type        = string
  default     = null
}

variable "primary_link" {
  description = "Optional self link of primary cluster"
  type        = string
  default     = null
}

variable "ip_allowlist" {
  description = "IP allowlist entries"
  type = list(object({
    address     = string
    description = optional(string)
  }))
  default = []
}

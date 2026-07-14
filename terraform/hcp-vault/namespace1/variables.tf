variable "vault_addr" {
  description = "Vault API address, for example https://vault.example.com:8200"
  type        = string
}

variable "vault_token" {
  description = "Vault token with permissions to manage resources in namespace1"
  type        = string
  sensitive   = true
}

variable "namespace" {
  description = "Target Vault namespace path (for child namespaces under admin, use admin/<child>)"
  type        = string
  default     = "admin/namespace1"
}

variable "policy_folder" {
  description = "Relative folder name under ../policies that contains HCL policy files to apply. Nested folders are supported and map to policy names."
  type        = string
  default     = "namespace1"
}

variable "kv_engines" {
  description = "KV v2 engines keyed by mount path following <namespace-team>/<cloud-account>/<environment>/<name>"
  type = map(object({
    mount_description    = optional(string, "KV v2 secrets engine")
    max_versions         = optional(number, 20)
    cas_required         = optional(bool, false)
    delete_version_after = optional(number, 0)
    teams = optional(map(object({
      members = set(string)
    })), {})
  }))
  default = {}
}

variable "ssh_engines" {
  description = "SSH secrets engines keyed by mount path following <namespace-team>/<cloud-account>/<environment>/<name>"
  type = map(object({
    mount_description    = optional(string, "SSH client signer")
    generate_signing_key = optional(bool, true)
    roles = optional(map(object({
      key_type                = optional(string, "ca")
      allow_user_certificates = optional(bool, true)
      allowed_users           = string
      default_user            = optional(string)
      ttl                     = optional(string)
      algorithm_signer        = optional(string)
      allowed_extensions      = optional(string)
      default_extensions      = optional(map(string), {})
    })), {})
  }))
  default = {}
}

variable "aws_secret_engines" {
  description = "AWS secrets engines keyed by mount path following <namespace-team>/<cloud-account>/<environment>/<name>"
  type = map(object({
    mount_description    = optional(string, "AWS secrets engine")
    config_root          = optional(map(any), {})
    roles                = optional(any, {})
    disable_delete       = optional(bool, false)
    ignore_absent_fields = optional(bool, true)
  }))
  default = {}
}

variable "database_secret_engines" {
  description = "Database secrets engines keyed by mount path following <namespace-team>/<cloud-account>/<environment>/<name>"
  type = map(object({
    mount_description    = optional(string, "Database secrets engine")
    connections          = optional(any, {})
    roles                = optional(any, {})
    disable_delete       = optional(bool, false)
    ignore_absent_fields = optional(bool, true)
  }))
  default = {}
}

variable "ldap_secret_engines" {
  description = "LDAP secrets engines keyed by mount path following <namespace-team>/<cloud-account>/<environment>/<name>"
  type = map(object({
    mount_description    = optional(string, "LDAP secrets engine")
    config               = optional(map(any), {})
    roles                = optional(any, {})
    disable_delete       = optional(bool, false)
    ignore_absent_fields = optional(bool, true)
  }))
  default = {}
}

variable "kubernetes_secret_engines" {
  description = "Kubernetes secrets engines keyed by mount path following <namespace-team>/<cloud-account>/<environment>/<name>"
  type = map(object({
    mount_description    = optional(string, "Kubernetes secrets engine")
    config               = optional(map(any), {})
    roles                = optional(any, {})
    disable_delete       = optional(bool, false)
    ignore_absent_fields = optional(bool, true)
  }))
  default = {}
}

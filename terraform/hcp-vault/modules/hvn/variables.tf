variable "hvn_id" {
  description = "HVN ID"
  type        = string
}

variable "cloud_provider" {
  description = "Cloud provider for HVN"
  type        = string
}

variable "region" {
  description = "HCP region"
  type        = string
}

variable "cidr_block" {
  description = "HVN CIDR block"
  type        = string
}

variable "project_id" {
  description = "HCP project ID"
  type        = string
}

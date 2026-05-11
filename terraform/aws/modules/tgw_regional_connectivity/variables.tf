variable "name_prefix" {
  description = "Prefix used for resource names"
  type        = string
}

variable "region_short" {
  description = "Short region token used in names, for example r1"
  type        = string
}

variable "region_group" {
  description = "Region group tag value"
  type        = string
}

variable "region_label" {
  description = "Human-readable region label used in description, for example Region 1"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach to transit gateway"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs used by transit gateway VPC attachment"
  type        = list(string)
}

variable "hcp_provider_account_id" {
  description = "Optional HCP provider AWS account ID used for RAM principal association"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to resources"
  type        = map(string)
}
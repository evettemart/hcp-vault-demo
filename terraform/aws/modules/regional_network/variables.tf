variable "name_prefix" {
  description = "Prefix used for resource naming"
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

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
}

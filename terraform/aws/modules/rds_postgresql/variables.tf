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

variable "vpc_id" {
  description = "VPC ID that hosts the RDS resources"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for DB subnet group"
  type        = list(string)
}

variable "allowed_cidrs" {
  description = "CIDRs allowed to connect to the DB port"
  type        = list(string)
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage autoscaling limit in GiB"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

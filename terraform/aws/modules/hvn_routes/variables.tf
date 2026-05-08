variable "enabled" {
  description = "Whether to create routes"
  type        = bool
}

variable "public_route_table_id" {
  description = "Public route table ID"
  type        = string
}

variable "private_route_table_id" {
  description = "Private route table ID"
  type        = string
}

variable "destination_cidr_block" {
  description = "Destination CIDR to route to HVN"
  type        = string
}

variable "peering_connection_id" {
  description = "VPC peering connection ID"
  type        = string
  default     = null
}

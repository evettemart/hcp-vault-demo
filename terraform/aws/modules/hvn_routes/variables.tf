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

variable "transit_gateway_id" {
  description = "Transit Gateway ID"
  type        = string
  default     = null
}

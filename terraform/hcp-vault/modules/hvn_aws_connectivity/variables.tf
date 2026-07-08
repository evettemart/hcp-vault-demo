variable "hvn_id" {
  description = "HVN ID"
  type        = string
}

variable "hvn_link" {
  description = "HVN self link"
  type        = string
}

variable "transit_gateway_attachment_id" {
  description = "HCP transit gateway attachment ID"
  type        = string
}

variable "transit_gateway_id" {
  description = "AWS Transit Gateway ID"
  type        = string
}

variable "resource_share_arn" {
  description = "AWS RAM resource share ARN for the transit gateway"
  type        = string
}

variable "hvn_route_id" {
  description = "HCP HVN route ID"
  type        = string
}

variable "destination_cidr" {
  description = "Destination CIDR for HVN route"
  type        = string
}

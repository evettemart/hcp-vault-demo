variable "hvn_id" {
  description = "HVN ID"
  type        = string
}

variable "hvn_link" {
  description = "HVN self link"
  type        = string
}

variable "peering_id" {
  description = "HCP peering ID"
  type        = string
}

variable "peer_vpc_id" {
  description = "AWS VPC ID to peer with"
  type        = string
}

variable "peer_account_id" {
  description = "AWS account ID owning peer VPC"
  type        = string
}

variable "peer_vpc_region" {
  description = "AWS region of peer VPC"
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

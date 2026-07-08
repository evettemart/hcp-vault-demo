variable "hvn_link" {
  description = "HVN self link"
  type        = string
}

variable "peering_id" {
  description = "HCP Azure peering connection ID"
  type        = string
}

variable "peer_vnet_name" {
  description = "Azure peer VNet name"
  type        = string
}

variable "peer_subscription_id" {
  description = "Azure subscription ID containing peer VNet"
  type        = string
}

variable "peer_tenant_id" {
  description = "Azure tenant ID containing peer VNet"
  type        = string
}

variable "peer_resource_group_name" {
  description = "Azure resource group name containing peer VNet"
  type        = string
}

variable "peer_vnet_region" {
  description = "Azure region for peer VNet"
  type        = string
}

variable "allow_forwarded_traffic" {
  description = "Allow forwarded traffic from Azure peer VNet"
  type        = bool
  default     = true
}

variable "use_remote_gateways" {
  description = "Allow HVN to use remote gateways from Azure peer VNet"
  type        = bool
  default     = false
}

variable "hvn_route_id" {
  description = "HCP HVN route ID"
  type        = string
}

variable "destination_cidr" {
  description = "Destination CIDR for HVN route toward Azure NVA/VNet"
  type        = string
}

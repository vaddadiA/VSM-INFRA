variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_name" {
  description = "Vnet name"
  type        = string
}

variable "vnet_address_space" {
  description = "vnet address space"
  type        = list(string)
  default     = null
}

variable "location" {
  description = "location for the resources"
  type        = string
}

variable "dns_resolver_forwarding_ruleset_id" {
  description = "ID of the Private DNS Resolver DNS Forwarding Ruleset"
  type        = string
}

variable "prefix" {
  description = "Name prefix to be used in azurecaf plugin"
  type        = string
}

variable "hub_network_id" {
  description = "Id of hub network"
  type        = string
}

variable "hub_network_rg" {
  description = "resource group name of hub vnet"
  type        = string
}

variable "hub_network_name" {
  description = "name of the hub vnet"
  type        = string
}

variable "vnet_subnets" {
  description = "Map containing vnet subnets config"
  type = map(object({
    address_prefixes                              = list(string)
    service_endpoints                             = list(string)
    private_endpoint_network_policies_enabled     = bool
    private_link_service_network_policies_enabled = bool
    })
  )
  default = {
    "subnet_name_1" = {
      address_prefixes                              = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
      service_endpoints                             = []
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    }
  }
}

variable "application_security_groups" {
  description = "Variables for application security groups."
  type = map(any)
}

variable "network_security_groups" {
  description = "Variables for the network security group"
  type = object({
    name = string
    rules = list(object({
      name                    = string
      description             = optional(string)
      protocol                = string
      sourcePortRange         = optional(string)
      sourcePortRanges        = optional(list(string))
      destinationPortRange    = optional(string)
      destinationPortRanges   = optional(list(string))
      sourceAddressPrefix     = optional(string)
      sourceAddressPrefixes   = optional(list(string))
      sourceApplicationSecurityGroupNames = optional(list(string))
      destinationAddressPrefix = optional(string)
      destinationAddressPrefixes = optional(list(string))
      destinationApplicationSecurityGroupNames = optional(list(string))
      access                  = string
      priority                = number
      direction               = string
    }))
  })
}

variable "subnet_nsg_associations" {
  description = "Subnets Network security group association"
  type = map(any)
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}

variable "vnet_to_hub_route_name" {
  description = "The name of the route to be created in the Hub Network Route Table."
  type        = string
}

variable "hub_network_route_table_name" {
  description = "The name of the HUb Network Route Table."
  type        = string
}

variable "hub_route_next_hop_type" {
  description = "The type of Azure hop the packet should be sent to."
  type        = string
  default     = "VirtualAppliance"
}

variable "hub_route_next_hop_in_ip_address" {
  description = "Contains the IP address packets should be forwarded to."
  type        = string
  default     = ""
}

variable "teamconvergence_local_subnet_names" {
  description = "Local subnet names for teamconvergence peering"
  type        = list(string)
  default     = []
}

variable "teamconvergence_remote_subnet_names" {
  description = "Remote subnet names for teamconvergence peering"
  type        = list(string)
  default     = []
}

variable "tvp_local_subnet_names" {
  description = "Local subnet names for tvp peering"
  type        = list(string)
  default     = []
}

variable "tvp_remote_subnet_names" {
  description = "Remote subnet names for tvp peering"
  type        = list(string)
  default     = []
}

variable "teamconvergence_vnet_rg" {
  description = "Resource group name for the TeamConvergence virtual network"
  type        = string
}

variable "teamconvergence_vnet_id" {
  description = "The ID of the TeamConvergence virtual network to peer with."
  type        = string
}

variable "teamconvergence_vnet_name" {
  description = "The name of the TeamConvergence virtual network to peer with."
  type        = string
}

variable "tvp_vnet_id" {
  description = "The resource ID of the TVP virtual network to peer with."
  type        = string
}

variable "tvp_vnet_rg" {
  description = "The resource group name of the TVP virtual network."
  type        = string
}

variable "tvp_vnet_name" {
  description = "The name of the TVP virtual network to peer with."
  type        = string
}
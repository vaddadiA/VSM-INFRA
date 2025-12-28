variable "y" {
  type        = string
  description = "The Y value for IP address calculations."
}

variable "resource_group_name" {
  description = "resource group name"
  type        = string
}

variable "tags" {
  type        = map(any)
  description = "list of tags used for this landing zone"
}

variable "location" {
  type        = string
  description = "The region used to target the landing zone."
}

variable "prefix" {
  type        = string
  description = "The prefix used for resource naming in the landing zone."
}

variable "environment" {
  type        = string
  description = "The environment used to target the landing zone (e.g., dev, prod)."
}

variable "environment_number" {
  type        = string
  description = "The environment number for IP address calculations."
}

variable "hub_network_id" {
  description = "Hub network id"
  type        = string
}

variable "hub_network_rg" {
  description = "Hub network resource group"
  type        = string
}

variable "dns_network_rg" {
  description = "Hub network resource group"
  type        = string
}

variable "hub_network_name" {
  description = "Hub network name"
  type        = string
}

variable "hub_firewall_name" {
  description = "Hub network firewall name"
  type        = string
}

variable "hub_subscription_id" {
  description = "Subscription ID for the hub provider"
  type        = string
}

variable "vnet_name" {
  description = "name of the vnet"
  type        = string
}

variable "dns_resolver_forwarding_ruleset_id" {
  description = "ID of the Private DNS Resolver DNS Forwarding Ruleset"
  type        = string
}

variable "vnet_address_space" {
  description = "VNET address space"
  type        = list(string)
}

variable "vnet_subnets" {
  description = "VNET subnets"
  type        = map(any)
}

variable "hub_private_dns_zone_name" {
  description = "HUB Private dnszone name"
  type        = string
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

variable "subnet_nsg_associations" {
  type        = map(any)
  description = "Values for associating nsg to subnet. Defaults to associating shared subnet to nsg-shared"
  default = {
    nsg-shared-association = {
      subnet_name = "Shared"
      nsg_name    = "nsg-Shared"
    }
  }
}
variable "application_security_groups" {
  description = "Application security groups"
  type = map(any)
}

variable "network_security_groups" {
  description = "Object for the NSG"
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
  default = {
    name = "nsg-Shared"
    rules = [
      {
        priority                 = 301
        name                     = "Allow_rdp_from_vnet_teamconvergence"
        destinationPortRange     = "3389"
        protocol                 = "Tcp"
        sourcePortRange          = "*"
        sourceAddressPrefix      = "10.100.65.0/24"
        destinationAddressPrefix = "192.${var.y}.${var.environment_number}.0/24"
        access                   = "Allow"
        direction                = "Inbound"
      },
      {
        priority                 = 302
        name                     = "Allow_ssh_from_vnet_teamconvergence"
        destinationPortRange     = "22"
        protocol                 = "Tcp"
        sourcePortRange          = "*"
        sourceAddressPrefix      = "10.100.65.0/24"
        destinationAddressPrefix = "192.${var.y}.${var.environment_number}.0/24"
        access                   = "Allow"
        direction                = "Inbound"
      },
      {
        priority                 = 400
        name                     = "Allow_traffic_from_tvpvnet"
        destinationPortRanges    = ["8380", "8480", "5999", "6999"]
        protocol                 = "Tcp"
        sourcePortRange          = "*"
        sourceAddressPrefix      = "10.100.66.128/26"
        destinationAddressPrefix = "192.168.${var.environment_number}.0/24"
        access                   = "Allow"
        direction                = "Inbound"
      },
      {
        priority                 = 401
        name                     = "Allow_inbound_ssh"
        destinationPortRange     = "22"
        protocol                 = "Tcp"
        sourcePortRange          = "*"
        sourceAddressPrefix      = "*"
        destinationAddressPrefix = "*"
        access                   = "Allow"
        direction                = "Inbound"
      },
      {
        priority                 = 1111
        name                     = "deny-outbound-all"
        destinationPortRange     = "*"
        protocol                 = "*"
        sourcePortRange          = "*"
        sourceAddressPrefix      = "*"
        destinationAddressPrefix = "*"
        access                   = "Deny"
        direction                = "Outbound"
      }
    ]
  }
}

variable "vnet_spoke_peerings" {
  description = "Vnet spoke peerings"
  type    = map(any)
  default = {}
}

variable "delegated_subnets" {
  description = "Map of values for delagated subnets"
  type        = map(any)
  default     = {}
}

variable "tvp_vnet_name" {
  description = "Name of the TVP VNet"
  type        = string
}
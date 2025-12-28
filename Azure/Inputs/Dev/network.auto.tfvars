# terraform

# Basic configuration
y = "168"
resource_group_name = "rg-dev-vsm"
tags = {
  Environment = "dev"
  Project     = "vsm"
}
location = "West Europe"
prefix   = "vsm"
environment = "dev"
environment_number = "1"

# Hub details
hub_network_id = "/subscriptions/4907c122-2bda-4f73-b2b6-e1e3e9d8a71a/resourceGroups/rg-hub/providers/Microsoft.Network/virtualNetworks/vnet-hub"
hub_network_rg = "rg-hub"
dns_network_rg = "rg-hub"
hub_network_name = "vnet-hub"
hub_firewall_name = "fw-hub"
hub_subscription_id = "4907c122-2bda-4f73-b2b6-e1e3e9d8a71a"

# VNet configuration
vnet_name = "vnet-spoke"
dns_resolver_forwarding_ruleset_id = "/subscriptions/4907c122-2bda-4f73-b2b6-e1e3e9d8a71a/resourceGroups/rg-hub/providers/Microsoft.Network/dnsForwardingRulesets/dns-ruleset"
vnet_address_space = ["192.168.10.0/24", "192.166.10.0/24"]

# Subnets (hardcoded in code, so empty)
vnet_subnets = {}

# Application Security Groups
application_security_groups = {}

# Route tables and associations (placeholders, since removed)
route_tables = {}
subnet_route_table_associations = {}

# VNet peerings
vnet_spoke_peerings = {}

# Delegated subnets
delegated_subnets = {}

# Network Security Groups (updated structure)
network_security_groups = {
  nsg-spoke = {
    security_rules = [
      {
        name                       = "Allow-SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTP"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTPS"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Deny-All-Inbound"
        priority                   = 4095
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Deny-All-Outbound"
        priority                   = 4096
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}
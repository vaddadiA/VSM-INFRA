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

# Subnets (hardcoded to two as per code)
vnet_subnets = {}

# Application Security Groups
application_security_groups = {}
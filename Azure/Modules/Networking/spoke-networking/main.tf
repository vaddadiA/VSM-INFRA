# Hook up the hub vnet as a data source because we want to reuse the dns server ip addresses. If that feature is dropped out then this data source is useless.
data "azurerm_virtual_network" "hub" {
  provider            = azurerm.hub
  name                = var.hub_network_name
  resource_group_name = var.hub_network_rg
}

resource "azurerm_virtual_network" "vnet_1" {
  #checkov:skip=CKV_AZURE_183:Need to check

  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  location            = var.location
  dns_servers         = data.azurerm_virtual_network.hub.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "subnet_management" {
  name                                          = "subnet-management"
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet_1.name
  address_prefixes                              = ["192.168.10.0/25"]  # Updated to fit within vnet_address_space
  service_endpoints                             = []
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet" "subnet_proj" {
  name                                          = "subnet-proj"
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet_1.name
  address_prefixes                              = ["192.168.10.128/25"]  # Updated to fit within vnet_address_space
  service_endpoints                             = []
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = true
}

resource "azurerm_application_security_group" "asg" {
  for_each = var.application_security_groups

  location            = var.location
  name                = each.value.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

## Network security groups
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_groups.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = var.network_security_groups.rules

    content {
      name                    = security_rule.value.name
      description             = lookup(security_rule.value, "description", null)
      protocol                = lookup(security_rule.value, "protocol", "*")
      source_port_range       = lookup(security_rule.value, "sourcePortRange", null)
      source_port_ranges      = (lookup(security_rule.value, "sourcePortRanges", null) != null ? split(",", security_rule.value.sourcePortRanges) : null)
      destination_port_range  = lookup(security_rule.value, "destinationPortRange", null)
      destination_port_ranges = (lookup(security_rule.value, "destinationPortRanges", null) != null ? split(",", security_rule.value.destinationPortRanges) : null)
      source_address_prefix   = lookup(security_rule.value, "sourceAddressPrefix", null)
      source_address_prefixes = (lookup(security_rule.value, "sourceAddressPrefixes", null) != null ? split(",", security_rule.value.sourceAddressPrefixes) : null)
      source_application_security_group_ids = lookup(security_rule.value, "sourceApplicationSecurityGroupName", null) != null ? try([azurerm_application_security_group.asg[lookup(security_rule.value, "sourceApplicationSecurityGroupName", null)].id], []) : []
      destination_address_prefix   = lookup(security_rule.value, "destinationAddressPrefix", null)
      destination_address_prefixes = (lookup(security_rule.value, "destinationAddressPrefixes", null) != null ? split(",", security_rule.value.destinationAddressPrefixes) : null)
      destination_application_security_group_ids = lookup(security_rule.value, "destinationApplicationSecurityGroupName", null) != null ? try([azurerm_application_security_group.asg[lookup(security_rule.value, "destinationApplicationSecurityGroupName", null)].id], []) : []
      access    = security_rule.value.access
      priority  = security_rule.value.priority
      direction = security_rule.value.direction
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_management" {
  subnet_id                 = azurerm_subnet.subnet_management.id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [
    azurerm_virtual_network.vnet_1,
    azurerm_subnet.subnet_management
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_proj" {
  subnet_id                 = azurerm_subnet.subnet_proj.id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [
    azurerm_virtual_network.vnet_1,
    azurerm_subnet.subnet_proj
  ]
}

#
# Peering
#
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peering-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet_1.name
  remote_virtual_network_id = var.hub_network_id
  use_remote_gateways       = true
  allow_forwarded_traffic   = true

  depends_on = [azurerm_virtual_network.vnet_1, azurerm_subnet.subnet_management, azurerm_subnet.subnet_proj, azurerm_network_security_group.nsg]
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                  = azurerm.hub
  name                      = "peering-to-spoke-${azurerm_virtual_network.vnet_1.name}"
  resource_group_name       = var.hub_network_rg
  virtual_network_name      = var.hub_network_name
  remote_virtual_network_id = azurerm_virtual_network.vnet_1.id
  allow_gateway_transit     = true
  depends_on = [azurerm_virtual_network.vnet_1, azurerm_subnet.subnet_management, azurerm_subnet.subnet_proj, azurerm_network_security_group.nsg]
}

resource "azurerm_virtual_network_peering" "vsm_to_teamconvergence" {
  name                                   = "peer_${azurerm_virtual_network.vnet_1.name}_to_teamconvergence"
  resource_group_name                    = var.resource_group_name
  virtual_network_name                   = azurerm_virtual_network.vnet_1.name
  remote_virtual_network_id              = var.teamconvergence_vnet_id
  use_remote_gateways                    = false
  allow_forwarded_traffic                = false
  allow_gateway_transit                  = false
  allow_virtual_network_access           = false
  peer_complete_virtual_networks_enabled = false
  local_subnet_names                     = var.teamconvergence_local_subnet_names
  remote_subnet_names                    = var.teamconvergence_remote_subnet_names
  depends_on = [azurerm_virtual_network.vnet_1, azurerm_subnet.subnet_management, azurerm_subnet.subnet_proj, azurerm_network_security_group.nsg]
}

resource "azurerm_virtual_network_peering" "teamconvergence_to_vsm" {
  provider                               = azurerm.hub
  name                                   = "peer_teamconvergence_to_${azurerm_virtual_network.vnet_1.name}"
  resource_group_name                    = var.teamconvergence_vnet_rg
  virtual_network_name                   = var.teamconvergence_vnet_name
  remote_virtual_network_id              = azurerm_virtual_network.vnet_1.id
  allow_forwarded_traffic                = false
  allow_gateway_transit                  = false
  allow_virtual_network_access           = false
  peer_complete_virtual_networks_enabled = false
  local_subnet_names                     = var.teamconvergence_remote_subnet_names
  remote_subnet_names                    = var.teamconvergence_local_subnet_names
  depends_on = [azurerm_virtual_network.vnet_1, azurerm_subnet.subnet_management, azurerm_subnet.subnet_proj, azurerm_network_security_group.nsg]
}

#only if tvp resources are already created
resource "azurerm_virtual_network_peering" "vsm_to_tvp" {
  name                      = "peering-to-tvp1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet_1.name
  remote_virtual_network_id = var.tvp_vnet_id
  allow_forwarded_traffic                = false
  allow_gateway_transit                  = false
  allow_virtual_network_access           = false
  peer_complete_virtual_networks_enabled = false
  local_subnet_names                     = var.tvp_local_subnet_names
  remote_subnet_names                    = var.tvp_remote_subnet_names
  depends_on = [azurerm_virtual_network.vnet_1, azurerm_subnet.subnet_management, azurerm_subnet.subnet_proj, azurerm_network_security_group.nsg]
}

resource "azurerm_virtual_network_peering" "tvp_to_vsm" {
  provider                  = azurerm.hub
  name                      = "peering-to-spoke-${azurerm_virtual_network.vnet_1.name}"
  resource_group_name       = var.tvp_vnet_rg
  virtual_network_name      = var.tvp_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet_1.id
  allow_forwarded_traffic                = false
  allow_gateway_transit                  = false
  allow_virtual_network_access           = false
  peer_complete_virtual_networks_enabled = false
  local_subnet_names                     = var.tvp_remote_subnet_names
  remote_subnet_names                    = var.tvp_local_subnet_names
  depends_on = [azurerm_virtual_network.vnet_1, azurerm_subnet.subnet_management, azurerm_subnet.subnet_proj, azurerm_network_security_group.nsg]
}
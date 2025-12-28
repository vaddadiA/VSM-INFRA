# Spoke networking module
module "vnets" {
  source = "../../modules/networking/spoke-networking"

  location                           = var.location
  resource_group_name                = var.resource_group_name
  prefix                             = var.prefix

  hub_network_id                     = var.hub_network_id
  hub_network_rg                     = var.hub_network_rg
  hub_network_name                   = var.hub_network_name

  dns_resolver_forwarding_ruleset_id = var.dns_resolver_forwarding_ruleset_id
  vnet_name                          = var.vnet_name
  vnet_address_space                 = var.vnet_address_space
  vnet_subnets                       = var.vnet_subnets

  network_security_groups            = var.network_security_groups
  application_security_groups        = var.application_security_groups
  subnet_nsg_associations            = var.subnet_nsg_associations
  
  tags = local.tags
}


# delegated subnets
module "delegated_subnets" {
  source = "../../modules/networking/delegated-subnet"

  for_each = var.delegated_subnets

  resource_group_name = var.resource_group_name
  nsg_groups = module.vnets.nsg_ids
  delegated_subnets = var.delegated_subnets[each.key]
  depends_on        = [module.vnets]
}

# peering to other networks
module "vnet_spoke_peerings" {
  source = "../../modules/networking/network-peering"

  for_each = var.vnet_spoke_peerings
  vnet_name = var.vnet_name
  vnet_spoke_peerings = var.vnet_spoke_peerings[each.key]
  resource_group_name = var.resource_group_name
  depends_on        = [module.vnets]
}
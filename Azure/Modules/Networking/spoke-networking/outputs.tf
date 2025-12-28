output "vnet_id" {
  description = "VNet id of the spoke network"
  value       = azurerm_virtual_network.vnet_1.id
}

output "vnet_name" {
  description = "VNet name of the spoke network"
  value       = azurerm_virtual_network.vnet_1.name
}

output "subnet_ids" {
  description = "Subnet names and id's as Name:ID"
  value       = zipmap(values(azurerm_subnet.subnet)[*]["name"], values(azurerm_subnet.subnet)[*]["id"])
}

output "nsg_ids" {
  description = "Subnet names and id's as Name:ID"
  value       = zipmap(values(azurerm_network_security_group.nsg)[*]["name"], values(azurerm_network_security_group.nsg)[*]["id"])
}
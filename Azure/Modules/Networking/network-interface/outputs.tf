output "nic_ids" {
  description = "Map of NIC names to their IDs"
  value = {
    for k, v in azurerm_network_interface.nic : k => v.id
  }
}
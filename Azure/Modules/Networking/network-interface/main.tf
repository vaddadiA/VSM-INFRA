network interface:
resource "azurerm_network_interface" "nic" {
  for_each = var.nics

  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  name                = each.value.name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = each.value.ip_configuration.subnet_id
    private_ip_address_version    = each.value.ip_configuration.private_ip_address_version
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    private_ip_address            = each.value.ip_configuration.private_ip_address
    public_ip_address_id          = each.value.ip_configuration.public_ip_address_id
  }
}
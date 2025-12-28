locals {
  # Parse the metadata
  metadata = jsondecode(file("${path.module}/metadata.json"))

  # Append the default tags
  tags = merge(
    { "serviceVersion" = "spoke_${local.metadata.version}" },
    var.tags
  )

  object_id = try(data.azurerm_client_config.current.object_id, null)

  client_config = {
    client_id       = data.azurerm_client_config.current.client_id
    object_id       = local.object_id
    subscription_id = data.azurerm_client_config.current.subscription_id
    tenant_id       = data.azurerm_client_config.current.tenant_id
  }

  firewall_private_ip = "your-ip-here"  # Replace with actual value
  route_tables = {}  # Define as needed
  subnet_route_table_associations = {}  # Define as needed
}
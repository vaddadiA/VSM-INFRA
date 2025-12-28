# terraform

# Basic configuration
resource_group_name = "rg-dev-vsm"
location = "West Europe"
tags = {
  Environment = "dev"
  Project     = "vsm"
}

# NICs
nics = {
  "nic-linux-vm" = {
    name       = "nic-linux-vm"
    subnet_id  = "/subscriptions/4907c122-2bda-4f73-b2b6-e1e3e9d8a71a/resourceGroups/rg-dev-vsm/providers/Microsoft.Network/virtualNetworks/vnet-spoke/subnets/subnet1"
    vnet_name  = "vnet-spoke"
    subnet_name = "subnet1"
  }
}

# Linux VMs
linux_vms = {
  "linux-vm-1" = {
    name       = "linux-vm-1"
    nic_name   = "nic-linux-vm"
    size       = "Standard_B2s"
    admin_username = "azureadmin"
    admin_password = "P@ssw0rd123!"
    source_image_reference = {
      publisher = "Canonical"
      offer     = "Ubuntu2204"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 30
    }
  }
}

# Other defaults can be left as is
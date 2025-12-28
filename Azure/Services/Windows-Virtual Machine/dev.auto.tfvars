# Basic configuration
resource_group_name = "rg-dev-vsm"
location = "West Europe"
tags = {
  Environment = "dev"
  Project     = "vsm"
}

# NICs
nics = {
  "nic-windows-vm" = {
    name       = "nic-windows-vm"
    subnet_id  = "/subscriptions/4907c122-2bda-4f73-b2b6-e1e3e9d8a71a/resourceGroups/rg-dev-vsm/providers/Microsoft.Network/virtualNetworks/vnet-spoke/subnets/subnet1"
    vnet_name  = "vnet-spoke"
    subnet_name = "subnet1"
  }
}

# Windows VMs
windows_vms = {
  "windows-vm-1" = {
    name       = "windows-vm-1"
    nic_name   = "nic-windows-vm"
    size       = "Standard_D2s_v3"
    admin_username = "azureadmin"
    admin_password = "P@ssw0rd123!"
    license_type = "Windows_Server"
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter"
      version   = "latest"
    }
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 127
    }
    patch_assessment_mode = "AutomaticByPlatform"
    patch_mode            = "AutomaticByPlatform"
    provision_vm_agent    = true
  }
}

# CrowdStrike configs (required)
crowdstrike_configs = {
  falcon_cid           = "your-falcon-cid"
  falcon_client_id     = "your-client-id"
  falcon_client_secret = "your-client-secret"
  falcon_cloud         = "us-1"
}

# Other defaults can be left as is
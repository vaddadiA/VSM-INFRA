linux_vms = {
  vobc_1001 = {
    location                   = "westeurope"
    resource_group_name        = "rg-dev"
    name                       = "vobc_1001"
    admin_username             = "azureadmin"
    admin_password             = ""
    network_interface_ids      = ["<nic-id-for-vobc-1001>"]
    license_type               = ""
    size                       = "Standard_B4ms"
    availability_set_id        = ""
    computer_name              = "vobc_1001"
    custom_data                = ""
    disable_password_authentication = false
    encryption_at_host_enabled = false
    secure_boot_enabled        = false
    source_image_id            = ""
    boot_diagnostics_enabled   = true
    boot_diagnostics_storage_account_uri = ""
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    admin_ssh_public_key = ""
    vtpm_enabled         = false
    patch_assessment_mode = "AutomaticByPlatform"
    patch_mode            = "AutomaticByPlatform"
    provision_vm_agent    = true
    identity_type         = "SystemAssigned"
    identity_ids          = []
    os_disk = {
      caching              = "None"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 30
    }
    plan = null
  }

  vobc_1002 = {
    location                   = "westeurope"
    resource_group_name        = "rg-dev"
    name                       = "vobc_1002"
    admin_username             = "azureadmin"
    admin_password             = ""
    network_interface_ids      = ["<nic-id-for-vobc-1002>"]
    license_type               = ""
    size                       = "Standard_B4ms"
    availability_set_id        = ""
    computer_name              = "vobc_1002"
    custom_data                = ""
    disable_password_authentication = false
    encryption_at_host_enabled = false
    secure_boot_enabled        = false
    source_image_id            = ""
    boot_diagnostics_enabled   = true
    boot_diagnostics_storage_account_uri = ""
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    admin_ssh_public_key = ""
    vtpm_enabled         = false
    patch_assessment_mode = "AutomaticByPlatform"
    patch_mode            = "AutomaticByPlatform"
    provision_vm_agent    = true
    identity_type         = "SystemAssigned"
    identity_ids          = []
    os_disk = {
      caching              = "None"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 30
    }
    plan = null
  }

  vobc_1003 = {
    location                   = "westeurope"
    resource_group_name        = "rg-dev"
    name                       = "vobc_1003"
    admin_username             = "azureadmin"
    admin_password             = ""
    network_interface_ids      = ["<nic-id-for-vobc-1003>"]
    license_type               = ""
    size                       = "Standard_B4ms"
    availability_set_id        = ""
    computer_name              = "vobc_1003"
    custom_data                = ""
    disable_password_authentication = false
    encryption_at_host_enabled = false
    secure_boot_enabled        = false
    source_image_id            = ""
    boot_diagnostics_enabled   = true
    boot_diagnostics_storage_account_uri = ""
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    admin_ssh_public_key = ""
    vtpm_enabled         = false
    patch_assessment_mode = "AutomaticByPlatform"
    patch_mode            = "AutomaticByPlatform"
    provision_vm_agent    = true
    identity_type         = "SystemAssigned"
    identity_ids          = []
    os_disk = {
      caching              = "None"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 30
    }
    plan = null
  }

  vobc_1004 = {
    location                   = "westeurope"
    resource_group_name        = "rg-dev"
    name                       = "vobc_1004"
    admin_username             = "azureadmin"
    admin_password             = ""
    network_interface_ids      = ["<nic-id-for-vobc-1004>"]
    license_type               = ""
    size                       = "Standard_B4ms"
    availability_set_id        = ""
    computer_name              = "vobc_1004"
    custom_data                = ""
    disable_password_authentication = false
    encryption_at_host_enabled = false
    secure_boot_enabled        = false
    source_image_id            = ""
    boot_diagnostics_enabled   = true
    boot_diagnostics_storage_account_uri = ""
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    admin_ssh_public_key = ""
    vtpm_enabled         = false
    patch_assessment_mode = "AutomaticByPlatform"
    patch_mode            = "AutomaticByPlatform"
    provision_vm_agent    = true
    identity_type         = "SystemAssigned"
    identity_ids          = []
    os_disk = {
      caching              = "None"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 30
    }
    plan = null
  }
}

tags = {}
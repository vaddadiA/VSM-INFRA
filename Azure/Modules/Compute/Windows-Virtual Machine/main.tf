# Configure Terraform to set the required AzureRM provider
# version and features{} block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.87.0"
    }
  }
}

resource "random_password" "password" {
  length           = 16
  lower            = true
  min_lower        = 0
  min_upper        = 0
  min_numeric      = 0
  min_special      = 0
  numeric          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  special          = true
  upper            = true
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  for_each = var.windows_vms

  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  name                       = each.value.name
  admin_username             = each.value.admin_username
  admin_password             = each.value.admin_password != "" ? each.value.admin_password : null
  network_interface_ids      = each.value.network_interface_ids
  license_type               = each.value.license_type != "" ? each.value.license_type : null
  size                       = each.value.size
  availability_set_id        = each.value.availability_set_id != "" ? each.value.availability_set_id : null
  computer_name              = each.value.computer_name != "" ? each.value.computer_name : null
  custom_data                = each.value.custom_data != "" ? each.value.custom_data : null
  encryption_at_host_enabled = each.value.encryption_at_host_enabled
  secure_boot_enabled        = each.value.secure_boot_enabled
  enable_automatic_updates   = each.value.enable_automatic_updates
  source_image_id            = each.value.source_image_id != "" ? each.value.source_image_id : null
  vm_agent_platform_updates_enabled = each.value.vm_agent_platform_updates_enabled
  vtpm_enabled               = each.value.vtpm_enabled
  patch_assessment_mode      = each.value.patch_assessment_mode
  provision_vm_agent         = each.value.provision_vm_agent
  patch_mode                 = each.value.patch_mode
  timezone                   = each.value.timezone

  dynamic "identity" {
    for_each = each.value.identity_type != "" ? [1] : []
    content {
      type         = each.value.identity_type
      identity_ids = contains(local.allowed_identity_types, each.value.identity_type) ? each.value.identity_ids : null
    }
  }

  dynamic "boot_diagnostics" {
    for_each = each.value.boot_diagnostics_enabled ? [1] : []
    content {
      storage_account_uri = each.value.boot_diagnostics_storage_account_uri != "" ? each.value.boot_diagnostics_storage_account_uri : null
    }
  }

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
    disk_size_gb         = each.value.os_disk.disk_size_gb
    name                 = each.value.os_disk.disk_name != "" ? each.value.os_disk.disk_name :  null
  }

  dynamic "source_image_reference" {
    for_each = each.value.source_image_reference != null ? [1] : []
    content {
      publisher = each.value.source_image_reference.publisher
      offer     = each.value.source_image_reference.offer
      sku       = each.value.source_image_reference.sku
      version   = each.value.source_image_reference.version
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      vm_agent_platform_updates_enabled,
    ]
  }
}
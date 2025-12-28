locals {
  # Parse the metadata
  metadata = jsondecode(file("${path.module}/metadata.json"))

  # Append the default tags
  tags = merge(
    { "serviceVersion" = "linux_virtual_machine_${local.metadata.version}" },
    var.tags
  )

  current_subscription_id = data.azurerm_client_config.current.subscription_id

  nics = tomap({
    for nic, nic_config in var.nics : nic => {
      location            = var.location
      resource_group_name = var.resource_group_name
      name                = nic_config.name
      ip_configuration = {
        subnet_id                     = coalesce(nic_config.subnet_id, "/subscriptions/${local.current_subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${nic_config.vnet_name}/subnets/${nic_config.subnet_name}")
        private_ip_address_version    = nic_config.private_ip_address_version
        private_ip_address_allocation = nic_config.private_ip_address_allocation
        private_ip_address            = nic_config.private_ip_address
        public_ip_address_id          = nic_config.public_ip_address_id
      }
    }
    if nic_config.isCreated == true
  })

  linux_vms = tomap({
    for lvm, lvm_config in var.linux_vms : lvm => {
      location                        = var.location
      resource_group_name             = var.resource_group_name
      name                            = lvm_config.name
      admin_username                  = lvm_config.admin_username
      admin_password                  = coalesce(lvm_config.admin_password, random_password.password.result)
      network_interface_ids           = [module.nic.nic_ids[lvm_config.nic_name]]
      license_type                    = lvm_config.license_type
      size                            = lvm_config.size
      computer_name                   = lvm_config.computer_name
      custom_data                     = lvm_config.custom_data
      disable_password_authentication = lvm_config.disable_password_authentication
      encryption_at_host_enabled      = lvm_config.encryption_at_host_enabled
      secure_boot_enabled             = lvm_config.secure_boot_enabled
      source_image_id                 = lvm_config.source_image_id
      source_image_reference          = lvm_config.source_image_reference
      admin_ssh_public_key            = lvm_config.admin_ssh_public_key
      vtpm_enabled                    = lvm_config.vtpm_enabled
      patch_assessment_mode           = lvm_config.patch_assessment_mode
      patch_mode                      = lvm_config.patch_mode
      provision_vm_agent              = lvm_config.provision_vm_agent
      identity_type                   = lvm_config.identity_type
      identity_ids                    = lvm_config.identity_ids
      os_disk                         = lvm_config.os_disk
      plan                            = lvm_config.plan
    }
    if lvm_config.isCreated == true
  })

  managed_disks = tomap({
    for md, md_config in var.managed_disks : md => {
      location             = var.location
      resource_group_name  = var.resource_group_name
      name                 = md_config.name
      storage_account_type = md_config.storage_account_type
      create_option        = md_config.create_option
      disk_size_gb         = md_config.disk_size_gb
    }
    if md_config.isCreated == true
  })

  vm_data_disk_attachments = tomap({
    for vmdda, vmdda_config in var.vm_data_disk_attachments : vmdda => {
      virtual_machine_id = module.linux_vm.linux_vm_ids[vmdda_config.virtual_machine_name]
      managed_disk_id    = module.managed_disk.managed_disk_ids[vmdda_config.managed_disk_name]
      lun                = vmdda_config.lun
      caching            = vmdda_config.caching
    }
    if vmdda_config.isCreated == true
  })

  vm_extensions = tomap({
    for vme, vme_config in var.vm_extensions : vme => {
      name                       = vme_config.name
      publisher                  = vme_config.publisher
      type                       = vme_config.type
      type_handler_version       = vme_config.type_handler_version
      provision_after_extensions = vme_config.provision_after_extensions
      settings                   = vme_config.settings
      protected_settings         = vme_config.protected_settings
    }
    if vme_config.isCreated == true
  })

  monitor_data_collection_rule_associations = tomap({
    for mcdra, mcdra_config in var.monitor_data_collection_rule_associations : mcdra => {
      name                        = mcdra_config.name
      data_collection_rule_id     = coalesce(mcdra_config.data_collection_rule_id, "/subscriptions/${local.current_subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${mcdra_config.data_collection_rule_name}")
      description                 = mcdra_config.name
    }
    if mcdra_config.isCreated == true
  })

  private_dns_record = tomap({
    for record, record_config in var.private_dns_record : record => {
      name                = record_config.name
      record_type         = record_config.record_type
      resource_group_name = record_config.dns_zone_resource_group_name
      private_zone_name   = record_config.private_zone_name
      ttl_in_seconds      = record_config.ttl_in_seconds
      TXT_value           = record_config.TXT_value
      alias               = record_config.alias
      ip_addresses        = record_config.nic_private_ip_address == true ? [module.nic.nic_private_ip_address[record_config.ip_addresses]] : [record_config.ip_addresses]
    }
    if record_config.isCreated == true
  })
}
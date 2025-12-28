
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.87.0"
    }
  }
  backend "azurerm" {}
}

# Define the provider configuration
provider "azurerm" {
  features {}
}

# Get the current client configuration from the AzureRM provider
data "azurerm_client_config" "current" {}

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

module "nic" {
  source = "../../modules/networking/network-interface"

  nics = local.nics
  tags = local.tags
}

module "linux_vm" {
  source = "../../modules/compute/linux-virtual-machine"

  linux_vms = local.linux_vms
  tags      = local.tags

  depends_on = [module.nic]
}

module "managed_disk" {
  source = "../../modules/compute/managed-disk"

  managed_disks = local.managed_disks
  tags          = local.tags
}

module "vm_data_disk_attachment" {
  source = "../../modules/compute/virtual-machine-data-disk-attachment"

  vm_data_disk_attachments = local.vm_data_disk_attachments

  depends_on = [
    module.linux_vm,
    module.managed_disk,
  ]
}

module "vm_extension" {
  source = "../../modules/compute/virtual-machine-extension"

  for_each = module.linux_vm.linux_vm_ids

  virtual_machine_id = each.value
  vm_extensions      = local.vm_extensions
  tags               = local.tags

  depends_on = [module.linux_vm]
}

module "monitor_data_collection_rule_association" {
  source = "../../modules/management-and-governance/monitor-data-collection-rule-association"

  for_each = module.linux_vm.linux_vm_ids

  target_resource_id                        = each.value
  monitor_data_collection_rule_associations = local.monitor_data_collection_rule_associations

  depends_on = [module.vm_extension]
}

module "dns_records" {
  source = "../../modules/networking/dns-records"

  private_dns_record = local.private_dns_record
}

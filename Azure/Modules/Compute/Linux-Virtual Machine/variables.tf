variable "linux_vms" {
  description = "List of Azure Linux Virtual Machine configurations."
  type = map(object({
    location                             = string
    resource_group_name                  = string
    name                                 = string
    admin_username                       = optional(string, "azureadmin")
    admin_password                       = optional(string, "")
    network_interface_ids                = list(string)
    license_type                         = optional(string, "")
    size                                 = optional(string, "Standard_B2s")
    availability_set_id                  = optional(string, "")
    computer_name                        = optional(string, "")
    custom_data                          = optional(string, "")
    disable_password_authentication      = optional(bool, false)
    encryption_at_host_enabled           = optional(bool, false)
    secure_boot_enabled                  = optional(bool, false)
    source_image_id                      = optional(string, "")
    boot_diagnostics_enabled             = optional(bool, true)
    boot_diagnostics_storage_account_uri = optional(string, "")
    source_image_reference = optional(object({
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string)
    }), null)
    admin_ssh_public_key = optional(string, "")
    vtpm_enabled         = optional(bool, false)
    patch_assessment_mode= optional(string, "AutomaticByPlatform")
    patch_mode           = optional(string, "AutomaticByPlatform")
    provision_vm_agent   = optional(bool, true)
    identity_type        = optional(string, "SystemAssigned")
    identity_ids         = optional(list(string), [])
    os_disk = object({
      caching              = optional(string, "None")
      storage_account_type = optional(string, "Standard_LRS")
      disk_size_gb         = optional(number, 30)
    })
    plan = optional(object({
      name = optional(string)
      product = optional(string)
      publisher = optional(string)
    }), null)
  }))
  default = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

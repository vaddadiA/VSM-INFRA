
variable "resource_group_name" {
  description = "The name of the Resource Group."
  type        = string
  default     = ""
}

variable "location" {
  description = "The location."
  type        = string
}

variable "nics" {
  description = "List of Azure Network Interface configurations."
  type = map(object({
    isCreated                     = optional(bool, true)
    name                          = string
    subnet_id                     = optional(string, "")
    vnet_name                     = optional(string, "")
    subnet_name                   = optional(string, "")
    private_ip_address_version    = optional(string, "IPv4")
    private_ip_address_allocation = optional(string, "Dynamic")
    private_ip_address            = optional(string, "")
    public_ip_address_id          = optional(string, "")
  }))
  default = {}
}

variable "linux_vms" {
  description = "List of Azure Linux Virtual Machine configurations."
  type = map(object({
    isCreated                            = optional(bool, true)
    name                                 = string
    admin_username                       = optional(string, "azureadmin")
    admin_password                       = optional(string, "")
    nic_name                             = string
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
    admin_ssh_public_key  = optional(string, "")
    vtpm_enabled          = optional(bool, false)
    patch_assessment_mode = optional(string, "AutomaticByPlatform")
    patch_mode            = optional(string, "AutomaticByPlatform")
    provision_vm_agent    = optional(bool, true)
    identity_type         = optional(string, "SystemAssigned")
    identity_ids          = optional(list(string), [])
    os_disk = object({
      caching              = optional(string, "None")
      storage_account_type = optional(string, "Standard_LRS")
      disk_size_gb         = optional(number, 30)
    })
    plan = optional(object({
      name      = optional(string)
      product   = optional(string)
      publisher = optional(string)
    }), null)
  }))
  default = {}
}

variable "managed_disks" {
  description = "List of Azure Managed Disk configurations."
  type = map(object({
    isCreated            = optional(bool, true)
    name                 = string
    storage_account_type = optional(string, "Standard_LRS")
    create_option        = optional(string, "Empty")
    disk_size_gb         = optional(number, 30)
  }))
  default = {}
}

variable "vm_data_disk_attachments" {
  description = "List of Azure Virtual Machine Data Disk Attachment configurations."
  type = map(object({
    isCreated            = optional(bool, true)
    virtual_machine_name = string
    managed_disk_name    = string
    lun                  = string
    caching              = optional(string, "None")
  }))
  default = {}
}

variable "vm_extensions" {
  description = "List of Azure Linux Virtual Machine Extension configurations."
  type = map(object({
    isCreated                  = optional(bool, true)
    name                       = string
    publisher                  = string
    type                       = string
    type_handler_version       = string
    provision_after_extensions = optional(list(string), null)
    settings                   = optional(string, null)
    protected_settings         = optional(string, null)
  }))
  default = {}
}
variable "monitor_data_collection_rule_associations" {
  description = "List of Azure Monitor Data Collection Rule Association configurations."
  type = map(object({
    isCreated                 = optional(bool, true)
    name                      = optional(string, "")
    data_collection_rule_name = optional(string, "")
    data_collection_rule_id   = optional(string, "")
    description               = optional(string, "")
  }))
  default = {}
}
variable "sudoerUserName" {
  description = "The AD domain account username that has permission to be sudoer on the machine."
  type        = string
  default     = ""
}

variable "privilegedUsername" {
  description = "The privileged AD domain account username that has permission to join the AD domain."
  type        = string
  default     = ""
}

variable "privilegedPassword" {
  description = "The privileged AD domain account password."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "private_dns_record" {
  description = "Configurations for the dns record to be added."
  type = map(object({
    isCreated                    = optional(bool, false)
    name                         = string
    record_type                  = string
    private_zone_name            = string
    dns_zone_resource_group_name = string
    ttl_in_seconds               = string
    TXT_value                    = optional(string)
    alias                        = optional(string)
    nic_private_ip_address       = optional(bool, false)
    ip_addresses                 = optional(string)
  }))
  default = {}
}

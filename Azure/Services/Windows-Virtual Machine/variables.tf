
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
  }))
  default = {}
}

variable "windows_vms" {
  description = "List of Azure Windows Virtual Machine configurations."
  type = map(object({
    isCreated                            = optional(bool, true)
    name                                 = string
    admin_username                       = optional(string, "azureadmin")
    admin_password                       = optional(string, "")
    nic_name                             = string
    license_type                         = optional(string, "Windows_Server")
    size                                 = optional(string, "Standard_B2s")
    availability_set_id                  = optional(string, "")
    computer_name                        = optional(string, "")
    custom_data                          = optional(string, "")
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
    vtpm_enabled             = optional(bool, false)
    patch_assessment_mode    = optional(string, "ImageDefault")
    patch_mode               = optional(string, "Manual")
    enable_automatic_updates = optional(bool, false)
    provision_vm_agent       = optional(bool, true)
    identity_type            = optional(string, "SystemAssigned")
    identity_ids             = optional(list(string), [])
    os_disk = object({
      caching              = optional(string, "None")
      storage_account_type = optional(string, "Standard_LRS")
      disk_size_gb         = optional(number, 30)
      disk_name            = optional(string, "")
    })
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
  description = "List of Azure Windows Virtual Machine Extension configurations."
  type = map(object({
    isCreated                  = optional(bool, true)
    name                       = string
    publisher                  = string
    type                       = string
    type_handler_version       = string
    provision_after_extensions = optional(list(string), null)
    settings                   = optional(string, null)
    protected_settings         = optional(string, null)
    is_avd_host                = optional(bool, false)
  }))
  default = {}
}

variable "custom_script_location" {
  description = "List of custom script location to execute in VM post-provisioned. Make sure the location is accessible from VM."
  type = string
  default = ""
}

variable "custom_script_command" {
  description = "Custom script execution command to execute in VM post-provisioned. Overwrite the default value with your script command from the input file."
  type = string
  default = "hostname && uptime"
}

variable "adJoinDomainUsername" {
  description = "The AD domain account username that will be joined to the Virtual Machine."
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

variable "crowdstrike_configs" {
  description = "Crowdstrike configurations."
  type = object({
    falcon_cid           = string
    falcon_client_id     = string
    falcon_client_secret = string
    falcon_cloud         = string
  })
}

variable "monitor_data_collection_rule_associations" {
  description = "List of Azure Monitor Data Collection Rule Association configurations."
  type = map(object({
    isCreated                 = optional(bool, true)
    name                      = string
    data_collection_rule_name = optional(string, "")
    data_collection_rule_id   = optional(string, "")
  }))
  default = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

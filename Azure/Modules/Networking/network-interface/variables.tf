variable "nics" {
  description = "Map of network interfaces to create"
  type = map(object({
    location            = string
    resource_group_name = string
    name                = string
    ip_configuration = object({
      subnet_id                     = string
      private_ip_address_version    = optional(string, "IPv4")
      private_ip_address_allocation = string
      private_ip_address            = optional(string)
      public_ip_address_id          = optional(string)
    })
  }))
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
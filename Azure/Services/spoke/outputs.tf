output "vnet_id" {
  description = "vnet ids"
  value       = module.vnets.vnet_id
}

output "vnet_name" {
  description = "vnet names"
  value       = module.vnets.vnet_name
}

output "subnet_ids" {
  description = "Subnet ids"
  value       = module.vnets.subnet_ids
}

output "delegated_subnets" {
  description = "Delegated subnets"
  value       = module.delegated_subnets[*]
}
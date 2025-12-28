output "nic_ids" {
  description = "The ID of the created Network Interface(s)."
  value       = module.nic.nic_ids
}

output "linux_vm_ids" {
  description = "The ID of the created Linux Virtual Machine(s)."
  value       = module.linux_vm.linux_vm_ids
}
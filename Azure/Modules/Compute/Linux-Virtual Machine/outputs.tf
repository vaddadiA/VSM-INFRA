output "linux_vm_ids" {
  description = "A map of the name and ID of the Azure Linux Virtual Machine(s)."
  value       = zipmap(values(azurerm_linux_virtual_machine.linux_vm)[*]["name"], values(azurerm_linux_virtual_machine.linux_vm)[*]["id"])
}
output "windows_vm_ids" {
  description = "A map of the name and ID of the Azure Windows Virtual Machine(s)."
  value       = zipmap(values(azurerm_windows_virtual_machine.windows_vm)[*]["name"], values(azurerm_windows_virtual_machine.windows_vm)[*]["id"])
}
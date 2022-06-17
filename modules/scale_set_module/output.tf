output "scale_set_password_output" {
  sensitive = true
  value = azurerm_linux_virtual_machine_scale_set.app_scale_set.admin_password
}
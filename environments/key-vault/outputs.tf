# Exposes Key Vault details for use by the application infrastructure.
output "key_vault_name" {
  description = "Name of the persistent Key Vault"
  value       = azurerm_key_vault.eshop.name
}

output "key_vault_uri" {
  description = "URI of the persistent Key Vault"
  value       = azurerm_key_vault.eshop.vault_uri
}

output "key_vault_id" {
  description = "Resource ID of the persistent Key Vault"
  value       = azurerm_key_vault.eshop.id
}
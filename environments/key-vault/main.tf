# Creates persistent security infrastructure independently of the eShop application resources.

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "security" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_string" "key_vault_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_key_vault" "eshop" {
  name                = "eshopdevkv${random_string.key_vault_suffix.result}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true
  purge_protection_enabled   = true

  tags = {
    environment = "persistent"
    project     = "eShopOnWeb"
  }
}

resource "azurerm_role_assignment" "admin_key_vault_access" {
  scope                = azurerm_key_vault.eshop.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
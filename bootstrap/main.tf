#bootstrap/main.tf

# creates the resource group and the storage account for the backend remote state

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = local.selected_region
  //name     = module.naming.resource_group.name_unique
  name = local.resource_group_name
}


resource "azurerm_storage_account" "this" {
  name                     = "state${module.naming.storage_account.name_unique}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "this" {
  name                  = local.storage_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

//Identify the Azure identity currently authenticated through Azure CLI
data "azurerm_client_config" "current" {}

// assign this role to enable the user to read/write to the storage account for state management
resource "azurerm_role_assignment" "this" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

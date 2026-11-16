
// create resource group for the dev environment
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.selected_region
}
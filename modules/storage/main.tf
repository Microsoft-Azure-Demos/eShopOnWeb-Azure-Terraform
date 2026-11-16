
// create storage account for the dev environment
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.selected_region
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

// create storage container for the dev environment
resource "azurerm_storage_container" "this" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "blob"
}
// get the id of the current Azure AD application (service principal) for the dev environment
data "azurerm_client_config" "current" {}


// grant permissions to the storage account for the dev environment
resource "azurerm_role_assignment" "this" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

// upload the images to the storage container for the dev environment
// the images not as zip file, but as individual files in the images folder
// Upload individual images to the Azure Blob Storage container
resource "azurerm_storage_blob" "images" {
  for_each = fileset(var.image_directory, "**")

  name                 = each.value
  storage_container_id = azurerm_storage_container.this.id
  type                 = "Block"
  source               = "${var.image_directory}/${each.value}"
  content_type = lookup({
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    png  = "image/png"
    gif  = "image/gif"
    svg  = "image/svg+xml"
    webp = "image/webp"
  }, lower(element(split(".", each.value), length(split(".", each.value)) - 1)), "application/octet-stream")
}



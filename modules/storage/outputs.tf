// storage module outputs
output "storage_account_id" {
  value       = azurerm_storage_account.this.id
  description = "The ID of the storage account."
} 

output "storage_container_id" {
  value       = azurerm_storage_container.this.id
  description = "The ID of the storage container."
}

output "storage_account_name" {
  value       = azurerm_storage_account.this.name
  description = "The name of the storage account."
}

output "storage_account_primary_endpoint" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}


output "uploaded_images" {
  value = [
    for image in azurerm_storage_blob.images :
    image.name
  ]
}



output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "storage_blob_endpoint" {
  value = module.storage.storage_account_primary_endpoint
}

output "uploaded_images" {
  value = module.storage.uploaded_images
}


//managed identity outputs for the app service modules
output "webmvc_principal_id" {
  description = "Web MVC App Service Managed Identity principal ID"
  value       = module.app_service_webmvc.principal_id
}

output "publicapi_principal_id" {
  description = "Public API App Service Managed Identity principal ID"
  value       = module.app_service_publicapi.principal_id
}

# Exposes the Azure SQL Server FQDN for the database-permissions configuration.
output "sql_server_fqdn" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}


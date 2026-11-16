
# Exposes the App Service name, managed identity, and default hostname to other modules.

output "app_service_name" {
  description = "The name of the App Service"
  value       = azapi_resource.app_service.name
}

output "principal_id" {
  description = "System-assigned Managed Identity principal ID"
  value       = azapi_resource.app_service.output.identity.principalId
}

output "default_hostname" {
  description = "Default hostname of the App Service"
  value       = azapi_resource.app_service.output.properties.defaultHostName
}

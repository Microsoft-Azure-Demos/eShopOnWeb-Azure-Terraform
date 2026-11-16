# Centralizes application settings for the Web MVC App Service.
locals {
  webmvc_app_settings = {
    ASPNETCORE_ENVIRONMENT = "Production"
    ASPNETCORE_URLS        = "http://+:8080"

    # Retrieves the JWT signing key securely from Azure Key Vault.
    # Reads the JWT signing key from the persistent Key Vault's remote-state output.
    Authentication__Jwt__SigningKey = "@Microsoft.KeyVault(SecretUri=${data.terraform_remote_state.key_vault.outputs.key_vault_uri}secrets/jwt-signing-key)"

    ConnectionStrings__CatalogConnection = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${var.sql_catalog_database_name};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication=Active Directory Managed Identity;"

    ConnectionStrings__IdentityConnection = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${var.sql_identity_database_name};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication=Active Directory Managed Identity;"

    ImageBaseUrl = module.storage.storage_account_primary_endpoint
    # Configures the Public API endpoint used by the Web MVC application.
    #baseUrls__apiBase = "https://${module.app_service_publicapi.default_hostname}/"
    # Temporarily omits the Public API URL to break the App Service dependency cycle.
    # Configures the actual Public API hostname used by Web MVC.
    baseUrls__apiBase = "https://${module.app_service_publicapi.default_hostname}/api/"

    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITES_PORT                       = "8080"
  }

  # Centralizes application settings for the Public API App Service.
  publicapi_app_settings = {
    ASPNETCORE_ENVIRONMENT = "Docker"
    ASPNETCORE_URLS        = "http://+:8080"

    # Retrieves the JWT signing key securely from Azure Key Vault.

    # Reads the JWT signing key from the persistent Key Vault's remote-state output.
    Authentication__Jwt__SigningKey = "@Microsoft.KeyVault(SecretUri=${data.terraform_remote_state.key_vault.outputs.key_vault_uri}secrets/jwt-signing-key)"

    ConnectionStrings__CatalogConnection = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${var.sql_catalog_database_name};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication=Active Directory Managed Identity;"

    ConnectionStrings__IdentityConnection = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${var.sql_identity_database_name};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication=Active Directory Managed Identity;"

    ImageBaseUrl = module.storage.storage_account_primary_endpoint
    # Configures the Web MVC endpoint used by the Public API application.
    #baseUrls__webBase = "https://${module.app_service_webmvc.default_hostname}/"
    # Temporarily omits the Web MVC URL to break the App Service dependency cycle.
    # Configures the actual Web MVC hostname used by the Public API.
    baseUrls__webBase = "https://${module.app_service_webmvc.default_hostname}/"

    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITES_PORT                       = "8080"
  }




}


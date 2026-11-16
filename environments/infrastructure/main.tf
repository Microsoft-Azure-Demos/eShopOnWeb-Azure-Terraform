
#environments/infrastructure/main.tf

# Reads the persistent Key Vault details from its separate Terraform state.
data "terraform_remote_state" "key_vault" {
  backend = "azurerm"

  config = {
    resource_group_name  = "eShop-Azure-RG"
    storage_account_name = "statestlj2r"
    container_name       = "tfstate-container"
    key                  = "key-vault.tfstate"
    use_azuread_auth     = true
  }
}

module "resource_group" {
  source              = "../../modules/resource-group"
  resource_group_name = var.resource_group_name
  selected_region     = var.selected_region

}


# Allows both App Service Managed Identities to read secrets from Key Vault.
resource "azurerm_role_assignment" "publicapi_key_vault_access" {

  # Uses the Key Vault ID read from the separate persistent Terraform state.
  scope                = data.terraform_remote_state.key_vault.outputs.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.app_service_publicapi.principal_id
}

resource "azurerm_role_assignment" "webmvc_key_vault_access" {
  scope                = data.terraform_remote_state.key_vault.outputs.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.app_service_webmvc.principal_id
}


module "storage" {
  source                 = "../../modules/storage"
  resource_group_name    = module.resource_group.resource_group_name
  selected_region        = var.selected_region
  storage_container_name = var.storage_container_name
  storage_account_name   = var.storage_account_name

  // Images are stored alongside this environment's Terraform configuration.
  image_directory = "${path.root}/images"

}

# Shared App Service Plan for Web MVC and Public API

resource "azurerm_service_plan" "eshop" {
  name                = var.app_service_plan_name
  location            = var.selected_region
  resource_group_name = module.resource_group.resource_group_name

  os_type  = "Linux"
  sku_name = "B1"
}


// public API App Service
module "app_service_publicapi" {
  # Ensures the Resource Group exists before creating the App Service.
  depends_on = [module.resource_group]

  source                      = "../../modules/app-service"
  app_service_name            = var.app_service_publicapi_name
  resource_group_name         = module.resource_group.resource_group_name
  selected_region             = var.selected_region
  service_plan_id             = azurerm_service_plan.eshop.id
  environment                 = var.environment
  registry_server_url         = var.registry_server_url  # to take care of the registry urls
  app_service_container_image = var.app_service_publicapi_container_image
  # Passes Terraform-generated settings to the Public API App Service.
  app_settings = local.publicapi_app_settings
}

// web MVC App Service
module "app_service_webmvc" {
  # Ensures the Resource Group exists before creating the App Service.
  depends_on = [module.resource_group]

  source                      = "../../modules/app-service"
  app_service_name            = var.app_service_webmvc_name
  resource_group_name         = module.resource_group.resource_group_name
  selected_region             = var.selected_region
  environment                 = var.environment
  registry_server_url         = var.registry_server_url
  app_service_container_image = var.app_service_webmvc_container_image
  service_plan_id             = azurerm_service_plan.eshop.id
  # Passes Terraform-generated settings to the Web MVC App Service.
  app_settings = local.webmvc_app_settings
}


//-------------------------------------------------
// create sql server that will be connected to by the App Service using managed identity
# Create one Azure SQL Server shared by both databases

resource "azurerm_mssql_server" "sql_server" {
  name                = var.sql_server_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.selected_region
  version             = "12.0"

  //This configures Microsoft Entra-only authentication. 
  //No SQL administrator password is required.
  azuread_administrator {
    login_username              = var.sql_entra_admin_login
    object_id                   = var.sql_entra_admin_object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    azuread_authentication_only = true
  }

  tags = {
    environment = var.environment
  }
}

/*
# Allows outbound traffic from the Web MVC and Public API App Services to Azure SQL.
resource "azurerm_mssql_firewall_rule" "app_service_outbound" {
  name             = "AllowAppServiceOutbound"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "20.14.21.221"
  end_ip_address   = "20.25.168.230"
}
*/

# TEMPORARY TEST ONLY: Allows connections to Azure SQL from all public IPv4 addresses.
resource "azurerm_mssql_firewall_rule" "allow_all_test" {
  name             = "AllowAllForTesting"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

//You would also need a data source
data "azurerm_client_config" "current" {}


// create sql database that will be connected to by the App Service using managed identity
//using module from modules/sql-database/main.tf
module "sql_catalog_database" {
  source              = "../../modules/sql-database"
  resource_group_name = module.resource_group.resource_group_name
  selected_region     = var.selected_region
  sql_server_id       = azurerm_mssql_server.sql_server.id
  environment         = var.environment
  database_name       = var.sql_catalog_database_name
}

//identity database to be used by the App Service using managed identity
module "sql_identity_database" {
  source              = "../../modules/sql-database"
  resource_group_name = module.resource_group.resource_group_name
  selected_region     = var.selected_region
  sql_server_id       = azurerm_mssql_server.sql_server.id
  environment         = var.environment
  database_name       = var.sql_identity_database_name
}




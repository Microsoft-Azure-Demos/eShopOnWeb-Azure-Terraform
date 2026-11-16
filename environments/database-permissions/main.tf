
# Manages Microsoft Entra ID database users and permissions for the eShopOnWeb App Services.

data "terraform_remote_state" "infrastructure" {
  backend = "azurerm"

  config = {
    resource_group_name  = "eShop-Azure-RG"
    storage_account_name = "statestlj2r"
    container_name       = "tfstate-container"
    key                  = "dev.tfstate"
    use_azuread_auth     = true
  }
}

/*

Good. Your intended permissions are now represented by three database-user resources:
1. catalog_webmvc — Web MVC → CatalogDb.
2. identity_webmvc — Web MVC → IdentityDb.
3. catalog_publicapi — Public API → CatalogDb.
4. identity_publicapi — Public API → IdentityDb.

*/

resource "mssql_azuread_user" "catalog_webmvc" {
  database_name = var.sql_catalog_database_name
  name          = var.app_service_webmvc_name

  object_id = data.terraform_remote_state.infrastructure.outputs.webmvc_principal_id

  roles = [
    "db_datareader",
    "db_datawriter",
     "db_ddladmin"
  ]
}

# Creates the Public API Managed Identity user in CatalogDb with read/write permissions.
resource "mssql_azuread_user" "catalog_publicapi" {
  database_name = var.sql_catalog_database_name
  name          = var.app_service_publicapi_name

  object_id = data.terraform_remote_state.infrastructure.outputs.publicapi_principal_id

  roles = [
    "db_datareader",
    "db_datawriter",
     "db_ddladmin"
  ]
}


# Creates the Public API Managed Identity user in IdentityDb with read/write permissions.
resource "mssql_azuread_user" "identity_publicapi" {
  database_name = var.sql_identity_database_name
  name          = var.app_service_publicapi_name

  object_id = data.terraform_remote_state.infrastructure.outputs.publicapi_principal_id

  roles = [
    "db_datareader",
    "db_datawriter",
    "db_ddladmin"
  ]
}


# Grants Web MVC access to the IdentityDb database for ASP.NET Identity.
resource "mssql_azuread_user" "identity_webmvc" {
  name          = var.app_service_webmvc_name
  object_id     = data.terraform_remote_state.infrastructure.outputs.webmvc_principal_id
  database_name = var.sql_identity_database_name

  roles = [
    "db_datareader",
    "db_datawriter",
     "db_ddladmin"
  ]
}


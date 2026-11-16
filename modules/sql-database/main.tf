//sql-database/main.tf
//create sql database that will be connected to by the App Service using managed identity


# Create an Azure SQL Database
resource "azurerm_mssql_database" "sql_database" {
  name      = var.database_name
  server_id = var.sql_server_id
  sku_name  = "Basic"

  tags = {
    environment = var.environment
  }
}
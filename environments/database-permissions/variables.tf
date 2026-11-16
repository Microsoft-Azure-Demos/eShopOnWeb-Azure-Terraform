
/*
variable "sql_server_fqdn" {
  description = "Fully qualified domain name of the Azure SQL Server"
  type        = string
}
*/


variable "sql_catalog_database_name" {
  description = "Catalog database name"
  type        = string
  default     = "CatalogDb"
}

variable "app_service_webmvc_name" {
  description = "Web MVC App Service name"
  type        = string
  default     = "eshop-dev-webmvc"
}

variable "app_service_publicapi_name" {
  description = "Public API App Service name"
  type        = string
  default     = "eshop-dev-publicapi"
}

variable "sql_identity_database_name" {
  description = "Identity database name"
  type        = string
  default     = "IdentityDb"
}




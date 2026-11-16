variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
  default     = "eshop-dev-rg"
}

variable "selected_region" {
  description = "The Azure region to deploy resources in."
  type        = string
  default     = "germanywestcentral"
}

variable "storage_container_name" {
  description = "The name of the storage container to create."
  type        = string
  default     = "images"
}

variable "storage_account_name" {
  description = "The name of the storage account to create."
  type        = string
  default     = "eshopdevstorage"
}


// app service variables

variable "app_service_publicapi_name" {
  description = "Name of the public API App Service"
  type        = string
}

variable "app_service_webmvc_name" {
  description = "Name of the web MVC App Service"
  type        = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "app_service_publicapi_container_image" {
  type = string
}

variable "app_service_webmvc_container_image" {
  type = string
}

variable "app_service_plan_name" {
  type = string
}


//sql server and database variables
variable "sql_server_name" {
  description = "Name of the Azure SQL Server"
  type        = string
}


variable "sql_catalog_database_name" {
  description = "Name of the Catalog database"
  type        = string
}

variable "sql_identity_database_name" {
  description = "Name of the Identity database"
  type        = string
}

variable "sql_entra_admin_login" {
  type        = string
  description = "Microsoft Entra administrator display name"
}

variable "sql_entra_admin_object_id" {
  type        = string
  description = "Object ID of the Microsoft Entra administrator"
}

variable "registry_server_url" {
  description = "The URL of the container registry."
  type        = string
  default     = "index.docker.io"
}

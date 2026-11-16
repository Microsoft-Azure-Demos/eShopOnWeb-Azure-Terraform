variable "resource_group_name" {
  type = string
}

variable "selected_region" {
  type = string
}

variable "sql_server_id" {
  description = "ID of the existing Azure SQL Server"
  type        = string
}

variable "database_name" {
  type = string
}

variable "environment" {
  type = string
}
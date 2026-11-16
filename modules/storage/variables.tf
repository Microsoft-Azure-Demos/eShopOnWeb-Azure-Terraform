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

variable "image_directory" {
  description = "Path to the directory containing application images"
  type        = string
  //default     = "${path.module}/images"
}
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
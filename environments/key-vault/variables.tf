# Defines the location and dedicated Resource Group for persistent security resources.
variable "location" {
  description = "Azure region for the persistent Key Vault"
  type        = string
  default     = "germanywestcentral"
}

variable "resource_group_name" {
  description = "Dedicated Resource Group for persistent security resources"
  type        = string
  default     = "eshop-security-rg"
}
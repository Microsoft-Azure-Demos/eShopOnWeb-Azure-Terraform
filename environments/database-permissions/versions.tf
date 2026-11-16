terraform {
  required_version = ">= 1.5.0"

  required_providers {
    mssql = {
      source  = "muecahit94/mssql"
      version = "~> 1.8"
    }
  }

  backend "azurerm" {}
}
# Defines the Terraform and AzureRM provider requirements for persistent Key Vault infrastructure.
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    # Adds the Random provider for generating a unique Key Vault name.
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }



  backend "azurerm" {}
}

#environments/infrastructure/providers.tf
# Configures AzureRM and AzAPI providers for the shared infrastructure.

# Configures the AzureRM and AzAPI providers for infrastructure management.

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {}
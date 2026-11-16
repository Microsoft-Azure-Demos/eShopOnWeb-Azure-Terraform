# Stores persistent Key Vault infrastructure state separately from application infrastructure.
resource_group_name  = "eShop-Azure-RG"
storage_account_name = "statestlj2r"
container_name       = "tfstate-container"
key                  = "key-vault.tfstate"
use_azuread_auth     = true
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "1.4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.48.0"
    }
  }
}

provider "azurerm" {
  features {}
  alias   = "azure_rm"
}

provider "azuread" {
  tenant_id = "1a2b3456-c7d8-9123-efgh-456789i123jk"
}

module "azure_blob_storage" {
  source = "./modules/azure_blob_storage"
}

module "arc_ds_sp" {
  source = "./modules/arc_ds_sp"
}

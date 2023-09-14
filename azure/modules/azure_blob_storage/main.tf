terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  features {}
  alias   = "azure_rm"
}

data "azurerm_subscription" "primary" {
  provider = azurerm.azure_rm
}

resource "azuread_application" "auth" {
  display_name  = var.application_name
}

resource "azuread_service_principal" "auth" {
  application_id = azuread_application.auth.application_id
}

resource "azuread_service_principal_password" "auth" {
  service_principal_id = azuread_service_principal.auth.id
  value                = random_string.password.result
  end_date_relative    = "240h" 
}

resource "random_string" "password" {
  length               = var.password_length
  special              = var.password_special
  override_special     = var.password_override_special
}

resource "azurerm_role_assignment" "contributor" {
  provider             = azurerm.azure_rm
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.auth.id
}

resource "azurerm_role_assignment" "portworx_px_backup" {
  provider             = azurerm.azure_rm
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azuread_service_principal.auth.id
}

resource "azurerm_resource_group" "pxbackuprg" {
  provider = azurerm.azure_rm
  name     = var.azure_resource_group 
  location = var.azure_location
}    

resource "azurerm_storage_account" "pxbackup" {
  provider                 = azurerm.azure_rm
  name                     = var.azure_storage_account_name 
  resource_group_name      = azurerm_resource_group.pxbackuprg.name
  location                 = var.azure_location
  account_tier             = var.azure_storage_account_tier
  account_replication_type = var.azure_storage_data_redundancy 
}

resource "azurerm_storage_container" "pxbackup" {
  provider              = azurerm.azure_rm
  name                  = "content"
  storage_account_name  = azurerm_storage_account.pxbackup.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "pxbackup" {
  provider               = azurerm.azure_rm
  name                   = var.azure_storage_blob_container 
  storage_account_name   = azurerm_storage_account.pxbackup.name
  storage_container_name = azurerm_storage_container.pxbackup.name
  type                   = "Block"
}

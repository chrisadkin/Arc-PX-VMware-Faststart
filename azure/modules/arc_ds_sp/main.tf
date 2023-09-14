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

resource "azurerm_role_assignment" "monitoring_metrics_publisher" {
  provider             = azurerm.azure_rm
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azuread_service_principal.auth.id
}

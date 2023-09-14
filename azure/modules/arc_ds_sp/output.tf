output "subscription-id" {
  value = data.azurerm_subscription.primary.id
  description = "subscription"
}

output "tenant" {
  value = data.azurerm_subscription.primary.tenant_id
  description = "tenant"
}

output "password" {
  value = random_string.password.result
  description = "password"
}

output "name" {
  value = azuread_application.auth.application_id
  description = "name"
}

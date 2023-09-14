output "client_id" {
  value = azuread_application.auth.application_id
  description = "name"
}

output "client_secret" {
  value = random_string.password.result
  description = "password"
}

output "tenant_id" {
  value = data.azurerm_subscription.primary.tenant_id
  description = "tenant"
}

output "subscription_id" {
  value = data.azurerm_subscription.primary.id
  description = "subscription"
}

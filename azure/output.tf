output "client_id" {
  value = module.azure_blob_storage.client_id
  description = "name"
}

output "client_secret" {
  value = module.azure_blob_storage.client_secret
  description = "password"
}

output "tenant_id" {
  value = module.azure_blob_storage.tenant_id
  description = "tenant"
}

output "subscription_id" {
  value = module.azure_blob_storage.subscription_id
  description = "subscription"
}

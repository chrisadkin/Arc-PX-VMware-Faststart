variable "azure_subscription_id" {
  description = "Subscription GUID for where the data controller resource is to be created in Azure"
  type        = string
  default     = "ce5a3eca-e3bb-4208-86e9-ae9f675f827f"
}

variable "azure_resource_group" {
  type        = string
  default     = "arc-validation"
}

variable "azure_location" {
  type        = string
  default     = "eastus"
}

variable "azure_storage_account_name" {
  type        = string
  default     = "arcvalidation"
}

variable "azure_storage_account_tier" {
  type        = string
  default     = "Standard"
}

variable "azure_storage_data_redundancy" {
  type        = string
  default     = "LRS"
}

variable "azure_storage_blob_container" {
  type        = string
  default     = "arcvalidation"
}

variable "application_name" {
  default     = "arc_validation"
}

variable "password_length" {
  default     = 16
}

variable "password_special" {
  default     = true
}

variable "password_override_special" {
  default     = "_%@" 
}

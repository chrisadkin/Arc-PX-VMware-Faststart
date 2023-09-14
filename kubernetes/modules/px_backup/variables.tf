variable "helm_chart_version" {
  description = "Version of the Helm chart containing PX-Backup"
  type        = string
  default     = "2.0.1"
}

variable "storage_class" {
  default     = "portworx-sc"
}

variable "namespace" {
  description = "Namespace top deploy PX-Backup objects to"
  type        = string
  default     = "px-backup"
}

variable "azure_subscription_id" {
  description = "Subscription GUID for where the data controller resource is to be created in Azure"
  type        = string
  default     = "abcdefgh-ijkl-mnop-qrst-vwxyz1234567"
}

variable "azure_resource_group" {
  type        = string
  default     = "px-backup-rg"
}

variable "azure_location" {
  type        = string
  default     = "uksouth"
}

variable "azure_storage_account_name" {
  type        = string
  default     = "portworxpxbackup"
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
  default     = "pxbackup"
}

variable "application_name" {
  default     = "portworx_px_backup"
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

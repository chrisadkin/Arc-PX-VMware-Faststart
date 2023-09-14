variable "arc_data_namespace" {
  description = "Kubernetes namespace for Azure Arc for Data Services controller"
  type        = string
  default     = "azure-arc"
}

variable "azure_subscription_id" {
  description = "Subscription GUID for where the data controller resource is to be created in Azure"
  type        = string
  default     = "ce5a3eca-e3bb-4208-86e9-ae9f675f827f"
}

variable "resource_group" {
  description = "Resource group group where the data controller resource is to be created in Azure"
  type        = string
  default     = "AzureArc"
}

variable "azure_region" {
  description = "Location where controller resource metadata will be stored in Azure"
  type        = string
  default     = "eastus"
}

variable "cluster_name" {
  description = "Name of Kubernetes cluster to register with Azure arc"
  type        = string
  default     = "K8s_cluster"
}

variable "extension_instance" {
  description = "User defined label for the custom location extension"
  type        = string
  default     = "ext_instance"
}

variable "location_name" {
  description = "Name of custom location for Arc connected K8s cluster"
  type        = string
  default     = "pureuksouth"
}

variable "application_name" {
  default     = "Azure Arc enabled Data Services"
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

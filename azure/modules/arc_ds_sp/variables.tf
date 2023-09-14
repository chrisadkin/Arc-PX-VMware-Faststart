variable "arc_data_az_subscription_id" {
  description = "Subscription GUID for where the data controller resource is to be created in Azure"
  type        = string
  default     = "ce5a3eca-e3bb-4208-86e9-ae9f675f827f"
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

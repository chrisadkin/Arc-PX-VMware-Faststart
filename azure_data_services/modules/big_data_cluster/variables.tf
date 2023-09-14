variable "azdata_username" {
  description = "Azdata username"
  type        = string
  default     = "azuser"
}

variable "AZDATA_PASSWORD" {
  description = "azdata password is set via an environment variable, export TF_VAR_AZDATA_PASSWORD=<password goes here>"
  type        = string
}

variable "bdc_name" {
  description = "Big data cluster name"
  type        = string
  default     = "ca-bdc"
}

variable "bdc_profile_dir" {
  description = "Big data cluster profile directory"
  type        = string
  default     = "ca_bdc"
}

variable "bdc_storage_class" {
  description = "Storage class for the big data cluster"
  type        = string
  default     = "portworx-sc"
}

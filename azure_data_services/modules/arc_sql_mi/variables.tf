variable "secret_username" {
  type    = string
  default = "c2EK"
}

variable "secret_password" {
  type    = string
  default = "UEBzc3cwcmQK"
}

variable "namespace" {
  type    = string
  default = "arc-ds"
}

variable "instance_name" {
  type    = string
  default = "sqlmi3"
}

variable "cpu_request" {
  default = 4
}

variable "cpu_limit" {
  default = 4
}

variable "memory_request" {
  type    = string
  default = "2Gi"
}

variable "memory_limit" {
  type    = string
  default = "4Gi"
}

variable "service_type" {
  type    = string
  default = "NodePort"
}

variable "backups_storage_class" {
  type    = string
  default = "portworx-sc"
}

variable "volume_size_backups" {
  type    = string
  default = "5Gi"
}

variable "data_storage_class" {
  type    = string
  default = "portworx-sc"
}

variable "volume_size_data" {
  type    = string
  default = "5Gi"
}

variable "data_logs_storage_class" {
  type    = string
  default = "portworx-sc"
}

variable "volume_size_data_logs" {
  type    = string
  default = "5Gi"
}

variable "logs_storage_class" {
  type    = string
  default = "portworx-sc"
}

variable "volume_size_logs" {
  type    = string
  default = "5Gi"
}

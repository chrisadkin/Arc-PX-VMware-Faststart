variable "kubernetes_version" {
  type        = string
  default     = "1.22.5"
}

variable "container_manager" {
  type        = string
  default     = "containerd"
}

variable "node_hosts" {
  type = map(map(object({
      name          = string
      compute_node  = bool
      etcd_instance = string
      ipv4_address  = string
    })))
}

variable "helm_chart_version" {
  default     = "0.9.5"
}

variable "ip_pool_ranges" {
  type = map(object({
           ip_range_lower_boundary = string
           ip_range_upper_boundary = string
         }))
  default = {
    arc = {
      ip_range_lower_boundary = "10.225.115.89"
      ip_range_upper_boundary = "10.225.115.100"
    },
    bdc = {
      ip_range_lower_boundary = "192.168.123.14"
      ip_range_upper_boundary = "192.168.123.24"
    }
  }
}

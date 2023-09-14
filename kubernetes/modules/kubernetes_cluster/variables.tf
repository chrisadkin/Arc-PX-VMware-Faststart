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

variable "use_csi" {
  default     = false
}

variable "px_repl_factor" {
  default     = "2"
}

variable "px_spec" {
  description = "PX spec URL"
  type        = string
  default     = "https://install.portworx.com/2.6?mc=false&kbver=1.19.7&b=true&j=auto&c=px-cluster-942c7da3-d540-4b79-b391-b74453c1da43&stork=true&csi=true&st=k8s"
}

variable "use_stork" {
  description = "Boolean variable to determine whether or not the stork schedukler should be used"
  default     = true
}

variable "storage_class" {
  description = "Kubernetes storage class name"
  type        = string
  default     = "portworx-sc"
}

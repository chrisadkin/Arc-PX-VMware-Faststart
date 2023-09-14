
variable "vsphere_user" {
  description = "user for access vSphere vCenter appliance with"
  type        = string
  sensitive   = true
}

variable "VSPHERE_PASSWORD" {
  description = "Password associated with account for accessing vSphere vCenter appliance with"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server ip address"
  type        = string
  sensitive   = true
}

variable "vsphere_dc" {
  description = "vSphere data center name"
  type        = string
}

variable "vsphere_cluster" {
  description = "vSphere cluster name"
  type        = string
}

variable "vsphere_host" {
  description = "vSphere ESXi host"
  type        = string
}

variable "vsphere_datastore" {
  description = "Datastore to be used for provisioning virtual disks from"
  type        = string
}

variable "vsphere_network" {
  description = "Network to use for virtual machine"
  type        = string
}

variable "vsphere_resource_pool" {
  description = "Resource pool to allocate virtual machine to"
  type        = string
}

variable "vm_template" {
  default = "ubuntu-20.10-template"
}

variable "vm_domain" {
  default = "lab"
}

variable "vm_linked_clone" {
  default = "false"
}

variable "virtual_machines" {
  type = map(map(object({
      name          = string
      compute_node  = bool
      ipv4_address  = string
      ipv4_netmask  = string
      ipv4_gateway  = string
      dns_server    = string
      ram           = number
      logical_cpu   = number
      os_disk_size  = number
      px_disk_size  = number
    })))
}

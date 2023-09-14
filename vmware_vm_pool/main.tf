terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 1.24.3"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.VSPHERE_PASSWORD
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_dc
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster 
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool 
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "standalone" {
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  for_each = var.virtual_machines[terraform.workspace]
    name       = each.value.name
    memory     = each.value.ram
    num_cpus   = each.value.logical_cpu
    guest_id   = "ubuntu64Guest"

    network_interface {
      network_id   = data.vsphere_network.network.id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }

    disk {
      unit_number      = 0
      label            = "OS"
      size             = each.value.os_disk_size
      eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
      thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    }

    dynamic "disk" {
      for_each = each.value.compute_node ? [1] : []
        content {
        unit_number      = 1
        label            = "PX"
        size             = each.value.px_disk_size
        eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
      }
    }

    extra_config = {
      "disk.EnableUUID" = "TRUE"
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.template.id
      linked_clone  = var.vm_linked_clone

      customize {
        timeout = "20"

        linux_options {
          host_name = each.value.name
          domain    = var.vm_domain
        }

        network_interface {
          ipv4_address = each.value.ipv4_address 
          ipv4_netmask = each.value.ipv4_netmask 
        }

        ipv4_gateway    = each.value.ipv4_gateway 
        dns_server_list = [ each.value.dns_server ]
      }
    }
}

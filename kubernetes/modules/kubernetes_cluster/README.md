# Overview

This module deploys a kubernetes cluster, installs kubectl and creates a context with which users can connect to the cluster with

# Usage

## Apply

Execute the following command from the `Arc-PX-VMware-Faststart/kubernetes` directory
```
terraform apply -target=module.kubernetes_cluster --auto-approve 
```

## Destroy

Execute the following command from the `Arc-PX-VMware-Faststart/kubernetes` directory
```
terraform destroy -target=module.kubernetes_cluster --auto-approve 
```

# Dependencies

- The user that terraform apply is executed under should be able to ssh onto each machine that will host a cluster node without being prompted for a password
- The user that terraform apply is executed under should be able a member of the sudoers groups
- The ip address/hostname pair for each cluster node host should be present in the `/etc/hosts` file on the machine that `terraform apply` is executed from

# Variables

The minimum set of variables that need to be configured consists of those with no default values.

| Name                        | Data type | Description / Notes                                                 | Mandatory (Y/N) | Default Value                   |
|-----------------------------|-----------|---------------------------------------------------------------------|-----------------|---------------------------------|
| kubernetes_version          | string    | Set to true if the Portworx spec has been created with              |        Y        | 1.19.7                          |
| kubespray_inventory         | string    | Dir. under /home/<user>/kubespray/inventory for the cluster config  |        Y        | ca_bdc                          |

Node host configuration information is specified in the following variable:
```
variable "node_hosts" {
  default = {
    "z-ca-bdc-control1" = {
       name          = "z-ca-bdc-control1"
       compute_node   = false
       etcd_instance = "etcd1"
       ipv4_address  = "192.168.123.88"
    },
    "z-ca-bdc-control2" =  {
       name          = "z-ca-bdc-control2"
       compute_node   = false
       etcd_instance = "etcd2"
       ipv4_address  = "192.168.123.89"
    },
    "z-ca-bdc-compute1" = {
       name          = "z-ca-bdc-compute1"
       compute_node   = true
       etcd_instance = "etcd3"
       ipv4_address  = "192.168.123.90"
    },
    "z-ca-bdc-compute2" = {
       name          = "z-ca-bdc-compute2"
       compute_node   = true
       etcd_instance = ""
       ipv4_address  = "192.168.123.91"
    },
    "z-ca-bdc-compute3" = {
       name          = "z-ca-bdc-compute3"
       compute_node   = true
       etcd_instance = ""
       ipv4_address  = "192.168.123.92"
    }
  }
}
```
**Note**
- Specify true for the `compute_node` attribute if the host is a worker node, otherwise set this to false
- Specify a name for the `etcd_instance` attribute is the node host hosts an etcd instance
- The example provided will lead to the creation of a kubernetes cluster with three etcd instance, two control plane nodes and three worker (or compute) nodes, to reuse
  this simply provide the actual IP addresses for your servers in place of the 192.168.123.x addresses used in the example

# Known Issues / Limitations

A destroy provisioner is yet be implemented for the null resource that deploys the kubernetes cluster. 

[Back to root module](https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/README.md)

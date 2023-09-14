
# Overview

This module creates virtual machines based on a template via the terraform VMware vSphere provider

# Usage

## Apply

Create a Terraform workspace - unless the one requires already exists: 
```
terraform workspace new <workspace_name>
```
If the desired Terraform workspace already exists, there is no need to create it, it does
however need to be selected:
```
terraform workspace select <workspace_name>
```
*Note*
The variables.tf  supplied in this folder contains two blocks for two different sets of
virtual machines: arc and bdc.  If the aim is to create the virtual machines inside  of
the arc block,  the workspace name used  should be arc, alternatively if the  aim is to
create the set of virtual machines inside the bdc block, the workspace name used should 
be  bdc. If  the workspace  name does  not correspond to  virtual machine block  label,
terraform apply will fail.

Execute the following command from the `Arc-PX-VMware-Faststart/vmware_vm_pool` directory
```
terraform apply --auto-approve 
```

## Destroy

Execute the following command from the `Arc-PX-VMware-Faststart/vmware_vm_pool` directory
```
terraform destroy --auto-approve 
```
# Dependencies

- a VMware vSphere cluster is available 
- a template virtual machine created as per the instructions in the next section
  
# Virtual Machine Template Creation

1. In VMware vSphere vCenter create a new virtual machine:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/vmware/vmware1.PNG?raw=true">

2. Give the virtual machine a name

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/vmware/vmware2.PNG?raw=true">

3. Assign a compute resource to the virtual machine

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/vmware/vmware3.PNG?raw=true">

4. Select a datastore for the virtual machine

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/vmware/vmware4.PNG?raw=true">

5. Choose the compatibility level for the virtual machine, the latest version of vSphere available will suffice

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/vmware/vmware5.PNG?raw=true">

6. Select the guest OS family of Linux and the guest OS type of Ubuntu 64

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/vmware/vmware6.PNG?raw=true">

7. Set the logical CPU, memory, disk and CD/DVD resources for the virtual machine - connect the datastore ISO for Ubuntu 18.04 server LTS to the CD/DVD drive, this can
   be downloaded from this [link](https://ubuntu.com/download/server) 

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/vmware/vmware7.PNG?raw=true">

8. Review the configuration of the virtual machine and hit Finish

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/vmware/vmware8.PNG?raw=true">

9. Power on the virtual machine and go to the guest OS console.

10. Whilst configuring the guest OS, use tab to navigate around the screen, space-bar to toggle through configuration options and enter to confirm choices.

11. Choose the guest OS language

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu1.PNG?raw=true">

12. Choose the option to update to the new installer

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu2.PNG?raw=true">

13. Select the desired keyboard layout

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu3.PNG?raw=true">

14. Accept the default NIC configuration

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu4.PNG?raw=true">

15. Enter a proxy on this screen if one is required to access the internet

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu5.PNG?raw=true">

16. Accept the default mirror site

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu6.PNG?raw=true">

17. Choose the default option to use entire disk when creating the root filesystem

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu7.PNG?raw=true">

18. Confirm that the default layout is to be used

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu8.PNG?raw=true">

19. Confirm that you wish the installation process to destroy anything that might be on the OS disk - because this is a clean install, there is nothing to destroy

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu9.PNG?raw=true">

20. Enter details for the username and machine name, azuser and ubuntu-1804-template respectively

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu10.PNG?raw=true">

21. Use the spacebar to tick the option to install the OpenSSH server

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu11.PNG?raw=true">

22. No optional packages and required, so go straight to Done

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu12.PNG?raw=true">

23. Ubuntu will now install

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu13.PNG?raw=true">

24. When the Reboot now option appears, select this

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu14.PNG?raw=true">

25. Disconnect the CD/DVD drive in vSphere vCenter and hit enter

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu15.PNG?raw=true">

26. Login as azuser using the password entered earlier in step 20

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/images/ubuntu/ubuntu16.PNG?raw=true">

27. Whilst still in the virtual machine console add azuser to the sudo-ers group:
- enter sudo visudo
- at the end of the file which will appear in the nano editor add the following line
`azuser ALL=(ALL:ALL) NOPASSWD:ALL`
- CTRL+X then Y to save this change

28. Enable the azuser user on the main setup machine to ssh onto the virtual machines that will created from the template without having to provide a password:
- `sudo vi /etc/ssh/sshd_config` (alternatively you can use the nano editor)
- change the line `UsePAM yes` to `UsePAM no`
- change the line `#PasswordAuthentication yes` to `PasswordAuthentication no`
- change the line `ChallengeResponseAuthentication yes` to `ChallengeResponseAuthentication no`
- save the changes and exit the editor - `CTRL+[` , `SHIFT+:`, `wq!` (for vi)

29. Configure cloud init:
- `sudo vi /etc/cloud/cloud.cfg`
- change the line `preserve_hostname: false` to `preserve_hostname: true`
- save the changes and exit the editor - `CTRL+[` , `SHIFT+:`, `wq!` (for vi)

30. Configure the virtual machine's NIC with a static ip address
- `sudo vi /etc/netplan/00-installer-config.yaml`
- change the contents of the file to:
```
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens160:
      addresses:
      - 192.168.123.45/22
      gateway4: 192.168.123.1
      nameservers:
        addresses:
        - 192.168.123.2
        search:
        - lab.myorg.com
  version: 2
```
- **NOTE** change the IP addresses to those that are appropriate to your network, the last octet for the gateway ip address is usually one, the main IP address is always in CIDR  format
- save the changes and exit the edit - CTRL+[ , SHIFT+:, wq! in te vi editor
- Check that your changes are correct by issuing `sudo netplan apply`

31. On the main machine that will be used to drive the creation of the Kubenetes cluster whilst logged in as azuser create a ssh public/private key pair:
- `ssh-keygen`
- you will be prompted for a password, for the purposes of simplicity use the same one that was used when azuser was specified during the guest OS installation for the template virtual machine
- copy the public key onto the template virtual machine: `ssh-copy-id azuser@192.168.123.45`, you will be prompted for the azuser password and confirmation as to whether you want the public
  key to be added to keystore for the template virtual machine, select te default option of yes

32. Log onto the template virtual machine and apply updates and upgrade the kernel - **if Ubuntu 18.04 is used**:
- `sudo apt-get update`
- `sudo apt-get upgrade`
- `sudo apt-get install --install-recommends linux-generic-hwe-18.04` 

33. Remove the NIC config for the virtual machine template, log into the template virtual machine:

`sudo mv /etc/netplan/00-installer-config.yaml ~/.`

34. Shutdown the template virtual machine:

`sudo shutdown now`

35. In VMware vCenter right click on the ubuntu-18.04-template virtual machine, select template and then the option to convert this to a template.

    **If the virtual machine is based on Ubuntu 20.10 or 21.10, perform the steps below before converting the virtual machine into a template**

# Additional Instructions for Ubuntu 20.10 and 21.10

1. Install the cgroup-lite package

`sudo apt-get install cgroup-lite`

2. Set the cgroup to V1 in the /etc/default/grub file 
```
GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=0"
```
3. Issue:

`sudo update-grub`

4. Rebuild initramfs

`sudo update-initramfs -u`

5. Reboot the virtual machine:

`sudo reboot`

6. Check that cgroup has been set to version V1:

`stat -c %T -f /sys/fs/cgroup`

this should return:

tmpfs

# Variables

The minimum set of variables that need to be configured consists of those with no default values.

| Name                        | Data type | Description / Notes                                             | Mandatory (Y/N) | Default Value         |
|-----------------------------|-----------|-----------------------------------------------------------------|-----------------|-----------------------|
| vsphere_dc                  | string    | VMware vSphere datacenter object name                           |        Y        | **No default value**  |     
| vsphere_cluster             | string    | VMware vSphere datacenter cluster name                          |        Y        | **No default value**  |
| vsphere_host                | string    | Server in the vSphere cluster that virtual machines will run on |        Y        | **No default value**  |
| vsphere_datastore           | string    | Datastore for virtual machine storage                           |        Y        | **No default value**  |
| vsphere_network             | string    | Virtulized network for use by virtual machines                  |        Y        | **No default value**  |
| vsphere_resource_pool       | string    | Resource pool that virtual machines are to be allocated to      |        Y        | **No default value**  |
| vm_template                 | string    | Template used for virtual machine creation                      |        Y        | ubuntu-18.04-template |
| vm_domain                   | string    |                                                                 |        Y        |                       |
| vm_linked_clone             | boolean   | Specifies whether a virtual machine shares disk(s) with a parent|        Y        | false                 |

The configuration information for the virtual machines created by this module is stored in the `virtual_machines` variable, specify this in a terraform.tfvars file as follows:
```
virtual_machines = {
  "bdc" = {
    "z-ca-bdc-control1" = {
      name          = "z-ca-bdc-control1"
      compute_node  = false
      ipv4_address  = "192.168.123.88"
      ipv4_netmask  = "22"
      ipv4_gateway  = "192.168.123.1"         
      dns_server    = "192.168.123.2"
      ram           = 8192
      logical_cpu   = 4 
      os_disk_size  = 120
      px_disk_size  = 0
    },
    "z-ca-bdc-control2" =  {
      name          = "z-ca-bdc-control2"
      compute_node  = false
      ipv4_address  = "192.168.123.89"
      ipv4_netmask  = "22"
      ipv4_gateway  = "192.168.123.1"
      dns_server    = "192.168.123.2"
      ram           = 8192
      logical_cpu   = 4
      os_disk_size  = 120
      px_disk_size  = 0
    },
    "z-ca-bdc-compute1" = {
      name          = "z-ca-bdc-compute1"
      compute_node  = true
      ipv4_address  = "192.168.123.90"
      ipv4_netmask  = "22"
      ipv4_gateway  = "192.168.123.1
      dns_server    = "192.168.123.2"
      ram           = 73728
      logical_cpu   = 12
      os_disk_size  = 120
      px_disk_size  = 120 
    },
    "z-ca-bdc-compute2" = {
      name          = "z-ca-bdc-compute2"         
      compute_node  = true
      ipv4_address  = "192.168.123.91
      ipv4_netmask  = "22
      ipv4_gateway  = "192.168.123.1"
      dns_server    = "192.168.123.2"
      ram           = 73728
      logical_cpu   = 12
      os_disk_size  = 120
      px_disk_size  = 120
    },
    "z-ca-bdc-compute3" = {
      name          = "z-ca-bdc-compute3"
      compute_node  = true
      ipv4_address  = "192.168.123.92"         
      ipv4_netmask  = "22"
      ipv4_gateway  = "192.168.123.1"
      dns_server    = "192.168.123.2"
      ram           = 73728 
      logical_cpu   = 12
      os_disk_size  = 120
      px_disk_size  = 120
    }
  },
  "arc" = {
    .
    .
    .
  }
}
```
In addtion to these variables the following variables in the `variables.tf` to be found in the root of this repo also need to be set 

| Name                        | Data type | Description / Notes                                             | Mandatory (Y/N) | Default Value         |
|-----------------------------|-----------|-----------------------------------------------------------------|-----------------|-----------------------|
| vsphere_user                | string    | Name of user used to connect to VMware vSphere with             |        Y        | **No default value**  |     
| vsphere_server              | string    | VMware vSphere vCenter IP address                               |        Y        | **No default value**  |

**VSPHERE_PASSWORD** - the password for the user used to connect to vSphere vCenter with can be specified via the TF_VAR_VSPHERE_PASSWORD environment
variable, alternatively it can be specified when prompted for after issuing `terraform apply`

**Note**
- The compute node attribute should be set to true for virtual machine that host worker nodes, otherwise it should be set to false
- 120GB for the OS disk size was found to be the smallest size that could accomodated big data cluster container images, when configuring the guest OS, 
  half of this is allocated to the root filesystem, the rest is left free in reserve - a negligable overhead for datastores backed by thin provisioned
  storage 
- only assign the `px_disk_size` attribute a value for virtual machines that host worker nodes (`compute_node = true`)

# Known Issues / Limitations

None noted

[Back to root module](https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/README.md)

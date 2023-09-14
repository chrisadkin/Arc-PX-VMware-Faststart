# Overview

This module deploys a SQL Server 2019 Big Data Cluster to the target kubernetes cluster

# Usage

## Apply

Execute the following command from the `Arc-PX-VMware-Faststart/azure_data_services` directory
```
terraform apply -target=module.big_data_cluster --auto-approve 
```

## Destroy

Execute the following command from the `Arc-PX-VMware-Faststart/azure_data_services` directory
```
terraform destroy -target=module.big_data_cluster --auto-approve 
```

# Dependencies

- Context in .kube/config file of the home directory of the current user with which kubectl can connect to a kubernetes cluster
- A storage class present in the target kubernetes cluster that supports persistent volumes
- A kubernetes cluster with atleast one worker node with 64GB of memory and 8 logical processors, this excludes the resources requirements for portworx

# Variables

The minimum set of variables that need to be configured consists of those with no default values.

| Name                        | Data type | Description / Notes                                                 | Mandatory (Y/N) | Default Value                   |
|-----------------------------|-----------|---------------------------------------------------------------------|-----------------|---------------------------------|
| azdata_username             | string    |                                                                     |        Y        | azuser                          |     
| AZDATA_PASSWORD             | string    | Set via TF_VAR_AZDATA_PASSWORD environment variable                 |        Y        | **No default value**            |
| bdc_profile_dir             | string    | Directory where Big Data Cluster profile is to be created           |        Y        | ca_bdc                          | 
| bdc_name                    | string    | Big data cluster name                                               |        Y        | ca_bdc                          |
| bdc_storage_class           | string    | Big data cluster storage class                                      |        Y        | portworx-sc                     |

# Known Issues / Limitations

Destroy provisioner yet be implemented for the null resource that deploys the SQL Server 2019 Big Data Cluster. 

[Back to root module](https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/README.md)

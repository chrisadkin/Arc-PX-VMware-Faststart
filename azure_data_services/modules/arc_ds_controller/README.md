# Overview

This module deploys a controller using the kubectl_manifest provider for the February 2022 Azure Arc enabled Data Services release.

# Usage

## Apply

Execute the following command from the `Arc-PX-VMware-Faststart/azure_data_services` directory
```
terraform apply -target=module.arc_ds_controller --auto-approve 
```

## Destroy

Execute the following command from the `Arc-PX-VMware-Faststart/azure_data_services` directory
```
terraform destroy -target=module.arc_ds_controller --auto-approve 
```

# Dependencies

- Context in .kube/config file of the home directory of the current user with which kubectl can connect to a kubernetes cluster
- An Azure account 
- Storage class present on the kubernetes cluster deployment target
- Azure security token present in .azure of the home directory of the current user, create by using `az login`

# Variables

The following variable values should be specified in a ```terraform.tfvars``` file in the ```azure_data_services``` directory:

| Name                        | Data type | Description / Notes                                                 | Mandatory (Y/N) | Default Value        |      
|-----------------------------|-----------|---------------------------------------------------------------------|-----------------|----------------------|
| namespace                   | string    | Kubernetess namespace controller is to be deployed to               |        Y        | arc                  |
| metrics_ui_admin_user       | string    | base64 encoded username for the metrics UI                          |        Y        | **No default value** |
| metrics_ui_admin_password   | string    | base64 encoded password for the metrics UI                          |        Y        | **No default value** |
| logs_ui_admin_user          | string    | base64 encoded username for the logs UI                             |        Y        | **No default value** |
| logs_ui_admin_password      | string    | base64 encoded password for the logs UI                             |        Y        | **No default value** |
| connectivity_mode           | string    | Determines whether telemetry is uploaded to Azure                   |        Y        | indirect             |
| subscription_id             | string    | Azure subscription id                                               |        Y        | **No default value** |           
| resource_group              | string    | Controller Azure resource group                                     |        Y        | arc-ds-controller    |
| azure_region                | string    | Location where controller resource metadata will be stored in Azure |        Y        | eastus               | 
| data_storage_class          | string    | Storage class for data                                              |        Y        | portworx-sc          | 
| logs_storage_class          | string    | Storage class for logs                                              |        Y        | portworx-sc          |

# Known Issues / Limitations

Destroy provisioner yet be implemented for the null resource that calls azdata in order to create the controller. 

[Back to root module](https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/README.md)

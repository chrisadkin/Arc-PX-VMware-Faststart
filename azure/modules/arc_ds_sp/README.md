# Overview

This module:
- Creates an Azure service principal and role assignment for the Azure Arc Enabled Data Service controller
- Deploys a controller via calls to the azdata CLI, if a configuration directory already exists with the same name as that specified by the arc_data_profile_dir 
  varaible, the module will rename the current profile directory by appending the date and time to the end of its name

# Usage

## Apply

Execute the following command from the `Arc-PX-VMware-Faststart/azure_data_services` directory
```
terraform apply -target=module.azure_arc_ds_controller --auto-approve 
```

## Destroy

Execute the following command from the `Arc-PX-VMware-Faststart/azure_data_services` directory
```
terraform destroy -target=module.azure_arc_ds_controller --auto-approve 

# Dependencies

- Context in .kube/config file of the home directory of the current user with which kubectl can connect to a kubernetes cluster
- An Azure account 
- Storage class present on the kubernetes cluster deployment target
- Azure security token present in .azure of the home directory of the current user, create by using `az login`

# Variables

The minimum set of variables that need to be configured consists of those with no default values.

| Name                        | Data type | Description / Notes                                                 | Mandatory (Y/N) | Default Value                   |
|-----------------------------|-----------|---------------------------------------------------------------------|-----------------|---------------------------------|
| azdata_username             | string    |                                                                     |        Y        | azuser                          |     
| AZDATA_PASSWORD             | string    | Set via TF_VAR_AZDATA_PASSWORD environment variable                 |        Y        | **No default value**            |
| arc_data_namespace          | string    | Kubernetess namespace controller is to be deployed to               |        Y        | arc-ds-controller               |
| arc_data_connectivity_mode  | string    | Determines whether telemetry is uploaded to Azure                   |        Y        | direct                          |
| arc_data_az_subscription_id | string    | Azure subscription id                                               |        Y        | **No default value**            |
| arc_data_resource_group     | string    | Controller Azure resource group                                     |        Y        | arc-ds-rg                       |
| arc_data_az_location        | string    | Location where controller resource metadata will be stored in Azure |        Y        | eastus                          |
| arc_data_profile_dir        | string    | Directory where Azure Arc enabled Data Services profile is created  |        Y        | ca_arc                          | 
| arc_data_storage_class      | string    | Storage class for data                                              |        Y        | portworx-sc                     |
| arc_logs_storage_class      | string    | Storage class for logs                                              |        Y        | portworx-sc                     |
| application_name            | string    | Azure Arc enabled Data Services                                     |        Y        | Azure Arc enabled Data Services |
| password_length             | integer   | Length of password to create for service principal                  |        Y        | 16                              |
| password_special            | boolean   |                                                                     |        Y        | true                            |
| password_override_special   | string    |                                                                     |        Y        | \_\%\@                          | 

# Known Issues / Limitations

Destroy provisioner yet be implemented for the null resource that calls azdata in order to create the controller. 

[Back to root module](https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/README.md)

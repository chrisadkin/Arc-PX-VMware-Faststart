# Overview

This module deploys Portworx PX Backup and Azure objects: service principal, storage account and container neccessary for backing up kubernetes cluster objects to the 
Azure cloud.

# Usage

## Apply

Execute the following command from the `Arc-PX-VMware-Faststart/kubernetes` directory
```
terraform apply -target=module.px_backup --auto-approve 
```

## Destroy

```
terraform destroy -target=module.px_backup --auto-approve 
```

# Dependencies

- Azure subscription
- An on-premises kubernetes cluster to deploy PX Backup to
- The target cluster that px-backup is deployed to must have a load balancer, this module
  has successfully been tested with metallb 

# Portworx Spec Creation

# Variables

The minimum set of variables that need to be configured consists of those with no default values.

| Name                          | Data type | Description / Notes                                                 | Mandatory (Y/N) | Default Value                   |
|-------------------------------|-----------|---------------------------------------------------------------------|-----------------|---------------------------------|
| helm_chart_version            | string    | PX Backup helm chart version to be deployed                         |        Y        | 1.2.2                           |
| storage_class                 | string    | Store class to use for PX Backup metadata state                     |        Y        | portworx-sc                     |
| namespace                     | string    | Namespace to create PX Backup objects in                            |        Y        | px-backup                       |
| azure_subscription_id         | string    | Azure subscription to use for when creating Azure objects           |        Y        | **No default value**            |
| azure_resource_group          | string    | Resource group to associate Azure objects with                      |        Y        | px-backup-rg                    |
| azure_location                | string    | Azure location to create Azure objects in                           |        Y        | uksouth                         | 
| azure_storage_account_name    | string    | Name to give Azure storage account                                  |        Y        | portworxpxbackup                |
| azure_storage_account_tier    | string    | Azure storage tier to use                                           |        Y        | Standard                        |
| azure_storage_data_redundancy | string    | Azure storage redundancy                                            |        Y        | LRS                             |
| azure_storage_blob_container  | string    | Name to create Azure blob container with                            |        Y        | pxbackup                        |
| application_name              | string    | Application name to create for PX Backup in Azure Ad                |        Y        | portworx_px_backup              |
| password_length               | number    | Length of password to create for Azure Ad principal                 |        Y        | 16                              |
| password_special              | string    | Special characters to use for principal password                    |        Y        | \_\%\@                          |            | password_override_special     | boolean   | Override for use of supplied special characters for password        |        Y        | true                            |

# Example

This walkthough covers the full installation of PX Backup via this module and its use to backup and resdtore a SQL Server 2019 Big Data Cluster storage pool.

**Please note the following:**
- The entire process outlined in the following steps can be scripted
- When restoring persistent volume claims, which restores their underlying volumes when using PX Backup over existing objects, the parent statefulset or replicaset **has**
  to be scaled down to zero replicas first, otherwise this will result in persistent volume claims in a state of terminating
- PX Backup will work with any third party kubernetes storage plugin that supports snapshots in adherance to the **C**ontainer **S**torage **I**nterface standard
- The oldest version of kubernetes that supports CSI snapshots is 1.12, for versions prior to 1.17 - snapshots need to be enabled by enabling a feature gate as per the
  [Kubernetes CSI documentation](https://kubernetes-csi.github.io/docs/snapshot-restore-feature.html).
- PX Backup supports the following backup destinations:
  - S3 in AWS
  - S3 for on-premises storage
  - Azure blob storage
  - S3 storage in GCP

1. Modify the values in the `Arc-PX-VMware-Faststart/kubernetes/modules/px_backup/variables.tf` file as appropriate and then run:
```
terraform apply -target=module.px_backup --auto-approve 
```
   When this has completed it will display information required later for the configuration of Azure as a backup location, **make a note of this information** as it is
   required in order to configure Azure as a backup destination later on
```
Outputs:

client_id = "a12bcde3-f456-789g-12h3-4ij56lm78no9"
client_secret = "XVMk1iqnrFWly6cj"
tenant_id = "1a2b3456-c78d-9123-efgh-456789i123jk"
subscription_id = "/subscriptions/fg9z3eca-e3bb-7581-86e9-xz9f675f927w"
```

2. Once the module has been successfully applied, assuming the namespace used is `px-backup`, issue:
```
kubectl get po -n px-backup
```
   The state of the PX Backup pods should appear as follows:
```
NAME                                       READY   STATUS      RESTARTS   AGE
px-backup-7947f877fd-7cktf                 1/1     Running     2          7m43s
pxc-backup-etcd-0                          1/1     Running     0          7m43s
pxc-backup-etcd-1                          1/1     Running     0          7m43s
pxc-backup-etcd-2                          1/1     Running     0          7m43s
pxcentral-apiserver-5d55fd855c-5rvr4       1/1     Running     0          7m43s
pxcentral-backend-849c9c8579-flrxk         1/1     Running     0          6m18s
pxcentral-frontend-6866f4646-mf78t         1/1     Running     0          6m18s
pxcentral-keycloak-0                       1/1     Running     0          7m43s
pxcentral-keycloak-postgresql-0            1/1     Running     0          7m43s
pxcentral-lh-middleware-58f95d767d-nn8qb   1/1     Running     0          6m18s
pxcentral-mysql-0                          1/1     Running     0          7m43s
pxcentral-post-install-hook-2fkws          0/1     Completed   0          7m43s
```
2. Issue the following command from a machine capable of supporting a web browser:
```
kubectl port-forward service/px-backup-ui 8080:80 --namespace px-backup
```
  **Note**
  If you have not already setup a connection context on this machine, copy the config file from the .kube directory of the machine that you run
  terraform commands from, e.g.
```
  scp azuser@<hostname>:/home/azuser/.kube/config C:\Users\cadkin\.kube\config
```
3. Enter the following in the browser URL address bar enter:
```
localhost:8080
```
4. Enter `admin` for the username and `admin` for the password on the initial login screen, then hit enter

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb1.PNG?raw=true">

5. Enter a new password and confirm this as instructed:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb2.PNG?raw=true">

6. Update the user profile information to activate your account:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb3.PNG?raw=true">

7. Click on the **Add Cluster** button in the top right corner

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb4.PNG?raw=true">

8. Give the cluster a name (a label), browse to the `.kube/config` file containing the connection context for the cluster, otherwise run the `kubectl` command as advised and 
   paste the output into the Kubeconfig box, finally - hit **Submit**

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb5.PNG?raw=true">

9. Your kubernetes cluster should now be registered with PX Backup - called ca-bdc in this example:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb6.PNG?raw=true">

10. Click on **Settings** in the top right corner followed by **cloud settings** in order to make the cloud settings screen appear:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb7.PNG?raw=true">

11. Click on **Add** in the top right corner and select Azure from the Cloud provider list of values. You will now be presented with a screen prompting for Azure account
    information:
    
<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb8.PNG?raw=true">
    
-  **Cloud Account Name** - a user proivided label

-  **Azure Account Name** - the Azure storage account name assigned to the variable `azure_storage_account_name` in the variables.tf file

-  **Azure Account Key** - a key value associated with the Azure storage account

-  **Client Id** - Client Id returned from running `terraform apply` for the module

-  **Client Secret** - Client Secret (password) returned from running `terraform apply` for the module

-  **Tenant Id** - Azure terrant Id returned from running `terraform apply` for the module

-  **Subscription Id** - The subscription id of the Azure account that the storage account belongs to 

12. Add a backup location, the name that we want to give our Azure blob container in other words. In this particular instance the **cloud account** is
    named **px-backup-azure**, to add a backup location click on **Add** to the right of Backup Location:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb9.PNG?raw=true">

13. When the backup location details have been entered (no requirement to provide an encryption key), hit **Add**:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb10.PNG?raw=true">

14. We should now have a Cloud Account and Backup Location:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb12.PNG?raw=true">

15. Click on the Portworx symbol in the top left corner to go back to the main screen which lists the cluster that is configured to use PX Backup:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb11.PNG?raw=true">

16. Backups can be performed at various levels of granularity - ranging from the entire contents of a namespace down to specific object types. In this example, we
    will backup a Big Data Cluster storage pool, before doing this let us put some data in it by creating a simple text file:

```
echo "This is a backup test" > backup_test.txt
```

17. Log into the big data cluster, the following command will prompt for the big data cluster namespace, the username specified in `var.azdata_username` and finally the 
value that `var.AZDATA_PASSWORD` is set to:
```
azdata login
```

18. Copy the file into the storage pool, enter the value used for `var.AZDATA_PASSWORD` as the Knox password when prompted for it:
```
azdata bdc hdfs cp --from-path "./backup_test.txt" --to-path "hdfs:/user/azuser/backup_test.txt"
```

19. Log into the master pool SQL Server instance via Azure Data Studio in order to see the file that we have just loaded into the storage pool. The following connection
    details are required: 
- `compute-node-ip-address`,31433 for the instance
- SQL Server authentication with:
  - username specified in var.azdata_username
  - password specified in var.AZDATA_PASSWORD

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb13.PNG?raw=true">

20. Whilst still in Azure Data Studio, right click on the test_backup.txt file to verify that it contains the line of text that was placed in it back in step 16.

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb14.PNG?raw=true">

21. Return to the PX Backup UI, click on the name of your cluster, ca-bdc in this example:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb15.PNG?raw=true">

22. Select the namespace containing your big data cluster from the left most list of values under the application tab:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb16.PNG?raw=true">
 
23. From the middle list of values select `PersistentVolumeClaim` and select the following from the list of persistent volume claims:
- data-nmnode-0-0
- data-storage-0-0
- data-storage-0-1
- logs-nmnode-0-0
- logs-storage-0-0
- logs-storage-0-1

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb17.PNG?raw=true">

24. Click on the **backup** button in the top right hand corner, give the backup a name, select **azure-backup-loc** as the location, check the **Now** radio button and then
    **Create**:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb18.PNG?raw=true">

25. We should see the following once the backup is complete:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb19.PNG?raw=true">

26. Return to Azure Data Studio, right click on the backup_test.txt file, select delete and then confirm that you wish to do this.

27. Obtain the names of the name node and storage pool `satefulsets` using this command:
```
kubectl get statefulset -n ca-bdc | egrep '(nmnode|storage)'
```
    
28. Two `statefulsets` are returned:
```
nmnode-0    1/1     6h19m
storage-0   2/2     6h19m
```
   Scale these down to zero using the following commands:
```
kubectl scale statefulsets nmnode-0 --replicas=0 -n ca-bdc
kubectl scale statefulsets storage-0 --replicas=0 -n ca-bdc
```
   As before, substitute ca-bdc for the name of the namespace containing your big data cluster.
   
29. Return to the PX Backup UI:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb19.PNG?raw=true">
  
30. Click on the backup to obtain more in-depth details for the backup:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb20.PNG?raw=true">

31. On the screen above - hit **Restore backup**, give the restore a name, select the namespace containing the big data cluster, ca-bdc in this example, check the
    **Replace existing objects** box and finally hit the **restore** button:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb21.PNG?raw=true">

32. Once the restore has successfuly completed, you should be met with this screen:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/images/px_backup/pb22.PNG?raw=true">

33. Scale the `statefulsets` back to their original replica values:
```
kubectl scale statefulsets nmnode-0 --replicas=1 -n ca-bdc
kubectl scale statefulsets storage-0 --replicas=2 -n ca-bdc
```

34. If you now return to Azure Data Studio, the backup_test.txt file should be back.

# Known Issues / Limitations

None noted.

[Back to root module](https://github.com/PureStorage-OpenConnect/arc-px-vmware-faststart/blob/main/README.md)

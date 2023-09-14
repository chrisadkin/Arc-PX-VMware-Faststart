# Overview

This module deploys metallb - a free opensource software load balancer to a Kubernetes cluster

# Usage

## Apply

If a workspace has not aleady been created, create one:
```
terraform workspace create <workspace_name>
```
Otherwise, if a workspace *has* already been created, select it:
```
terraform workspace select <workspace_name>
```
Execute the following command from the `Arc-PX-VMware-Faststart/kubernetes` directory
```
terraform apply -target=module.metallb --auto-approve 
```

## Destroy

```
terraform workspace select <workspace_name>
terraform destroy -target=module.px_metallb --auto-approve 
```

# Dependencies

- A Kubernetes cluster version 1.13 or above 

# Portworx Spec Creation

# Variables

The minimum set of variables that need to be configured consists of those with no default values.

| Name                          | Data type | Description / Notes                                     | Mandatory (Y/N) | Default Value               |
|-------------------------------|-----------|---------------------------------------------------------|-----------------|-----------------------------|
| helm_chart_version            | string    | Version of the metallb bitname Helm chart, refer to the following [page](https://bitnami.com/stack/metallb/helm) for the version of the latest chart. |        Y        | 0.9.5                       | 
| ip_range_lower_boundary       | string    | Lowest IP address of the range of addresses available for metallb to assign to services. |        Y        | N/A       |                               |           |                       |                 |                             |
| ip_range_upper_boundary       | string    | Highest IP address of the range of addresses available for metallb to assign to services.  |        Y        | N/A                         |

MetalLB requires a pool of IP addresses available outside of the Kubernetes cluster, this should be sufficiently large to cater for each LoadBalancer service.

# Testing

This repo comes with a manifest to deploy nginx as follows:
```
kubectl apply -f nginx-deployment.yaml
```
If MetalLB has been deployed successfully, when:
```
kubectl get service
```
is issued the nginx service shuld have an external IP address.

# Known Issues / Limitations

None noted.

[Back to root module](https://github.com/chrisadkin/arc-px-vmware-faststart/blob/main/README.md)

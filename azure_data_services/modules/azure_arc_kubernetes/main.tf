provider "azurerm" {
  features {}
}

resource "azurerm_resource_provider_registration" "kubernetes" {
  count = 0
  name = "Microsoft.Kubernetes"
}

resource "azurerm_resource_provider_registration" "kubernetes_configuration" {
  count = 0
  name = "Microsoft.KubernetesConfiguration"
}

resource "azurerm_resource_provider_registration" "extended_location" {
  count = 0
  name = "Microsoft.ExtendedLocation"
}

resource "azurerm_resource_group" "arc_kubernetes_rg" {
  name     = var.resource_group
  location = var.azure_region
}

resource "null_resource" "arc_connectedk8s" {
  provisioner "local-exec" {
     command = <<EOF
       az connectedk8s connect --name $CN --resource-group $RG
       az connectedk8s list --resource-group $RG --output table
     EOF

     environment = {
       CN = var.cluster_name
       RG = var.resource_group
     }
  }

  provisioner "local-exec" {
     when    = destroy
     command = "helm delete azure-arc --no-hooks"
  }

  depends_on = [
     azurerm_resource_group.arc_kubernetes_rg
  ]
}

resource "null_resource" "az_extension" {
  provisioner "local-exec" {
     command = <<EOF
       az extension add --name connectedk8s
       az extension add --name k8s-extension
       az extension add --name customlocation
       az extension update --name connectedk8s
       az extension update --name k8s-extension
       az extension update --name customlocation
     EOF
  }
}

resource "null_resource" "connectedk8s_location" {
  count = 0
  provisioner "local-exec" {
     command = <<EOF
       az connectedk8s enable-features -n $CN -g $RG --features cluster-connect custom-locations
       az k8s-extension create --name $EI --extension-type microsoft.arcdataservices --cluster-type connectedClusters -c $CN -g $RG --scope cluster \
       --release-namespace $NS --config Microsoft.CustomLocation.ServiceAccount=sa-bootstrapper

       az customlocation create -n $LN -g $RG --namespace $NS \
       --host-resource-id $(az connectedk8s show -n $CN -g $RG --query id -o tsv) \
       --cluster-extension-ids $(az k8s-extension show --name $EI --cluster-type connectedClusters -c $CN -g $RG --query id -o tsv)
     EOF

     environment = {
       CN = var.cluster_name
       RG = var.resource_group
       NS = var.arc_data_namespace
       EI = var.extension_instance
       LN = var.location_name
     }
  }

  depends_on = [
     null_resource.az_extension
    ,null_resource.arc_connectedk8s 
  ]
}


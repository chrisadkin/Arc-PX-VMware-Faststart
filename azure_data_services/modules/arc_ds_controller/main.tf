terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }

  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "controller_namespace" {
  metadata {
    name = var.namespace
  }

  depends_on = [  kubectl_manifest.datacontrollers
                 ,kubectl_manifest.postgresqls
                 ,kubectl_manifest.sqlmanagedinstances
                 ,kubectl_manifest.sqlmanagedinstancerestoretasks
                 ,kubectl_manifest.exporttasks
                 ,kubectl_manifest.monitors
                 ,kubectl_manifest.dags
                 ,kubectl_manifest.activedirectoryconnectors
               ]
}

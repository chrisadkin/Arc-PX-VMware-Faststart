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

resource "kubernetes_secret" "arc_sql_mi_login_secret" {
  metadata {
    name = "${var.instance_name}-login-secret"
    namespace = var.namespace 
  }

  data = {
    username = var.secret_username
    password = var.secret_password
  }
}

resource "kubectl_manifest" "arc_sql_mi" {
  wait = true
  yaml_body = <<YAML
apiVersion: sql.arcdata.microsoft.com/v1
kind: SqlManagedInstance
metadata:
  name: ${var.instance_name} 
  namespace: ${var.namespace}
spec:
  scheduling:
    default:
      resources:
        limits:
          cpu: ${var.cpu_limit}
          memory: ${var.memory_limit} 
        requests:
          cpu: ${var.cpu_request}
          memory: ${var.memory_request} 
  services:
    primary:
      type: ${var.service_type}
  storage:
    backups:
      volumes:
      - className: ${var.backups_storage_class}
        size: ${var.volume_size_backups}
    data:
      volumes:
      - className: ${var.data_storage_class}
        size: ${var.volume_size_data} 
    datalogs:
      volumes:
      - className: ${var.data_logs_storage_class}
        size: ${var.volume_size_data_logs} 
    logs:
      volumes:
      - className: ${var.logs_storage_class}
        size: ${var.volume_size_logs}
YAML

  provisioner "local-exec" {
    command =<<EOF
      until [ $(kubectl get sqlmanagedinstances -n ${var.namespace} | grep ${var.instance_name} | egrep '(Ready|Error)' | wc -l) -eq 1 ]; do
        echo " "
        echo "Waiting for Azure Arc Managed SQL Server instance to deploy"
        echo " "
        kubectl get sqlmanagedinstances -n ${var.namespace} | grep ${var.instance_name}
        echo " "
        kubectl get all -n ${var.namespace} | grep ${var.instance_name} 
        sleep 20
      done
    EOF
  }

  depends_on = [
    kubernetes_secret.arc_sql_mi_login_secret
  ]
}

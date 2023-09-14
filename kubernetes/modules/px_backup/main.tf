resource "kubernetes_namespace" "px_backup" {
  metadata {
    name = var.namespace 
  }
}

resource "helm_release" "px_backup" {
  name       = "px-central"
  repository = "http://charts.portworx.io"
  chart      = "px-central"
  namespace  = kubernetes_namespace.px_backup.metadata.0.name

  set {
    name  = "version"
    value = var.helm_chart_version
  }

  set {
    name  = "persistentStorage.enabled"
    value = true 
  }

  set {
    name  = "persistentStorage.storageClassName"
    value = var.storage_class 
  }

  set {
    name  = "pxbackup.enabled"
    value = true 
  }

  depends_on = [
    kubernetes_namespace.px_backup
  ]
}

resource "null_resource" "pxbackupctl" {
  provisioner "local-exec" {
    command = <<EOF
      alias BACKUP_POD='kubectl get pods -n px-backup -l app=px-backup -o jsonpath='{.items[0].metadata.name}' 2>/dev/null'
      sudo kubectl cp -n $NS $(BACKUP_POD):pxbackupctl/linux/pxbackupctl /usr/local/bin/pxbackupctl
      sudo chmod 775 /usr/local/bin/pxbackupctl 
    EOF

    environment = {
      NS = var.namespace
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "sudo rm -rf /usr/local/bin/pxbackupctl"
  }

  depends_on = [
    helm_release.px_backup
  ]
}

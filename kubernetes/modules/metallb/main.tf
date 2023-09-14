resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"
  }
}

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metallb"
  namespace  = kubernetes_namespace.metallb_system.metadata.0.name

  set {
    name  = "version"
    value = "my-release" 
  }

  provisioner "local-exec" {
    command = "kubectl delete configmap metallb-config -n metallb-system"
  }

  depends_on = [
    kubernetes_namespace.metallb_system
  ]
}

resource "kubernetes_config_map" "layer2_configuration" {
  metadata {
    name      = "metallb-config"
    namespace = "metallb-system"
  }

  data = {
    config = templatefile("${path.module}/templates/layer2_configuration.yaml.tpl", {
               ip_range_lower_boundary = var.ip_pool_ranges[terraform.workspace].ip_range_lower_boundary
               ip_range_upper_boundary = var.ip_pool_ranges[terraform.workspace].ip_range_upper_boundary
             })
  }

  depends_on = [
    helm_release.metallb 
  ]
}

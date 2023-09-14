resource "kubectl_manifest" "sa_arc_controller" {
  wait = true
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sa-arc-controller
YAML

  depends_on = [ kubectl_manifest.sa_arc_webhook_job ]
}

resource "time_sleep" "wait_5_seconds" {
  create_duration = "5s"

  depends_on = [ kubectl_manifest.sa_arc_controller ]
}

resource "kubectl_manifest" "arc_dc" {
  wait = true
  yaml_body = <<YAML
apiVersion: arcdata.microsoft.com/v3
kind: DataController
metadata:
  generation: 1
  name: arc-dc
  namespace: ${var.namespace}
spec:
  credentials:
    controllerAdmin: controller-login-secret
    dockerRegistry: arc-private-registry
    serviceAccount: sa-arc-controller
  docker:
    imagePullPolicy: Always
    imageTag: v1.4.0_2022-02-25
    registry: mcr.microsoft.com
    repository: arcdata
  infrastructure: ${var.infrastructure} 
  security:
    allowDumps: true
    allowNodeMetricsCollection: true
    allowPodMetricsCollection: true
  services:
  - name: controller
    port: 30080
    serviceType: ${var.service_type} 
  settings:
    ElasticSearch:
      vm.max_map_count: "-1"
    azure:
      connectionMode: ${var.connection_mode} 
      location: ${var.azure_region}
      resourceGroup: ${var.resource_group} 
      subscription: ${var.subscription_id} 
    controller:
      displayName: arc-dc
      enableBilling: true
      logs.rotation.days: "7"
      logs.rotation.size: "5000"
  storage:
    data:
      accessMode: ReadWriteOnce
      className: ${var.data_storage_class} 
      size: 15Gi
    logs:
      accessMode: ReadWriteOnce
      className: ${var.logs_storage_class} 
      size: 10Gi
YAML

  depends_on = [
    time_sleep.wait_5_seconds 
  ]
}


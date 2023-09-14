resource "time_sleep" "wait_15_seconds" {
  create_duration = "15s"

  depends_on = [ kubectl_manifest.bootstrapper ]
}

resource "kubectl_manifest" "cr_arc_webhook_job" {
  wait = true
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cr-arc-webhook-job
rules:
- apiGroups: ["admissionregistration.k8s.io"]
  resources: ["mutatingwebhookconfigurations"]
  resourceNames: ["arcdata.microsoft.com-webhook-${var.namespace}"]
  verbs: ["get","delete"]
- apiGroups: ["admissionregistration.k8s.io"]
  resources: ["mutatingwebhookconfigurations"]
  verbs: ["create"]
- apiGroups: ["*"]
  resources: ["namespaces"]
  resourceNames: ["${var.namespace}"]
  verbs: ["patch"]
YAML

  depends_on = [ time_sleep.wait_15_seconds ]
}

resource "kubectl_manifest" "crb_arc_webhook_job" {
  wait = true
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
   name: crb-arc-webhook-job
subjects:
 - kind: ServiceAccount
   name: sa-arc-webhook-job
   namespace: ${var.namespace}
roleRef:
   kind: ClusterRole
   name: cr-arc-webhook-job
   apiGroup: rbac.authorization.k8s.io
YAML
  
  depends_on = [ kubectl_manifest.cr_arc_webhook_job ]
}

resource "kubectl_manifest" "cr_arc_dc_watch" {
  wait = true
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ${var.namespace}:cr-arc-dc-watch
rules:
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - "watch"
YAML

  depends_on = [ kubectl_manifest.cr_arc_webhook_job ]
}

resource "kubectl_manifest" "crb_arc_dc_watch" {
  wait = true
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${var.namespace}:crb-arc-dc-watch
subjects:
 - kind: ServiceAccount
   name: sa-arc-controller
   namespace: ${var.namespace}
roleRef:
   kind: ClusterRole
   name: ${var.namespace}:cr-arc-dc-watch
   apiGroup: rbac.authorization.k8s.io
YAML

  depends_on = [ kubectl_manifest.cr_arc_dc_watch ]
}

resource "kubectl_manifest" "role_arc_webhook_job" {
  wait = true
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-arc-webhook-job
  namespace: ${var.namespace}
rules:
- apiGroups: ["*"]
  resources: ["secrets"]
  verbs: ["create"]
- apiGroups: ["*"]
  resources: ["secrets"]
  resourceNames: ["arc-webhook-secret"]
  verbs: ["get"]
- apiGroups: ["*"]
  resources: ["secrets"]
  resourceNames: ["arc-webhook-secret"]
  verbs: ["delete"]
- apiGroups: ["batch"]
  resources: ["jobs"]
  resourceNames: ["arc-webhook-job"]
  verbs: ["delete"]
- apiGroups: ["batch"]
  resources: ["jobs"]
  verbs: ["create"]
YAML

  depends_on = [ kubectl_manifest.crb_arc_dc_watch ]
}

resource "kubectl_manifest" "rb_arc_webhook_job" {
  wait = true
  yaml_body = <<YAML
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
   name: rb-arc-webhook-job
   namespace: ${var.namespace}
subjects:
 - kind: ServiceAccount
   name: sa-arc-webhook-job
   namespace: ${var.namespace}
roleRef:
   kind: Role
   name: role-arc-webhook-job
   apiGroup: rbac.authorization.k8s.io
YAML

  depends_on = [ kubectl_manifest.role_arc_webhook_job ]
}

resource "kubectl_manifest" "arc_webhook_job" {
  wait = true
  yaml_body = <<YAML
apiVersion: batch/v1
kind: Job
metadata:
  name: arc-webhook-job
spec:
  template:
    spec:
      imagePullSecrets:
      - name: arc-private-registry
      containers:
      - name: bootstrapper
        image: mcr.microsoft.com/arcdata/arc-bootstrapper:v1.4.0_2022-02-25
        command: ["/opt/webhook/create-and-deploy-webhook.sh",  "${var.namespace}", "arc-webhook-job"]
      restartPolicy: Never
      serviceAccountName: sa-arc-webhook-job
  backoffLimit: 4
YAML

  depends_on = [ kubectl_manifest.rb_arc_webhook_job ]
}

resource "kubectl_manifest" "sa_arc_webhook_job" {
  wait = true
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sa-arc-webhook-job
YAML

  depends_on = [ kubectl_manifest.arc_webhook_job ]
}

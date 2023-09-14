resource "kubectl_manifest" "sa_arc_bootstrapper" {
  wait = true
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sa-arc-bootstrapper
  namespace: ${var.namespace}
YAML

  depends_on = [ kubernetes_namespace.controller_namespace ]
}

resource "kubectl_manifest" "role_bootstrapper" {
  wait = true
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-bootstrapper
  namespace: ${var.namespace}
rules:
- apiGroups: [""]
  resources: ["pods", "configmaps", "services", "persistentvolumeclaims", "secrets", "serviceaccounts", "events"]
  verbs: ["*"]
- apiGroups: ["apps"]
  resources: ["replicasets", "statefulsets"]
  verbs: ["*"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["roles", "rolebindings"]
  verbs: ["*"]
- apiGroups: ["sql.arcdata.microsoft.com", "tasks.sql.arcdata.microsoft.com", "tasks.arcdata.microsoft.com", "arcdata.microsoft.com"]
  resources: ["*"]
  verbs: ["*"]
YAML

  depends_on = [ kubectl_manifest.sa_arc_bootstrapper ]
}

resource "kubectl_manifest" "rb_bootstrapper" {
  wait = true
  yaml_body = <<YAML
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rb-bootstrapper
  namespace: ${var.namespace}
subjects:
- kind: ServiceAccount
  name: sa-arc-bootstrapper
roleRef:
  kind: Role
  name: role-bootstrapper
  apiGroup: rbac.authorization.k8s.io
YAML

  depends_on = [ kubectl_manifest.role_bootstrapper ]
}

resource "kubectl_manifest" "bootstrapper" {
  wait = true
  yaml_body = <<YAML
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: bootstrapper
  namespace: ${var.namespace}
  labels:
    app: bootstrapper
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bootstrapper
  template:
    metadata:
      labels:
        app: bootstrapper
    spec:
      serviceAccountName: sa-arc-bootstrapper
      securityContext:
        fsGroup: 1000700001
      imagePullSecrets:
      - name: arc-private-registry
      nodeSelector:
        kubernetes.io/os: linux
      containers:
      - name: bootstrapper
        image: mcr.microsoft.com/arcdata/arc-bootstrapper:v1.4.0_2022-02-25
        imagePullPolicy: Always
        resources:
          limits:
            cpu: 200m
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 100Mi
        securityContext:
          runAsUser: 1000700001
          runAsGroup: 1000700001
YAML

  depends_on = [ kubectl_manifest.rb_bootstrapper ]
}

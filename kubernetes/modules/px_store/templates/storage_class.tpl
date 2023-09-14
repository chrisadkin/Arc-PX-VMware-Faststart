kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: portworx-sc
provisioner: ${provisioner} 
parameters:
  repl: "${px_repl_factor}"

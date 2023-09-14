resource "null_resource" "portworx" {
  provisioner "local-exec" {
    command =<<EOF
      kubectl apply -f $PX_SPEC
      until [ $(kubectl get po -n kube-system | egrep '(stork|px|portworx)' | \
                    awk '{ s += substr($2,1,1); t +=substr($2,3,1) } END { print s - t}') -eq 0 ]; do
        echo "."
        echo "Waiting for Portworx PX-Store pods to be ready"
        echo "."
        kubectl get po -n kube-system | egrep '(stork|px|portworx)'
        sleep 10
      done
      echo " "
      PX_POD=$(kubectl get pods -l name=portworx -n kube-system -o jsonpath='{.items[0].metadata.name}')
      kubectl exec $PX_POD -n kube-system -- /opt/pwx/bin/pxctl status
    EOF

    environment = {
      PX_SPEC = var.px_spec
    }
  }

  provisioner "local-exec" {
    command=<<EOF
      curl -fsL https://install.portworx.com/px-wipe | bash
      kubectl label nodes --all px/enabled=remove --overwrite
      until [ $(kubectl get po -n kube-system | egrep '(stork|px|portworx)' | wc -l) -eq 0 ]; do
        echo "."
        echo "Waiting for Portworx PX-Store pods to be destroyed"
        echo "."
        kubectl get po -n kube-system | egrep '(stork|px|portworx)'
        sleep 10
      done
      echo " "
      kubectl delete -f "https://install.portworx.com?ctl=true&kbver=$(kubectl version --short | awk -Fv '/Server Version: /{print $3}')"
      kubectl label nodes --all px/enabled-
    EOF
    when = destroy
  }
}

resource "null_resource" "kubernetes_scheduler" {
  count = var.use_stork ? 1 : 0
  provisioner "local-exec" {
    command = <<EOF
      kubectl get deployment stork -n kube-system -o yaml | perl -pe "s/--webhook-controller=false/--webhook-controller=true/g" | kubectl apply -f -
    EOF
  }
  depends_on = [
    null_resource.portworx
  ]
}

resource "local_file" "storage_class_spec" {
  content = templatefile("${path.module}/templates/storage_class.tpl", {
    provisioner = var.use_csi ? "pxd.portworx.com" : "kubernetes.io/portworx-volume"
    px_repl_factor = var.px_repl_factor
  })
  filename = "storage-class.yml" 

  depends_on = [
    null_resource.kubernetes_scheduler
  ]
}

resource "null_resource" "storage_class" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./storage-class.yml"
  }

  depends_on = [
    local_file.storage_class_spec 
  ]
}

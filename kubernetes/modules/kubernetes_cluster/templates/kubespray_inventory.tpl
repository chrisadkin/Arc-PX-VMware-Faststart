[all]
${k8s_node_host_verbose_etcd}
${k8s_node_host_verbose}

[kube-master]
${k8s_master_host}

[etcd]
${k8s_etcd_host}

[kube-node]
${k8s_node_host}

[calico-rr]

[k8s-cluster:children]
kube-master
kube-node
calico-rr

resource "null_resource" "post_install_k8s" {
  count = "${var.count}"

  triggers {
    trigger = "${element(var.triggers, count.index)}"
  }

  connection {
    host         = "${element(var.ipv4_addrs, count.index)}"
    user         = "${var.ssh_user}"
    bastion_host = "${var.ssh_bastion_host}"
    bastion_user = "${var.ssh_bastion_user}"
  }

  provisioner "remote-exec" {
    inline = ["mkdir -p /tmp/install-k8s"]
  }

  provisioner "file" {
    source      = "${path.module}/"
    destination = "/tmp/install-k8s"
  }

  provisioner "remote-exec" {
    inline = <<EOF
/bin/bash /tmp/install-k8s/install-k8s \
  --k8s-version ${var.k8s_version} \
  --calico-node-version ${var.calico_node_version} \
  --calico-cni-version ${var.calico_cni_version} \
  --flannel-version ${var.flannel_version} \
  --cni-plugins-version ${var.k8s_cni_plugins_version} \
  --sha1sum-cni-plugins ${var.k8s_sha1sum_cni_plugins} \
  --sha1sum-kubeadm ${var.k8s_sha1sum_kubeadm} \
  --sha1sum-kubelet ${var.k8s_sha1sum_kubelet} \
  --sha1sum-kubectl ${var.k8s_sha1sum_kubectl}
EOF
  }

  provisioner "remote-exec" {
    inline = "echo start customruncmd; sudo systemctl start customruncmd.service || true"
  }

  provisioner "remote-exec" {
    inline = "echo start k8s; sudo systemctl restart k8s-init.service || true"
  }

  provisioner "remote-exec" {
    inline = "echo start customruncmd; sudo systemctl start customruncmd.service || true"
  }
}

output "install_ids" {
  value = ["${null_resource.post_install_k8s.*.id}"]
}

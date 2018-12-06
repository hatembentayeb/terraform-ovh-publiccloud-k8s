variable "count" {
  description = "The number of resource to post provision"
  default     = 1
}

variable "ipv4_addrs" {
  type        = "list"
  description = "The list of IPv4 addrs to provision"
}

variable "triggers" {
  type        = "list"
  description = "The list of values which can trigger a provisionning"
}

variable "ssh_user" {
  description = "The ssh username of the image used to boot the k8s cluster."
  default     = "core"
}

variable "install_dir" {
  description = "Directory where to install k8s"
  default     = "/opt/k8s"
}

variable "ssh_bastion_host" {
  description = "The address of the bastion host used to post provision the k8s cluster. This may be required if `post_install_module` is set to `true`"
  default     = ""
}

variable "ssh_bastion_user" {
  description = "The ssh username of the bastion host used to post provision the k8s cluster. This may be required if `post_install_module` is set to `true`"
  default     = ""
}

variable "k8s_version" {
  description = "The version of k8s to install with the post installation script if `post_install_module` is set to true"
  default     = "1.12.3"
}

variable "calico_node_version" {
  description = "The version of calico_node to install with the post installation script if `post_install_module` is set to true"
  default     = "3.3.2"
}

variable "calico_cni_version" {
  description = "The version of calico_cni to install with the post installation script if `post_install_module` is set to true"
  default     = "3.3.2"
}

variable "flannel_version" {
  description = "The version of flannel to install with the post installation script if `post_install_module` is set to true"
  default     = "0.9.1"
}

variable "k8s_cni_plugins_version" {
  description = "The version of the cni plugins to install with the post installation script if `post_install_module` is set to true"
  default     = "0.7.1"
}

variable "k8s_sha1sum_cni_plugins" {
  description = "The sha1 checksum of the container cni plugins release to install with the post installation script if `post_install_module` is set to true"
  default     = "fb29e20401d3e9598a1d8e8d7992970a36de5e05"
}

variable "k8s_sha1sum_kubelet" {
  description = "The sha1 checksum of the k8s binary kubelet to install with the post installation script if `post_install_module` is set to true"
  default     = "7dfe9b7665a4e60feafbc320dcec39833e41837b"
}

variable "k8s_sha1sum_kubectl" {
  description = "The sha1 checksum of the k8s binary kubectl to install with the post installation script if `post_install_module` is set to true"
  default     = "4248b9e621af7e902c9d23bf772a2ee8e50146c5"
}

variable "k8s_sha1sum_kubeadm" {
  description = "The sha1 checksum of the k8s binary kubeadm to install with the post installation script if `post_install_module` is set to true"
  default     = "24d78afbd6bb3dc90cd048a1925eccc7cb4b05db"
}

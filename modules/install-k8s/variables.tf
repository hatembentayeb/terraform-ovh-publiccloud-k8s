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
  default     = "1.14.0"
}

variable "calico_node_version" {
  description = "The version of calico_node to install with the post installation script if `post_install_module` is set to true"
  default     = "3.6.1"
}

variable "calico_cni_version" {
  description = "The version of calico_cni to install with the post installation script if `post_install_module` is set to true"
  default     = "3.6.1"
}

variable "flannel_version" {
  description = "The version of flannel to install with the post installation script if `post_install_module` is set to true"
  default     = "0.11.0"
}

variable "k8s_cni_plugins_version" {
  description = "The version of the cni plugins to install with the post installation script if `post_install_module` is set to true"
  default     = "0.7.5"
}

variable "k8s_sha1sum_cni_plugins" {
  description = "The sha1 checksum of the container cni plugins release to install with the post installation script if `post_install_module` is set to true"
  default     = "52e9d2de8a5f927307d9397308735658ee44ab8d"
}

variable "k8s_sha1sum_kubelet" {
  description = "The sha1 checksum of the k8s binary kubelet to install with the post installation script if `post_install_module` is set to true"
  default     = "c3b736fd0f003765c12d99f2c995a8369e6241f4"
}

variable "k8s_sha1sum_kubectl" {
  description = "The sha1 checksum of the k8s binary kubectl to install with the post installation script if `post_install_module` is set to true"
  default     = "7e3a3ea663153f900cbd52900a39c91fa9f334be"
}

variable "k8s_sha1sum_kubeadm" {
  description = "The sha1 checksum of the k8s binary kubeadm to install with the post installation script if `post_install_module` is set to true"
  default     = "774a2660a841c7a01a6b28aa914aee93eed021c4"
}

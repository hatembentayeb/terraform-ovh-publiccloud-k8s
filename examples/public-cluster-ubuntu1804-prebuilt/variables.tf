variable "region" {
  description = "The Openstack region name"
}

variable "flavor_name" {
  description = "Flavor to use"
  default     = "s1-8"
}

variable "name" {
  description = "The name of the cluster. This attribute will be used to name openstack resources"
  default     = "myk8s"
}

variable "count" {
  description = "Number of nodes in the k8s cluster"
  default     = 3
}

variable "public_sshkey" {
  description = "Key to use to ssh connect"
  default     = ""
}

variable "key_pair" {
  description = "Predefined keypair to use"
  default     = ""
}

variable "remote_ip_prefix" {
  description = "The remote IPv4 prefix used to filter kubernetes API and ssh remote traffic. If left blank, the public NATed IPv4 of the user will be used."
  default     = ""
}

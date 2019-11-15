variable "libvirt_host" {
  description = "The ip or hostname for the KVM host"
  type        = string
}

variable "static_hosts_map" {
  description = "A map of all hosts - applied to edgerouter for dhcp/dns"
  type        = map
}

variable "kvm_hosts_map" {
  description = "A map of KVM domains"
  type        = any
  default     = {}
}

variable "edgerouter_ip" {
  description = "The ip or hostname for the Edgerouter"
  type        = string
}

variable "edgerouter_user" {
  description = "The username to SSH to the Edgerouter"
  type        = string
  default     = "ubnt"
}

variable "ssh_key" {
  type = string
}

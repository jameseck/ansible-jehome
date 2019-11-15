locals {
  name = "centos"
}

resource "libvirt_network" "bridge" {
  name      = "host-bridge"
  mode      = "bridge"
  bridge    = "br0"
  autostart = true
}

resource "libvirt_volume" "centos-base-qcow2" {
  name   = "${local.name}-qcow2"
  pool   = "base"
  source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1907.qcow2c"
  format = "qcow2"
}

module "vm" {
  source = "./modules/vm"

  base_volume_id   = libvirt_volume.centos-base-qcow2.id
  base_volume_pool = "base"
  bridge_network   = libvirt_network.bridge.bridge
  hosts_map        = var.kvm_hosts_map
}

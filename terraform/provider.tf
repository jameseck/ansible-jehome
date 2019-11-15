provider "libvirt" {
  uri = "qemu+ssh://root@${var.libvirt_host}/system"
}

#libvirt_host  = "192.168.0.35"
#edgerouter_ip = "192.168.0.1"

#static_hosts_map = {
#  "pi.iot.je.home" = {
#    ip           = "192.168.4.10",
#    mac          = "b8:27:eb:e7:08:f5",
#    network_name = "IOT",
#    subnet       = "192.168.4.0/24",
#  },
#  "ps3.iot.je.home" = {
#    ip           = "192.168.4.11",
#    mac          = "fc:0f:e6:62:e9:c9",
#    network_name = "IOT",
#    subnet       = "192.168.4.0/24",
#  },
#  "denon.iot.je.home" = {
#    ip           = "192.168.4.12",
#    mac          = "00:05:cd:98:9e:ee",
#    network_name = "IOT",
#    subnet       = "192.168.4.0/24",
#  },
#  "firetv-bedroom.iot.je.home" = {
#    ip           = "192.168.4.13",
#    mac          = "08:a6:bc:a4:3d:77",
#    network_name = "IOT",
#    subnet       = "192.168.4.0/24",
#  },
#  "firetv-livingroom.iot.je.home" = {
#    ip           = "192.168.4.14",
#    mac          = "4c:17:44:1b:62:14",
#    network_name = "IOT",
#    subnet       = "192.168.4.0/24",
#  },
#  "emonpi.iot.je.home" = {
#    ip           = "192.168.4.15",
#    mac          = "b8:27:eb:fa:96:1a",
#    network_name = "IOT",
#    subnet       = "192.168.4.0/24",
#  },
#  "nest.iot.je.home" = {
#    ip           = "192.168.4.16",
#    mac          = "64:16:66:8f:c6:e1",
#    network_name = "IOT",
#    subnet       = "192.168.4.0/24",
#  },
#  "emby.je.home" = {
#    ip           = "192.168.0.21",
#    mac          = "52:54:00:3e:d1:da",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "k8sdev.je.home" = {
#    ip           = "192.168.0.9",
#    mac          = "52:54:00:72:9A:D9",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "k8s.je.home" = {
#    ip           = "192.168.0.6",
#    mac          = "52:54:00:D4:9A:2E",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "laptopw.je.home" = {
#    ip           = "192.168.0.30",
#    mac          = "b4:6b:fc:f5:11:3f",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "laptop.je.home" = {
#    ip           = "192.168.0.31",
#    mac          = "00:e0:4c:68:07:67",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "openshift.je.home" = {
#    ip           = "192.168.0.5",
#    mac          = "52:54:00:c0:7a:01",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "oswg.je.home" = {
#    ip           = "192.168.0.8",
#    mac          = "52:54:00:2a:01:3f",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "os.je.home" = {
#    ip           = "192.168.0.7",
#    mac          = "52:54:00:B1:12:CE",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "pi2.je.home" = {
#    ip           = "192.168.0.11",
#    mac          = "b8:27:eb:81:65:2e",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "pi4.je.home" = {
#    ip           = "192.168.0.14",
#    mac          = "dc:a6:32:0c:56:02",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "pi.je.home" = {
#    ip           = "192.168.0.10",
#    mac          = "b8:27:eb:b2:5d:a0",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "picam.je.home" = {
#    ip           = "192.168.0.41",
#    mac          = "b8:27:eb:d8:e1:45",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "plex.je.home" = {
#    ip           = "192.168.0.20",
#    mac          = "52:54:00:92:be:6c",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "proxy.je.home" = {
#    ip           = "192.168.0.4",
#    mac          = "52:54:00:23:55:3d",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "tplinksw.je.home" = {
#    ip           = "192.168.0.249",
#    mac          = "f0:9f:c2:61:85:84",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "tpswitch.je.home" = {
#    ip           = "192.168.0.249",
#    mac          = "E8:DE:27:41:AF:BF",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "unifiap.je.home" = {
#    ip           = "192.168.0.2",
#    mac          = "f0:9f:c2:f3:ca:2f",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#  "wgproxy.je.home" = {
#    ip           = "192.168.0.49",
#    mac          = "52:54:00:de:8e:97",
#    network_name = "WIRED",
#    subnet       = "192.168.0.0/24",
#  },
#}
#
#kvm_hosts_map = {
#  "k8stest3.je.home" = {
#    ip               = "192.168.0.15",
#    mac              = "52:54:00:92:be:8f",
#    network_name     = "WIRED",
#    subnet           = "192.168.0.0/24",
#    pool             = "default",
#    size             = 17179869184,
#    memory           = 16384,
#    cpu              = 4,
#    ansible_playbook = "kubeadm.yml",
#    ansible_extra_vars = {
#      cluster_domain = "k8stest3.je.home",
#    },
#  },
#  "kproxy.je.home" = {
#    ip               = "192.168.0.16",
#    mac              = "52:54:00:92:be:9f",
#    network_name     = "WIRED",
#    subnet           = "192.168.0.0/24",
#    pool             = "default",
#    size             = 8589934592,
#    memory           = 2048,
#    cpu              = 2,
#    ansible_playbook = "proxy.yml",
#    ansible_extra_vars = {
#    },
#  },
#  "k8scluster1.je.home" = {
#    ip               = "192.168.0.71",
#    mac              = "52:54:00:92:bf:1a",
#    network_name     = "WIRED",
#    subnet           = "192.168.0.0/24",
#    pool             = "default",
#    size             = 17179869184,
#    memory           = 4096,
#    cpu              = 2,
#    ansible_playbook = "noop.yml",
#    ansible_extra_vars = {
#      cluster_domain = "k8scluster.je.home",
#    },
#  },
#  "k8scluster2.je.home" = {
#    ip               = "192.168.0.72",
#    mac              = "52:54:00:92:bf:1b",
#    network_name     = "WIRED",
#    subnet           = "192.168.0.0/24",
#    pool             = "default",
#    size             = 17179869184,
#    memory           = 4096,
#    cpu              = 2,
#    ansible_playbook = "noop.yml",
#    ansible_extra_vars = {
#      cluster_domain = "k8scluster.je.home",
#    },
#  },
#  "k8scluster3.je.home" = {
#    ip               = "192.168.0.73",
#    mac              = "52:54:00:92:bf:1c",
#    network_name     = "WIRED",
#    subnet           = "192.168.0.0/24",
#    pool             = "default",
#    size             = 17179869184,
#    memory           = 4096,
#    cpu              = 2,
#    ansible_playbook = "noop.yml",
#    ansible_extra_vars = {
#      cluster_domain = "k8scluster.je.home",
#    },
#  },
#}

#ssh_key = "ssh-rsa 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 james.eckersall@jameseck-laptop.glo.gb"

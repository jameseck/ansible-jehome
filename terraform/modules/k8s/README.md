This module will be used to create the vm's for a k8s cluster

All vm's created will be of the exact same spec
The module will output a list of the hosts created (ips and maybe hostnames)

What inputs do we need?

count
base_volume_id
base_volume_pool
bridge_network
disk_pool
disk_size
memory
cpu
ssh_key # for root



We don't need any IPs in here

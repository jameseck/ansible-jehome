Ansible vars files:

Static hosts list - used to apply edgerouter config
kvm hosts list - used to trigger terraform to create kvm vm's - ansible will run to configure them afterwards
- count
- starting ip? or separate subnets somehow

k8s clusters list - used to trigger terraform to create kvm vm's - ansible will run to configure the clusters afterwards

ansible filter to generate mac from hostname:
  "{{ '52:54:00' | random_mac(seed=inventory_hostname) }}"


Can also use the virt ansible module to check on running status compared to autostart

#!/bin/bash

set -x

KUBERNETES_PACKAGE_VERSION=1.15.4
KUBERNETES_CLUSTER_VERSION=stable-1.15

yum upgrade -yq
yum install -y docker
systemctl enable docker
systemctl start docker

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

setenforce 0
yum install -y kubelet-${KUBERNETES_PACKAGE_VERSION} kubeadm-${KUBERNETES_PACKAGE_VERSION} kubectl-${KUBERNETES_PACKAGE_VERSION}

yum-config-manager  --disable kubernetes

systemctl enable kubelet
systemctl start kubelet

kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version=${KUBERNETES_CLUSTER_VERSION}

mkdir /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

until kubectl get pods; do
  echo "Waiting for cluster to come up"
  sleep 1
done

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

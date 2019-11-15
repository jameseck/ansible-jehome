#!/bin/bash

set -x

KUBERNETES_PACKAGE_VERSION=1.15.4
KUBERNETES_CLUSTER_VERSION=stable-1.15

yum upgrade -y
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

kubectl taint nodes --all node-role.kubernetes.io/master-kubectl taint nodes --all node-role.kubernetes.io/master-

until [ "$(kubectl get pods --all-namespaces -o json  | jq -r '.items[] | select(.status.phase != "Running" or ([ .status.conditions[] | select(.type == "Ready" and .state == false) ] | length ) == 1 ) | .metadata.namespace + "/" + .metadata.name' | wc -l)" == "0" ]; do
  sleep 1
  echo "Waiting for all pods to be running"
done

curl -L https://github.com/fluxcd/flux/releases/download/1.15.0/fluxctl_linux_amd64 -o /usr/local/bin/fluxctl
chmod +x /usr/local/bin/fluxctl

curl -L https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz | tar xzO linux-amd64/helm > /usr/local/bin/helm
chmod +x /usr/local/bin/helm

kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller-cluster-role --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

helm init --upgrade --service-account tiller --history-max 10 --wait

kubectl apply -f https://raw.githubusercontent.com/fluxcd/flux/helm-0.10.1/deploy-helm/flux-helm-release-crd.yaml
#kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/flux-helm-release-crd.yaml

kubectl create namespace flux
cat <<EOF | kubectl -n flux apply -f -
apiVersion: v1
data:
  identity: LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUJGd0FBQUFkemMyZ3RjbgpOaEFBQUFBd0VBQVFBQUFRRUFwcGFxbUsvM0lLRnJ4NGVvc0xtakRlbjRHRHNkNHZrUktXaTZJKzdNWmdLUlhKWUZ0Vjd0CjZ6R1h6dC91b2cxMlYyMHdlOXczUXBSYmVBSXM4Z0xZZFVkUFl2dEtDR2lrcTBMbXNVcGFZNTgzdDNUKzdGenlOQ0FMTlcKMzFCMG8wSjNsOFhteXd0ZWxFazNuOTlYeFE1aGREUVdpWE16OXdMaSs5c2lsK2RtSTg1TDc2cE51RjZZaUpSc3FoVVlMRgphN3hJREdHVHRkVlVlUE1TOEd6aVFXcjhRNllDNlhhM2VOdFlSczMvWStzcXJKbUJZazVYSTRRVEpjSnllbXdseWM3L1gzCldNUjFhaW5aZ1dZMlJyb2oyVFphWkF2NEtwZWdYM3BLcDd4RkJrYjdLemNPTldVREJXdU5JQTVBOXFOdEFqNGJoaW5HR08KQlkzRThXdFNWd0FBQTlCMHN6MW5kTE05WndBQUFBZHpjMmd0Y25OaEFBQUJBUUNtbHFxWXIvY2dvV3ZIaDZpd3VhTU42ZgpnWU94M2krUkVwYUxvajdzeG1BcEZjbGdXMVh1M3JNWmZPMys2aURYWlhiVEI3M0RkQ2xGdDRBaXp5QXRoMVIwOWkrMG9JCmFLU3JRdWF4U2xwam56ZTNkUDdzWFBJMElBczFiZlVIU2pRbmVYeGViTEMxNlVTVGVmMzFmRkRtRjBOQmFKY3pQM0F1TDcKMnlLWDUyWWp6a3Z2cWsyNFhwaUlsR3lxRlJnc1ZydkVnTVlaTzExVlI0OHhMd2JPSkJhdnhEcGdMcGRyZDQyMWhHemY5ago2eXFzbVlGaVRsY2poQk1sd25KNmJDWEp6djlmZFl4SFZxS2RtQlpqWkd1aVBaTmxwa0MvZ3FsNkJmZWtxbnZFVUdSdnNyCk53NDFaUU1GYTQwZ0RrRDJvMjBDUGh1R0tjWVk0RmpjVHhhMUpYQUFBQUF3RUFBUUFBQVFCME56ZmNQU1lTUllxRE1FaW0Kd1ZyWElocEtEVFBVWEIxMDNmSzlqcUpacUFEd3JsaGRKMVNqZDMySWZRQmxYUzdwM3Vxci9mMHZIWUNTUURKS3cyRnVyOApqYUxLU0JLVDkzbXJ5RmduRjhmbDdJUlg1eU5vVmhoOWxKOU9PenFqaW9NVUJxUHprb0x3d0FObUxORjJUNG45SHpsNXVqCnpPWGQwc0Jyd2piUExxanhYcjZ4TEVjeUNBa1RWRGQrdGQrY3NBVDJIWTduMVBMdW9oWHFrYjcyZXFDWXl0dVBqNjhLR1YKZ0ZKSVMxWWNhVWo1bnJPeCt3VEZBanVVVFFLSmJyZW1pNWM0Z1JsVzVKQUQweGRIQ3Yvb2xnRUZFbk43MVJrdkMzVGhzRgp0dXJrd08vem9Ea1dVMWF1NlNBOWdjVnZSMm9YWUp0MTJoaWdBODFITVE2QkFBQUFnR042TVFLWnltQnlZS1crNGhjTXllCnBBOXJxbElUeXgwUlJ0NkF1V2NHVXZvZjl0UEFLU3NXeVBZQ3JVWGJpQy9QV1Bqd2ZOS0hnSWkwY0p2dElpMHNBeXJOMHcKam5LNWVoUVVtTzlCWnJ0Yk9OaldLN1d1ajg3Tmh1VS83NitoazdvbXJEVnVoMFlwanBJWXJkQnlsTXc0ekNVc3FxY3JWVApMVTZKT0lDKzg2QUFBQWdRRFp4NDR1SnIwMEp0S3UxQkUwc0JsZUFudVI2R1EyNCtPNHozZGp0QTJZc2ZveUtPUDdlYzVtCkUwTFhYTTAwSkZObWNLOGh3TWNEeTlkeXZpa1hyUWZ0cXRHVjY1cFY2Z1lMR1IvZE5lMkg3UDRlZE9LckYva0dYNGJMd0oKUGZrNlFCYjg1cEpFRGdQUGxJSFNrbzAxQnQwc3JqMElsQ1ZtV08yTXBYTDNwTENRQUFBSUVBdzlNeEtDUjMzSCtSWDQ3cQpSM3JFMXJYODFyZHdVbHBTTnM5T2FxeWcvZjJyc3dRcGhrZkZ0ZjYrNFdqaFZvRHBYQmlzS2FOS3lyN0V4TEFkQUorSlcrCk9WeDJqYm0yUmNqWDRIQ2JzWVhINWhDNENXMzNwc3VDWkd0N244K1lVd2h0djljRGIwQVdUT1FVSUc2c0NZKzlqb0lGQ04KbE9HL2lHbS9vdWxxS2w4QUFBQVpjbTl2ZEVCbWJIVjRMV1prWm1Ka05HSmpOUzF6Y0d4bmR3RUMKLS0tLS1FTkQgT1BFTlNTSCBQUklWQVRFIEtFWS0tLS0tCg==
kind: Secret
metadata:
  name: flux-git-auth
type: Opaque
EOF

helm repo add fluxcd https://charts.fluxcd.io

helm upgrade -i flux \
  --set helmOperator.create=true \
  --set helmOperator.createCRD=false \
  --set env.secretName=flux-git-auth \
  --set git.user=jameseck \
  --set git.email=jameseck@users.noreply.github.com \
  --set git.url=git@github.com:jameseck/flux-get-started \
  --namespace flux \
  --wait \
  fluxcd/flux

kubectl -n flux rollout status deployment/flux

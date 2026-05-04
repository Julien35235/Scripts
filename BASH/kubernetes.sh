#!/bin/bash
set -e

echo "=== Désactivation du swap ==="
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

echo "=== Configuration kernel ==="
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
EOF

sysctl --system

echo "=== Installation containerd ==="
apt update
apt install -y containerd curl apt-transport-https gnupg lsb-release

mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

echo "=== Repo Kubernetes ==="
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
  | tee /etc/apt/sources.list.d/kubernetes.list

apt update

echo "=== Installation Kubernetes ==="
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo "=== Init cluster ==="
kubeadm init --pod-network-cidr=192.168.0.0/16

echo "=== Config kubectl ==="
mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "=== Réseau Calico ==="
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo "=== Autoriser scheduling sur control-plane ==="
kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true

echo "=== Installation Helm ==="
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "=== Ajout repo Falco ==="
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

echo "=== Installation Falco ==="
helm install falco falcosecurity/falco \
  --set tty=true \
  --set falco.jsonOutput=true \
  --set falco.logLevel=info

echo "=== Vérification ==="
kubectl get nodes
kubectl get pods -A
kubectl get pods -n default

echo "=== Falco installé ==="
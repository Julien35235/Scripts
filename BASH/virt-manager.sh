#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation de qemu-kvm et de virt-manager 
sudo apt install -y qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
#Activation du service libvirtd en automatique
systemctl enable --now libvirtd
sudo virsh net-start default
sudo virsh net-autostart default
sudo modprobe vhost_net


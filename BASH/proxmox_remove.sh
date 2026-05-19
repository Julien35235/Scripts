#!/bin/bash
#Desinstallion de Proxmox VE depuis Debian
sudo apt remove --purge proxmox-ve pve-manager pve-kernel* pve-qemu-kvm pve-container -y
#Nettoyage des packets
sudo apt autoremove --purge -y
sudo apt install linux-image-amd64 -y
#Mise à jour du Grub
update-grub
#Suppresion des dépots de Proxmox 
rm /etc/apt/sources.list.d/pve-install-repo.list
rm /etc/apt/trusted.gpg.d/proxmox-release.gpg

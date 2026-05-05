#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation des packets nécessaire 
sudo apt install wget -y
#Ajouter la clé GPG au système
sudo wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg \
  -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
#Ajouter les dépots de PBS au système 
sudo echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" \
  | sudo tee -a /etc/apt/sources.list.d/proxmox-backup-server.list
#Installation du serveur de PBS
sudo apt update && sudo apt install proxmox-backup -y
#Redemarrage du serveur 
sudo reboot
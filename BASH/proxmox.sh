#!/bin/bash
#Affichage de l'adresse IP de la machine
hostname --ip-address
#Mise à jour du système
sudo apt update && sudo apt full-upgrade
#Installation des outils nécessaires pour ajouter des dépôts sécurisés
sudo apt install curl software-properties-common apt-transport-https ca-certificates gnupg2 
#Ajoute le dépot de Proxmox au système
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" >
/etc/apt/sources.list.d/pve-install-repo.list
#Mise à jour de la liste des logiciels après ajout du dépôt
sudo apt update 
#Installation de Proxmox VE 
sudo apt install proxmox-default-kernel proxmox-ve postfix open-iscsi chrony-y
#Mise à jour du menu de démarrage du système
update-grub
#Redemmarage du système
sudo reboot

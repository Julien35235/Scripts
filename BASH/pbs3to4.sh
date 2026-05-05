#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#On exécute ensuite le script de vérification d'upgrade
pbs3to4
systemctl disable --now systemd-timesyncd
apt install -y chrony
systemctl enable --now chrony
#J'arrête les services PBS pour éviter qu'une tâche planifiée se déclenche
systemctl stop proxmox-backup   
systemctl stop proxmox-backup-proxy.service 
#On remplace ensuite le nom de code de Debian dans les sources.list
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list 
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Redemarrage du système
sudo reboot
#!/bin/bash
# Ajout du dépôt de Proxmox à la liste des sources
cat > /etc/apt/sources.list.d/pve-install-repo.sources << EOL
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOL
#Mise à jour du système
sudo apt update && apt full-upgrade -y
#Installation de Proxmox VE 
sudo apt install proxmox-default-kernel proxmox-ve postfix open-iscsi chrony -y
# Mise à jour de GRUB pour appliquer les changements de noyau
update-grub
# Redémarrage du système pour appliquer les modifications
sudo reboot

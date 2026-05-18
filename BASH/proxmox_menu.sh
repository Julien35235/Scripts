#!/bin/bash
# Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation de Proxmox_menu
bash -c "$(wget -qLO - https://raw.githubusercontent.com/MacRimi/ProxMenux/main/install_proxmenux.sh)"

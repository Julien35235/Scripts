#!/bin/bash
# Mets à jour le système
#Installation de sudo
apt install sudo -y
sudo apt update && sudo apt full-upgrade -y
bash -c "$(wget -qLO - https://raw.githubusercontent.com/MacRimi/ProxMenux/main/install_proxmenux.sh)"

#!/bin/bash
# Mets à jour le système 
sudo apt update && sudo apt upgrade -y
# Rendre le dossier tmp
sudo cd /tmp
# Téléchargement du serveur IPBX 
sudo wget https://github.com/FreePBX/sng_freepbx_debian_install/raw/master/sng_freepbx_debian_install.sh -O /tmp/sng_freepbx_debian_install.sh
# Installation du serveur IPBX VOIP
sudo bash /tmp/sng_freepbx_debian_install.sh
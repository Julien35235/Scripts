#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation des packets
sudo apt install wget nala htop curl apt-transport-https sudo -y 
#Installation du serveur de Multimedia
wget -O- https://repo.jellyfin.org/install-debuntu.sh |  bash
#Activation du demarrage automatique du serveur de multimedia
sudo systemctl enable --now jellyfin.service

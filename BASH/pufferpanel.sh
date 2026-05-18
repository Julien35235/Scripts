#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation de git curl ZIP
sudo apt install git curl unzip nala htop wget -y
#Installation de PufferPanel
sudo curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash
sudo apt install pufferpanel -y 
#Ajoute un utilisateur avec PufferPanel
pufferpanel user add
#Activation du demarrage du service de PufferPanel
sudo systemctl enable --now pufferpanel

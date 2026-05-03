#!/bin/bash
#Mise a jour du système
sudo apt update && sudo apt full-upgrade
#Test si le serveur est compatible avec PVE9
pve8to9
#Remplacement des dépôts de Debian
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
#Mise a jour du système
sudo apt update 
sudo apt full-upgrade
#Redemarrage du serveur 
sudo reboot

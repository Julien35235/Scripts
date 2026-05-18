#!/bin/bash
#Info sur le système 
lsb_release -a
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation de Ubuntu-release-upgrader-core et du fiewall
sudo apt install ufw nala htop ubuntu-release-upgrader-core -y
#Autoriser le trafic entrant sur le port 1022 en TCP via le pare-feu UFW
sudo ufw allow 1022/tcp
#Rechargement de la configuration du pare-feu UFW
sudo ufw reload
#Lancement de la mise à niveau officielle recommandée par Ubuntu.
sudo do-release-upgrade 
sudo do-release-upgrade -d
#Redemarrage du système
sudo reboot

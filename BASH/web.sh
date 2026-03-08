#!/bin/bash
# mets à jour mon système 
apt update
apt full-upgrade -y 
# installation du serveur web apache2 et de ses dépendances 
sudo apt install htop sudo nala atop apache2 

#Demarrage du serveur activation du démarrage en automatique en utilisant la commande systemd
sudo systemctl enable apache2
sudo systemctl start apache2


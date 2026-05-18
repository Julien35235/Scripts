#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation du serveur WEB avec Apache2
sudo apt installl htop nala apache2 -y
#Activation du service de démarrage du serveur WEB Apache2 
sudo systemctl enable apache2
#Demarrage du serveur WEB Apache2 
sudo systemctl start apache2

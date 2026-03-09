#!/bin/bash
# Mets à jour le système 
sudo apt update && sudo apt full-upgrade -y
#Installation de phpMyAdmin et Apache2, Mariadb servers
sudo apt install phpmyadmin libapache2-mod-php apache2 nala htop mariadb-server -y
#Activation du demarrage automatique du serveur web
systemctl enable apache2 
systemctl start apache2


#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation des packets 
sudo apt install software-properties-common htop -y
#Ajouter le dépot de PHP au systeme
sudo add-apt-repository ppa:ondrej/php
#Acttualisation des mises à jour 
sudo apt update
#Installation de PHP
sudo apt install php8.2
#Redemarrage du serveur web 
sudo service apache2 restart
sudo update-alternatives --config php
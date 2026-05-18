#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation des outils nécessaires pour ajouter des dépôts sécurisés
sudo install nala htop curl ufw -y
cd /opt
#Recuperation du script d'installation de Webmin en utilisant la commmande curl
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
#Installation de Webmin
sudo sh setup-repos.sh
#Mise à jour de la liste des logiciels après ajout du dépôt
sudo apt update 
#Installation de Webmin
sudo apt install webmin --install-recommends -y
#Demmarrage du service de Webmin
service webmin start
service webmin restart
#Autorisation des overtures des ports au niveau du firewall  
sudo ufw allow 22
sudo ufw allow 10000
sudo ufw enable

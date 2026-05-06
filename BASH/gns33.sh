#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation des dépendances nécessaires
sudo apt install -y ca-certificates curl gnupg lsb-release
#Ajouter le dépot de GNS33 au système 
sudo add-apt-repository ppa:gns3/ppa
#Mise à jour du système
sudo apt update        
#Installation de GNS33                        
sudo apt install gns3-gui gns3-server

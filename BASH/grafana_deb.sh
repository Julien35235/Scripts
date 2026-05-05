#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation des packets nécessaire 
sudo apt install apt-transport-https software-properties-common -y
#Ajouter la clé GPG au système
wget -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
#Ajouter le dépot de Grafana au système
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
#Mise à jour du système 
sudo apt update 
#Installation du serveur de Grafana
sudo apt install grafana -y

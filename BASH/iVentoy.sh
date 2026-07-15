#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation de wget 
sudo apt install wget nala htop -y 
cd /opt
#Recuperation de iVentoy depuis GitHub en utilisant la commande wget
wget https://github.com/ventoy/PXE/releases/download/v1.0.21/iventoy-1.0.21-linux-free.tar.gz
#Extration de l'archive de iVentoy avec la commande tar
tar xzvf iventoy-1.0.21-linux-free.tar.gz
#Suppersion de l'archive de iVentoy 
rm iventoy-1.0.19-linux-free.tar.gz
#Rennomage de l'archive de iVentoy
mv iventoy-1.0.19 iventoy
cd /opt/iventoy
#Demmarage du serveur PXE
sudo bash iventoy.sh start


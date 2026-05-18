#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Ajouter le dépot Cubic aux système
sudo apt-add-repository ppa:cubic-wizard/release
#Actualisation des mises à jour
sudo apt update
#Installation du logicels de Cubic
sudo apt install cubic -y
#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation de docker et de GIT
sudo apt install docker-compose docker.io python3-pip htop nala git -y
cd /opt
#Creation du répetoire de Docker
mkdir docker 
cd docker
#Clonnage du repository de Isoman
sudo git clone https://github.com/aloks98/isoman.git
cd isoman
#lancement du conteneur de ISOMAN
docker compose up -d

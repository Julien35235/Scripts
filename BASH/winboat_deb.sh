#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation des packets nécessaire pour Docker et wget
sudo apt install docker.io wget -y
#Activation du démarrage automatique de docker
sudo systemctl enable docker
#Démarrage de Docker
sudo systemctl start docker
sudo usermod -aG docker $USER
#Installation de freerdp3
sudo apt install freerdp3-x11 -y
cd /opt
wget https://github.com/TibixDev/winboat/releases/download/v0.9.0/winboat-0.9.0-amd64.deb
apt install ./winboat-0.9.0-amd64.deb -y


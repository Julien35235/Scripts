#!/bin/bash
#Mise à jour du système 
sudo dnf update
sudo dnf upgrade -y
#Installation des packets nécessaire pour Docker et wget
sudo dnf install docker.io wget -y
#Activation du démarrage automatique de docker
sudo systemctl enable docker
#Démarrage de Docker
sudo systemctl start docker
sudo usermod -aG docker $USER
#Installation de freerdp3
sudo dnf install freerdp3-x11 -y
cd /opt
#Recuperation de winboat en utilisant la commande wget
wget https://github.com/TibixDev/winboat/releases/download/v0.9.0/winboat-0.9.0-amd64.deb
#Installation de Winboat
dnf install ./winboat-0.9.0-amd64.deb -y


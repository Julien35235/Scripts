#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation des packets nécessaire pour Docker et wget
sudo apt install docker.io wget apt-transport-https ca-certificates curl gnupg2 -y
sudo usermod -aG docker $USER
#Ajouter le dépôt officiel Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
#Mise à jour du système
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
#Activation du démarrage automatique de docker
sudo systemctl enable docker
#Démarrage de Docker
sudo systemctl start docker
#Installation de freerdp3
sudo apt install freerdp3-x11 -y
cd /opt
#Recuperation de winboat en utilisant la commande wget
wget https://github.com/TibixDev/winboat/releases/download/v0.9.0/winboat-0.9.0-amd64.deb
#Installation de Winboat
apt install ./winboat-0.9.0-amd64.deb -y


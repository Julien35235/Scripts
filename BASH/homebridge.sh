#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de wget et curl
sudo apt install nala htop wget curl -y
# Ajouter le dépot de Homebrige
sudo curl -sSfL https://repo.homebridge.io/KEY.gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/homebridge.gpg  > /dev/null
echo "deb [signed-by=/usr/share/keyrings/homebridge.gpg] https://repo.homebridge.io stable main" | sudo tee /etc/apt/sources.list.d/homebridge.list > /dev/null
#Mise à jour du système 
sudo apt update
#Installation de Homebridge 
sudo apt install homebridge -y
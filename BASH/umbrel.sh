#!/bin/bash
# Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation de curl et de htop nala
sudo apt install nala curl htop wget -y
#Installation de Umbrelos 
curl -L https://umbrel.sh | bash
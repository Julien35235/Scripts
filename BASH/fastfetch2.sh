#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#installation de wget 
sudo apt install wget curl htop nala -y
#se déplacer dans opt
cd /opt
#Recuperation de fastfetch en utilisant la commande wget
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.62.1/fastfetch-linux-amd64.deb
#installation de fastfetch 
apt install ./fastfetch-linux-amd64.deb -y

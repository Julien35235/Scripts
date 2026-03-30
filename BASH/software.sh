#!/bin/bash
# mets à jour mon système 
sudo apt update && sudo apt full-upgrade 
# installation de htop sudo nala atop pour Debian 
sudo apt install htop sudo nala atop wget -y
cd /opt
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.61.0/fastfetch-linux-amd64.deb
sudo apt install ./fastfetch-linux-amd64.deb



#!/bin/bash
# mise à jour du système
sudo apt update && sudo apt full-upgrade -y
# Installations des packets 
sudo apt installl htop nala wget -y
# Téléchargements de l'agent GLPI
wget https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent-1.15-linux-installer.pl
# Installation et la configuration de l'agent GLPI
sudo perl glpi-agent-linux-installer.pl
glpi-agent –force 


#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation de l'enviromment bureau de Gnome dans Debian avec XRDP
sudo apt install install -y gnome-core gdm3 xrdp
#Demarrage du service XRDP
sudo service xrdp start 
#Redemmarage du système
sudo reboot

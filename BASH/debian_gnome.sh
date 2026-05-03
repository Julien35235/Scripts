#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l'enviromment bureau de Gnome dans Debian
apt install install -y gnome-core gdm3 
sudo reboot
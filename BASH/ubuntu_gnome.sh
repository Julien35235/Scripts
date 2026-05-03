#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l'enviromment bureau de Gnome dans Ubuntu
sudo apt install ubuntu-desktop-minimal -y
sudo reboot
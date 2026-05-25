#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l’environnement de bureau XFCE et XRDP
sudo apt install kali-desktop-xfce xrdp-y
#Demarrage du service XRDP
sudo service xrdp start 
#Redemarrage du système
sudo reboot

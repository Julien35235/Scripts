#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l’environnement de bureau GNOME
sudo apt install kali-desktop-gnome -y
#Redemarrage du système
sudo reboot
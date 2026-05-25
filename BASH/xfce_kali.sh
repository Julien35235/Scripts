#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l’environnement de bureau XFCE
sudo apt install kali-desktop-xfce-y
#Redemarrage du système
sudo reboot

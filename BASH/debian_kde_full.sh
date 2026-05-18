#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l'enviromment bureau de KDE full dans Debian
sudo apt install install kde-full -y
#Redemmarage du système
sudo reboot

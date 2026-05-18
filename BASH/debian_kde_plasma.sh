#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l'enviromment bureau de KDE Plasma Desktop dans Debian
sudo apt install install kde-plasma-desktop -y
#Redemmarage du système
sudo reboot

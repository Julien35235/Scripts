#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l'enviromment bureau de KDE standard dans Debian
sudo apt install install kde-standard -y
sudo reboot